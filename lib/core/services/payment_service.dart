import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';

class PaymentService {
  final ApiClient _api;

  PaymentService({ApiClient? api}) : _api = api ?? ApiClient.instance;

  static PaymentService? _instance;
  static PaymentService get instance => _instance ??= PaymentService();

  // ════════════════════════════════════════════════════════════
  //  CHECKOUT SESSIONS
  // ════════════════════════════════════════════════════════════

  /// Create a Monthly Checkout Session ($14.99/mo).
  /// Returns a Map containing `checkout_url` and `session_id`.
  Future<Map<String, dynamic>> createMonthlyCheckout({
    required String email,
    String? name,
    String? referralCode,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.createCheckoutSession,
        data: {
          'email': email,
          if (name != null && name.isNotEmpty) 'name': name,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('Monthly checkout error: ${e.response?.data}');
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          'Failed to create checkout session';
      throw Exception(msg);
    }
  }

  /// Create a Yearly Checkout Session ($149.99/yr).
  /// Returns a Map containing `checkout_url` and `session_id`.
  Future<Map<String, dynamic>> createYearlyCheckout({
    required String email,
    String? name,
    String? referralCode,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.createYearlyCheckoutSession,
        data: {
          'email': email,
          if (name != null && name.isNotEmpty) 'name': name,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('Yearly checkout error: ${e.response?.data}');
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          'Failed to create yearly checkout session';
      throw Exception(msg);
    }
  }

  /// Create an Elite Coaching Checkout Session ($999/mo).
  /// Returns a Map containing `checkout_url` and `session_id`.
  Future<Map<String, dynamic>> createCoachingCheckout({
    required String email,
    String? name,
    String? referralCode,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.createCoachingCheckoutSession,
        data: {
          'email': email,
          if (name != null && name.isNotEmpty) 'name': name,
          if (referralCode != null && referralCode.isNotEmpty)
            'referral_code': referralCode,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('Coaching checkout error: ${e.response?.data}');
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          'Failed to create coaching checkout session';
      throw Exception(msg);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  FREE TRIAL ACTIVATION
  // ════════════════════════════════════════════════════════════

  /// Activate 14-Day Free Trial for an account without a card.
  Future<Map<String, dynamic>> startFreeTrial(String email) async {
    try {
      final response = await _api.post(
        ApiConfig.startFreeTrial,
        data: {'email': email},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['status'] == 'success' || (data['message'] as String?)?.contains('success') == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to activate free trial');
      }
    } on DioException catch (e) {
      debugPrint('Free trial activation error: ${e.response?.data}');
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          'Failed to activate free trial. You may have already used it.';
      throw Exception(msg);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  ACCESS VERIFICATION & DETAILS
  // ════════════════════════════════════════════════════════════

  /// Check subscription access by email (used by SubscriptionModal).
  Future<String> checkAccess(String email) async {
    try {
      final response = await _api.post(
        ApiConfig.checkAccess,
        data: {'email': email},
      );
      return response.data?['status'] as String? ?? 'inactive';
    } catch (e) {
      debugPrint('Check access error: $e');
      return 'inactive';
    }
  }

  /// Fetch checkout session metadata (email, name, exists, auth_provider).
  Future<Map<String, dynamic>?> getCheckoutEmail(String sessionId) async {
    try {
      final response = await _api.get(
        ApiConfig.getCheckoutEmail,
        queryParameters: {'session_id': sessionId},
      );
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('Get checkout email error: $e');
      return null;
    }
  }

  /// Check trial eligibility for an email.
  Future<Map<String, dynamic>> checkTrialEligibility(String email) async {
    try {
      final response = await _api.get(
        ApiConfig.checkTrialEligibility,
        queryParameters: {'email': email},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Check trial eligibility error: $e');
      return {'eligible': false, 'has_active_subscription': false};
    }
  }

  // ════════════════════════════════════════════════════════════
  //  COACHING BOOKING
  // ════════════════════════════════════════════════════════════

  /// Fetch already booked 1-on-1 strategy sessions.
  Future<List<Map<String, dynamic>>> getBookedSlots() async {
    try {
      final response = await _api.get(ApiConfig.bookedSlots);
      final list = response.data as List<dynamic>?;
      if (list == null) return [];
      return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } catch (e) {
      debugPrint('Get booked slots error: $e');
      return [];
    }
  }

  /// Book a 1-on-1 coaching session.
  Future<Map<String, dynamic>> bookCoachingSession({
    required String bookingDate,
    required String bookingTime,
    String? goals,
    String? experienceLevel,
    String? additionalInfo,
    String? sessionId,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.bookCoaching,
        data: {
          'booking_date': bookingDate,
          'booking_time': bookingTime,
          if (goals != null && goals.isNotEmpty) 'goals': goals,
          if (experienceLevel != null && experienceLevel.isNotEmpty)
            'experience_level': experienceLevel,
          if (additionalInfo != null && additionalInfo.isNotEmpty)
            'additional_info': additionalInfo,
          if (sessionId != null && sessionId.isNotEmpty)
            'session_id': sessionId,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('Book coaching error: ${e.response?.data}');
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['message'] ??
          'An error occurred while booking. Please try another slot.';
      throw Exception(msg);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  URL LAUNCHING
  // ════════════════════════════════════════════════════════════

  /// Launch external Stripe checkout URL.
  Future<bool> launchCheckoutUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not open payment link: $urlString');
    }
  }

  /// Launch arbitrary link (used by Free Gifts modal).
  Future<bool> launchExternalLink(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception('Could not open link: $urlString');
    }
  }
}
