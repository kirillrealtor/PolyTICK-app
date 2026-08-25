import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/auth/token_storage.dart';
import 'package:polytick_app/core/models/user_model.dart';
import 'package:polytick_app/core/models/subscription_model.dart';
import 'package:polytick_app/core/models/referral_data_model.dart';

/// Auth service — equivalent of `AuthContext.js` business logic.
///
/// Handles:
/// - Magic link send / poll / OTP confirm
/// - Token refresh (rolling 28-day session)
/// - Subscription status checking
/// - Auto-trial activation
/// - Logout
///
/// Google Sign-In is DISABLED — see comments below.
class AuthService {
  final TokenStorage _tokenStorage;
  final ApiClient _api;
  bool _hasAttemptedAutoTrial = false;

  AuthService({
    TokenStorage? tokenStorage,
    ApiClient? api,
  })  : _tokenStorage = tokenStorage ?? TokenStorage(),
        _api = api ?? ApiClient.instance;

  // ════════════════════════════════════════════════════════════
  //  INIT — Called on app startup (mirrors AuthContext useEffect)
  // ════════════════════════════════════════════════════════════

  /// Initialize auth state from stored token or persistent reviewer session.
  /// Returns (user, subscription, referralData) or nulls.
  Future<({UserModel? user, SubscriptionModel? subscription, ReferralDataModel referralData})> initAuth() async {
    // 1. Check for persistent Google Play Reviewer / Demo session
    final isReviewer = await _tokenStorage.isReviewerSession();
    if (isReviewer) {
      const reviewerUser = UserModel(
        email: 'google-review@polytick.us',
        fullName: 'Google Play Reviewer',
        isVerified: true,
      );
      const reviewerSub = SubscriptionModel(
        status: 'active',
        isTrial: false,
        daysRemaining: 365,
        productName: 'Yearly Pro Plan',
        interval: 'year',
      );
      return (
        user: reviewerUser,
        subscription: reviewerSub,
        referralData: const ReferralDataModel(
          accountCredit: 100.0,
          referralCode: 'google_reviewer',
        ),
      );
    }

    final token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      return (user: null, subscription: null, referralData: ReferralDataModel.empty());
    }

    UserModel? user;
    try {
      final decoded = JwtDecoder.decode(token);
      user = UserModel.fromJwt(decoded);
    } catch (e) {
      debugPrint('Initial token decode notice: $e');
    }

    // ── Rolling session refresh (Claude-style) ──
    // Every app open refreshes the session to 28 days.
    try {
      final refreshResponse = await _api.post(ApiConfig.refreshToken);
      final newToken = refreshResponse.data?['access_token'] as String?;
      if (newToken != null && newToken.isNotEmpty) {
        await _tokenStorage.setToken(newToken);
        final newDecoded = JwtDecoder.decode(newToken);
        user = UserModel.fromJwt(newDecoded);
      }
    } on DioException catch (e) {
      // If backend explicitly rejected the token as unauthorized (401), wipe and logout
      if (e.response?.statusCode == 401) {
        await logout();
        return (user: null, subscription: null, referralData: ReferralDataModel.empty());
      }
      // Non-auth errors (network offline, server temporary hiccup) are silently ignored — user keeps existing token!
      debugPrint('Session refresh skipped (offline/network): ${e.message}');
    } catch (e) {
      debugPrint('Session refresh non-dio error: $e');
    }

    // If user could not be decoded and token has expired with no refresh, then logout
    if (user == null && JwtDecoder.isExpired(token)) {
      await logout();
      return (user: null, subscription: null, referralData: ReferralDataModel.empty());
    }

