import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/core/models/user_model.dart';

class InviteRewardCard extends StatelessWidget {
  final UserModel? user;

  const InviteRewardCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        width: double.infinity,
        margin: const EdgeInsets.only(top: 24, bottom: 32),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Main Card Container ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 22,
                right: 20,
                top: 26,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x38000000), // Soft deep shadow from Figma
                    blurRadius: 36,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title: Invite Friends. Get Rewarded. ──
                  FractionallySizedBox(
                    widthFactor: 0.65, // Leaves space for the overlapping gift box
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Invite Friends.\nGet Rewarded.',
                      style: GoogleFonts.inter(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF424242),
                        height: 1.15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Description ──
                  Text(
                    'They get 10% off, and you instantly earn 10% of their payment as account credit. Stack your credits and use PolyTICK for free! Get access under referrals tab once you create Free account.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF383737),
                      height: 1.42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Action Button: Invite Friends -> ──
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (user == null) {
                            context.go('/login');
                          } else {
                            context.go('/dashboard/referrals');
                          }
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Invite Friends',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: Color(0xFFFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Overlapping 3D Gift Box Asset ──
            Positioned(
              top: -30,
              right: -6,
              child: IgnorePointer(
                child: SizedBox(
                  width: 145,
                  height: 145,
                  child: Image.asset(
                    'assets/images/Giftboxpricingpage.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
