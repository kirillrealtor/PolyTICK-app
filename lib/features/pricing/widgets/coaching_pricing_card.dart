import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoachingPricingCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final bool isCurrentPlan;

  const CoachingPricingCard({
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
                  Color(0xFFC60C30), // Rich Figma Crimson (#C60C30)
                  Color(0xFFE22D54),
                  Color(0xFFFF8FA3),
                  Color(0xFFFFEEF2), // Light soft pink/white on bottom-left
                ],
                stops: [0.0, 0.45, 0.78, 1.0],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14C60C30),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Coaching + SAVE 97% Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coaching',
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
                        'SAVE 97%',
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
                    // Strikethrough $30000/year
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '\$30000/year',
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
                          '\$999',
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
                  "Stop guessing and start winning with elite 1-on-1 mentorship. We'll teach you proven trading strategies, how to leverage our data for a massive edge, and help you build a highly profitable system.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 20),

                // Join Elite Coaching Button (Frame 1618871329)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (isLoading || isCurrentPlan) ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentPlan
                          ? const Color(0xFF374151)
                          : const Color(0xFFFFFFFF),
                      foregroundColor: isCurrentPlan
                          ? Colors.white70
                          : const Color(0xFF000000),
                      disabledBackgroundColor: isCurrentPlan
                          ? const Color(0xFF374151)
                          : Colors.white70,
                      disabledForegroundColor: isCurrentPlan
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF000000),
                      elevation: 4,
                      shadowColor: const Color(0x40000000),
                      side: BorderSide(
                        color: isCurrentPlan
                            ? Colors.transparent
                            : const Color(0xFF000000),
                        width: 1.2,
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
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            isCurrentPlan ? 'Coaching Active' : 'Join Elite Coaching',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isCurrentPlan
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF000000),
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
                _featureItem('Get Coaching from Founders to Win Big'),
                const SizedBox(height: 14),
                _featureItem('Two Hours of Live 1-on-1 Strategy Sessions Weekly'),
                const SizedBox(height: 14),
                _featureItem('30-Days Unlimited Access'),
                const SizedBox(height: 14),
                _featureItem('Master the 8-Layer Intelligence Engine'),
                const SizedBox(height: 14),
                _featureItem('Detailed Game Plan'),
                const SizedBox(height: 14),
                _featureItem('Exclusive Community Access'),
                const SizedBox(height: 14),
                _featureItem('Custom-Tailored Portfolio & Risk Management Plan'),
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
