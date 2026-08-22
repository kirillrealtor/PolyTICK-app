import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:polytick_app/core/auth/token_storage.dart';

/// Injects the Bearer token into every request.
/// Equivalent of the axios request interceptor in clientApi.js.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Identify mobile app requests so backend can differentiate
    options.headers['X-Platform'] = 'mobile-app';

    handler.next(options);
  }
}

/// Handles 401 and 403 responses globally.
/// Equivalent of the axios response interceptor in clientApi.js:
///   - 401 → clear token, redirect to login
///   - 403 SUBSCRIPTION_REQUIRED → redirect to pricing
///   - 403 EMAIL_VERIFICATION_REQUIRED → let error bubble up
class ErrorInterceptor extends Interceptor {
  /// Called by auth_provider to handle forced logout navigation.
  /// Set this callback after the app initializes with a router reference.
  static VoidCallback? onForceLogout;

  /// Called when backend returns 403 SUBSCRIPTION_REQUIRED.
  static VoidCallback? onSubscriptionRequired;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (statusCode == 401) {
      final tokenStorage = TokenStorage();
      final isReviewer = await tokenStorage.isReviewerSession();
      if (!isReviewer) {
        // Only trigger force logout on core auth endpoints (/auth/ or /check-access-secure),
        // preventing accidental logouts from secondary features or network glitches
        if (path.contains('/auth/') || path.contains('/check-access-secure')) {
          await tokenStorage.clearToken();
          onForceLogout?.call();
        }
      }
    }

    if (statusCode == 403) {
      final data = err.response?.data;
      if (data is Map<String, dynamic>) {
        final detail = data['detail'];
        if (detail is Map<String, dynamic> && detail['code'] == 'SUBSCRIPTION_REQUIRED') {
          onSubscriptionRequired?.call();
        }
        // EMAIL_VERIFICATION_REQUIRED: do NOT hard-redirect.
        // Let the error bubble up so the calling screen can surface
        // a contextual banner/toast in-place without losing the
        // user's current position in the app.
      }
    }

    handler.next(err);
  }
}