    // ── Fetch subscription status ──
    try {
      final (sub, referral) = await fetchSubscriptionStatus();
      return (user: user, subscription: sub, referralData: referral);
    } catch (e) {
      debugPrint('Subscription check during init failed: $e');
      return (user: user, subscription: null, referralData: ReferralDataModel.empty());
    }
  }

  /// Persists a reviewer session so app restarts keep the reviewer logged in.
  Future<void> persistReviewerSession() async {
    await _tokenStorage.setReviewerSession(true);
  }

  // ════════════════════════════════════════════════════════════
  //  SUBSCRIPTION STATUS
  // ════════════════════════════════════════════════════════════

  /// Fetch subscription status — mirrors `fetchSubscriptionStatus()` in AuthContext.
  Future<(SubscriptionModel?, ReferralDataModel)> fetchSubscriptionStatus() async {
    final token = await _tokenStorage.getToken();
    if (token == null) return (null, ReferralDataModel.empty());

    try {
      final response = await _api.get(ApiConfig.checkAccessSecure);
      final data = response.data as Map<String, dynamic>?;
      if (data == null) return (null, ReferralDataModel.empty());

      String? refCode = data['referral_code'] as String?;
      if (refCode == null || refCode.trim().isEmpty) {
        try {
          final decoded = JwtDecoder.decode(token);
          final userEmail = decoded['sub'] as String?;
          if (userEmail != null && userEmail.isNotEmpty) {
            refCode = userEmail.split('@')[0].replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
          }
        } catch (_) {}
      }

      final referralData = ReferralDataModel(
        accountCredit: (data['account_credit'] as num?)?.toDouble() ?? 0.0,
        referralCode: refCode,
        hasUsedReferral: data['has_used_referral'] == true,
      );

      if (data['status'] == 'active') {
        final sub = SubscriptionModel.fromJson(data);
        return (sub, referralData);
      }

      // ── Auto-trial activation (same as web) ──
      if (!_hasAttemptedAutoTrial) {
        _hasAttemptedAutoTrial = true;
        try {
          final decoded = JwtDecoder.decode(token);
          final userEmail = decoded['sub'] as String?;
          if (userEmail != null) {
            final trialResponse = await _api.post(
              ApiConfig.startFreeTrial,
              data: {'email': userEmail},
            );

            if (trialResponse.data?['status'] == 'success') {
              final retryResponse = await _api.get(ApiConfig.checkAccessSecure);
              final retryData = retryResponse.data as Map<String, dynamic>?;
              if (retryData?['status'] == 'active') {
                final sub = SubscriptionModel.fromJson(retryData!);
                return (sub, referralData);
              }
            }
          }
        } catch (e) {
          debugPrint('Auto-trial activation failed: $e');
        }
      }

      return (null, referralData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await logout();
      }
      return (null, ReferralDataModel.empty());
    }
  }

  // ════════════════════════════════════════════════════════════
  //  MAGIC LINK AUTH (mirrors LoginContent.jsx)
  // ════════════════════════════════════════════════════════════

  /// Send magic link email.
  /// Returns the device_id from the response (for polling).
  Future<String?> sendMagicLink({
    required String email,
    String? deviceId,
    String? referralCode,
  }) async {
    final url = referralCode != null
        ? '${ApiConfig.magicLink}?ref=${Uri.encodeComponent(referralCode)}'
        : ApiConfig.magicLink;

    final response = await _api.post(url, data: {
      'email': email,
      'device_id': deviceId,
    });

    final returnedDeviceId = response.data?['device_id'] as String?;
    if (returnedDeviceId != null) {
      await _tokenStorage.setDeviceId(returnedDeviceId);
    }
    return returnedDeviceId;
  }

  /// Poll for magic link verification.
  /// Returns: { status: 'success', token: '...' } or { status: 'display_code', code: '...' }
  Future<Map<String, dynamic>> pollMagicCode({String? deviceId}) async {
    final devId = deviceId ?? await _tokenStorage.getDeviceId();
    final params = devId != null ? {'device_id': devId} : <String, dynamic>{};

    final response = await _api.get(
      ApiConfig.pollMagicCode,
      queryParameters: params,
    );

    return response.data as Map<String, dynamic>;
  }

  /// Confirm OTP code (cross-device flow).
  Future<String?> confirmMagicCode({
    required String code,
    String? deviceId,
  }) async {
    final devId = deviceId ?? await _tokenStorage.getDeviceId();
    final response = await _api.post(ApiConfig.confirmMagicCode, data: {
      'code': code.trim(),
      'device_id': devId,
    });
    return response.data?['token'] as String?;
  }

  // ════════════════════════════════════════════════════════════
  //  TOKEN MANAGEMENT
  // ════════════════════════════════════════════════════════════

  /// Store token and extract user — called after successful auth.
  Future<UserModel> setToken(String token) async {
    await _tokenStorage.setToken(token);
    final decoded = JwtDecoder.decode(token);
    return UserModel.fromJwt(decoded);
  }

  // ════════════════════════════════════════════════════════════
  //  GOOGLE SIGN-IN — CURRENTLY DISABLED
  // ════════════════════════════════════════════════════════════
  //
  // To enable Google Sign-In:
  //
  // 1. Add `google_sign_in` to pubspec.yaml
  // 2. Configure iOS/Android client IDs (see pubspec.yaml comments)
  // 3. Uncomment this method:
  //
  // Future<UserModel> googleLogin() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  //   final account = await googleSignIn.signIn();
  //   if (account == null) throw Exception('Google sign in cancelled');
  //
  //   final auth = await account.authentication;
  //   final credential = auth.accessToken;
  //   if (credential == null) throw Exception('No credential received');
  //
  //   final response = await _api.post(ApiConfig.googleAuth, data: {
  //     'access_token': credential,
  //     'token_type': 'bearer',
  //   });
  //
  //   final token = response.data['access_token'] as String;
  //   return setToken(token);
  // }
  // ════════════════════════════════════════════════════════════

  // ════════════════════════════════════════════════════════════
  //  SUBSCRIPTION ACTIVATION
  // ════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> activateSubscription(String email, String sessionId) async {
    try {
      final response = await _api.post(ApiConfig.submitEmail, data: {
        'email': email,
        'session_id': sessionId,
      });
      return {'success': true, 'message': response.data?['message'] ?? 'Activated'};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data?['detail'] ?? 'Activation failed',
      };
    }
  }

  // ════════════════════════════════════════════════════════════
  //  LOGOUT & ACCOUNT DELETION (Apple Guideline 5.1.1)
  // ════════════════════════════════════════════════════════════

  Future<void> logout() async {
    await _tokenStorage.clearAll();
    _hasAttemptedAutoTrial = false;
    ApiClient.reset();
  }

  /// Permanently deletes the current user account and wipes local session data.
  Future<Map<String, dynamic>> deleteAccount() async {
    final isReviewer = await _tokenStorage.isReviewerSession();
    if (isReviewer) {
      await logout();
      return {'success': true, 'message': 'Account successfully deleted.'};
    }

    try {
      final response = await _api.delete(ApiConfig.deleteAccount);
      await logout();
      return {
        'success': true,
        'message': response.data?['message'] ?? 'Account successfully deleted.',
      };
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        await logout();
        return {'success': true, 'message': 'Account successfully deleted.'};
      }
      return {
        'success': false,
        'message': e.response?.data?['detail'] ?? 'Failed to delete account. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to delete account: $e',
      };
    }
  }
}
