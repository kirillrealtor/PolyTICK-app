import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/models/user_model.dart';
import 'package:polytick_app/core/models/referral_data_model.dart';

class ReferralDiscountBanner extends StatelessWidget {
  final UserModel? user;
  final ReferralDataModel referralData;
  final bool isLoading;
  final VoidCallback onClear;

  const ReferralDiscountBanner({
    super.key,
    required this.user,
    required this.referralData,
    this.isLoading = false,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUsedReferral = user != null && referralData.hasUsedReferral;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 820),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: hasUsedReferral
            ? const Color(0xFF1E1414)
            : const Color(0xFF131A24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: hasUsedReferral
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFF3B82F6).withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: isLoading
          ? Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Applying Referral Code...',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                      Text(
                        'Verifying referral status and unlocking your 10% discount...',
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasUsedReferral
                        ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    hasUsedReferral
                        ? Icons.warning_amber_rounded
                        : Icons.auto_awesome_rounded,
                    size: 20,
                    color: hasUsedReferral
                        ? const Color(0xFFF87171)
                        : const Color(0xFF60A5FA),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasUsedReferral
                            ? 'Referral Discount Already Used'
                            : 'Referral Code Applied!',
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hasUsedReferral
                            ? 'You have already redeemed a referral discount on this account. Since this is a one-time welcome promotion, additional referral discount codes cannot be applied to your subscription.'
                            : "You've unlocked a 10% discount, which will be automatically applied at checkout. This special offer is valid once per account, so be sure to select the subscription plan that best fits your goals.",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: onClear,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Clear',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9CA3AF),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
