import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthlyPricingCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final bool isCurrentPlan;

  const MonthlyPricingCard({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.isCurrentPlan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
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
                // Header Row: Monthly + SAVE 92% Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly',
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
                        'SAVE 92%',
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
                    // Strikethrough $200/month
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '\$200/month',
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
                          '\$14.99',
                          style: GoogleFonts.poppins(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF000000),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/month',
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
                  'Get full access to Layers 1 through 8 for one month. Save 92% with our limited-time discount.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 20),

                // Subscribe Monthly Button (Frame 1618871329)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (isLoading || isCurrentPlan) ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentPlan
                          ? const Color(0xFF374151)
                          : const Color(0xFF1E1E1E),
                      foregroundColor: const Color(0xFFFFFFFF),
                      disabledBackgroundColor: isCurrentPlan
                          ? const Color(0xFF374151)
                          : const Color(0xFF1E1E1E).withValues(alpha: 0.7),
                      disabledForegroundColor: Colors.white70,
                      elevation: 4,
                      shadowColor: const Color(0x40000000),
                      side: const BorderSide(
                        color: Color(0xFF000000),
                        width: 1,
                      ),
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
                            isCurrentPlan ? 'Current Plan' : 'Subscribe Monthly',
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
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
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
