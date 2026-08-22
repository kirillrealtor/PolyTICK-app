import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YearlyPricingCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final bool isCurrentPlan;

  const YearlyPricingCard({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.isCurrentPlan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // ── Main Outer Card Container ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFF000000),
                  width: 2.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Gradient Hero Container (Frame 1618871328) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const RadialGradient(
                        center: Alignment(0.85, -0.6),
                        radius: 1.25,
                        colors: [
                          Color(0xFF51A2FF), // Primary Poly Blue (#51A2FF)
                          Color(0xFF7CB8FF),
                          Color(0xFFBCE0FD),
                          Color(0xFFEFF8FF), // Light soft blue/white on bottom-left
                        ],
                        stops: [0.0, 0.45, 0.78, 1.0],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1451A2FF),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row: Yearly + Save 17% Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yearly',
                              style: GoogleFonts.poppins(
                                fontSize: 21,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF000000),
                                letterSpacing: -0.2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Save 17%',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Price Section with Strikethrough Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Strikethrough $2400/year
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                '\$2400/year',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF000000),
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: const Color(0xFF000000),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '\$149.99',
                                  style: GoogleFonts.poppins(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF000000),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '/year',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Subtitle description
                        Text(
                          'Our best value choice. Get 12 months for the price of 10 + an overall savings of 94%.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF000000),
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Subscribe Yearly Button (Frame 1618871329)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: (isLoading || isCurrentPlan) ? null : onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCurrentPlan
                                  ? const Color(0xFF374151)
                                  : const Color(0xFF000000),
                              foregroundColor: const Color(0xFFFFFFFF),
                              disabledBackgroundColor: isCurrentPlan
                                  ? const Color(0xFF374151)
                                  : const Color(0xFF000000).withValues(alpha: 0.7),
                              disabledForegroundColor: Colors.white70,
                              elevation: 4,
                              shadowColor: const Color(0x40000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isCurrentPlan ? 'Current Plan' : 'Subscribe Yearly',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isCurrentPlan
                                          ? const Color(0xFF9CA3AF)
                                          : const Color(0xFFFFFFFF),
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Bottom Features Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Features:',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF000000),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _featureItem('Access to Stock trades of US Politicians'),
                        const SizedBox(height: 14),
                        _featureItem('Access to Committee and Subcommittee'),
                        const SizedBox(height: 14),
                        _featureItem('Access to ARK Trades'),
                        const SizedBox(height: 14),
                        _featureItem('Access to Analyst Price Targets'),
                        const SizedBox(height: 14),
                        _featureItem('Access to Overlay Indicator'),
                        const SizedBox(height: 14),
                        _featureItem('Access to Motley Fool Holdings'),
                        const SizedBox(height: 14),
                        _featureItem('Access to AI & Machine Learning Layer (coming soon)'),
                        const SizedBox(height: 14),
                        _featureItem('Access to Sentiment Analysis of Congressional Hearings(coming soon)'),
                        const SizedBox(height: 14),
                        _featureItem('Save 17% compared to monthly'),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Top "Most Popular" Pill Badge (Centered on top border) ──
            Positioned(
              top: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF000000),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x2E000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Most Popular',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFFFFFF),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Outlined Check Circle Icon matching Figma
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF000000),
                width: 1.8,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                size: 15,
                color: Color(0xFF000000),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
