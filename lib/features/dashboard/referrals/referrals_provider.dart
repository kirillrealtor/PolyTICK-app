import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/core/models/referral_model.dart';

final referralDashboardProvider = FutureProvider<ReferralDashboardData>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.currentUser;

  // ── Dedicated Google Play Reviewer / Demo Account Bypass ──
  if (user?.email == 'google-review@polytick.us' ||
      user?.email == 'reviewer@polytick.us' ||
      user?.email == 'demo@polytick.us') {
    return const ReferralDashboardData(
      referralCode: 'google_reviewer',
      accountCredit: 100.0,
      totalCreditEarned: 150.0,
      referrals: [
        ReferralRecord(
          refereeEmail: 'trader.alex@gmail.com',
          status: 'Active',
          createdAt: '2026-08-10',
          convertedAt: '2026-08-10',
          creditEarned: 50.0,
        ),
        ReferralRecord(
          refereeEmail: 'investor.sam@outlook.com',
          status: 'Active',
          createdAt: '2026-08-14',
          convertedAt: '2026-08-14',
          creditEarned: 100.0,
        ),
      ],
    );
  }

  try {
    final response = await ApiClient.instance.get(ApiConfig.referrals);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ReferralDashboardData.fromJson(data);
    } else if (data is Map) {
      return ReferralDashboardData.fromJson(Map<String, dynamic>.from(data));
    }
    return const ReferralDashboardData();
  } catch (e) {
    debugPrint('Referral dashboard API notice: $e');
    // Graceful fallback for offline, 401, or guest state
    final fallbackCode = authState.referralData.referralCode ??
        (user != null && user.email.isNotEmpty
            ? user.email.split('@')[0].replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '')
            : 'POLYTICK');
    return ReferralDashboardData(
      referralCode: fallbackCode,
      accountCredit: authState.referralData.accountCredit,
      totalCreditEarned: authState.referralData.accountCredit,
      referrals: const [],
    );
  }
});
