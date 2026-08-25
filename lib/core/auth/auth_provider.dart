import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/core/auth/auth_service.dart';
import 'package:polytick_app/core/models/user_model.dart';
import 'package:polytick_app/core/models/subscription_model.dart';
import 'package:polytick_app/core/models/referral_data_model.dart';

// ════════════════════════════════════════════════════════════
//  AUTH STATE
// ════════════════════════════════════════════════════════════

/// Complete auth state — equivalent of all useState() calls in AuthContext.
class AuthState {
  final UserModel? currentUser;
  final SubscriptionModel? subscription;
  final ReferralDataModel referralData;
  final bool loading;
  final bool isAuthenticated;

  const AuthState({
    this.currentUser,
    this.subscription,
    this.referralData = const ReferralDataModel(),
    this.loading = true,
    this.isAuthenticated = false,
  });

  /// isRestricted: logged in but no active subscription.
  /// Must be false for unauthenticated visitors (no gates on public pages).
  /// Must be false for paid/trial subscribers (full access).
  bool get isRestricted => currentUser != null && subscription == null;

  AuthState copyWith({
    UserModel? currentUser,
    SubscriptionModel? subscription,
    ReferralDataModel? referralData,
    bool? loading,
    bool? isAuthenticated,
    bool clearUser = false,
    bool clearSubscription = false,
  }) {
    return AuthState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      subscription: clearSubscription ? null : (subscription ?? this.subscription),
      referralData: referralData ?? this.referralData,
      loading: loading ?? this.loading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// ════════════════════════════════════════════════════════════
//  AUTH NOTIFIER — Riverpod equivalent of AuthProvider
// ════════════════════════════════════════════════════════════

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _init();
  }

  /// Initialize auth on app startup — mirrors the useEffect in AuthContext.
  Future<void> _init() async {
    try {
      final result = await _authService.initAuth();
      state = AuthState(
        currentUser: result.user,
        subscription: result.subscription,
        referralData: result.referralData,
        loading: false,
        isAuthenticated: result.user != null,
      );
    } catch (e) {
      debugPrint('Auth init error: $e');
      state = const AuthState(loading: false);
    }
  }

  /// Called after magic link / OTP verification succeeds.
  /// Stores the token, extracts user, fetches subscription.
  Future<void> onAuthSuccess(String token) async {
    try {
      final user = await _authService.setToken(token);
      final (sub, referral) = await _authService.fetchSubscriptionStatus();
      state = AuthState(
        currentUser: user,
        subscription: sub,
        referralData: referral,
        loading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      debugPrint('Auth success handling failed: $e');
    }
  }

  /// Refresh subscription status (e.g. after Stripe checkout).
  Future<void> refreshSubscription() async {
    final (sub, referral) = await _authService.fetchSubscriptionStatus();
    state = state.copyWith(subscription: sub, referralData: referral);
  }

  /// Activate subscription from Stripe session.
  Future<Map<String, dynamic>> activateSubscription(String email, String sessionId) async {
    final result = await _authService.activateSubscription(email, sessionId);
    if (result['success'] == true) {
      await refreshSubscription();
    }
    return result;
  }

  /// Login as a designated Google Play reviewer / demo user with active Pro status.
  Future<void> loginAsReviewer() async {
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

    await _authService.persistReviewerSession();

    state = const AuthState(
      currentUser: reviewerUser,
      subscription: reviewerSub,
      referralData: ReferralDataModel(
        accountCredit: 100.0,
        referralCode: 'google_reviewer',
      ),
      loading: false,
      isAuthenticated: true,
    );
  }

  /// Logout — mirrors AuthContext.logout().
  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(
      loading: false,
      isAuthenticated: false,
    );
  }

  /// Delete Account — permanently deletes the account and wipes local auth state.
  Future<Map<String, dynamic>> deleteAccount() async {
    final result = await _authService.deleteAccount();
    if (result['success'] == true) {
      state = const AuthState(
        loading: false,
        isAuthenticated: false,
      );
    }
    return result;
  }
}

// ════════════════════════════════════════════════════════════
//  PROVIDERS
// ════════════════════════════════════════════════════════════

/// The auth service instance.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// The main auth state provider — use this throughout the app.
///
/// Usage:
/// ```dart
/// final authState = ref.watch(authProvider);
/// final user = authState.currentUser;
/// final isLoggedIn = authState.isAuthenticated;
///
/// // To trigger actions:
/// ref.read(authProvider.notifier).logout();
/// ```
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// ── Convenience selectors ──

/// Whether auth is still loading on startup.
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).loading;
});

/// Whether user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Current user (nullable).
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).currentUser;
});

/// Current subscription (nullable).
final subscriptionProvider = Provider<SubscriptionModel?>((ref) {
  return ref.watch(authProvider).subscription;
});

/// Whether user is restricted (logged in but no subscription).
final isRestrictedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isRestricted;
});

/// Referral data.
final referralDataProvider = Provider<ReferralDataModel>((ref) {
  return ref.watch(authProvider).referralData;
});
