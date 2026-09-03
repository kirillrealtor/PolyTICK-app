import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FreeGiftBonusCard extends StatelessWidget {
  final VoidCallback onTap;

  const FreeGiftBonusCard({
    super.key,
    required this.onTap,
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
                  Color(0xFFC60C30), // Rich Figma Crimson
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
                // Header Row: Title + SAVE 100% Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free Gift/ Bonus',
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
                        'SAVE 100%',
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
                    // Strikethrough $79.99/month
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '\$79.99/month',
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
                          '\$0.0',
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
                  'Every visitor receives valuable learning material at no cost.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 20),

                // Claim Free Gift Button (Frame 1618871329)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xFF000000),
                      elevation: 4,
                      shadowColor: const Color(0x40000000),
                      side: const BorderSide(
                        color: Color(0xFF000000),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Claim Free Gift',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
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
                _featureItem("1", "100's Financial Literacy Songs"),
                const SizedBox(height: 14),
                _featureItem("2", 'Amazon Book for Free'),
                const SizedBox(height: 14),
                _featureItem("3", 'Millionaire Mindset Affirmations'),
                const SizedBox(height: 14),
                _featureItem("4", 'Life Philosophy Book'),
                const SizedBox(height: 14),
                _featureItem("5", 'The Millionaire Trader E-Book'),
                const SizedBox(height: 14),
                _featureItem("6", '10,000% Win in Equities / Stocks'),
                const SizedBox(height: 14),
                _featureItem("7", 'Real Estate Investor for Dummies'),
                const SizedBox(height: 14),
                _featureItem("8", 'Art of Prompting for Book Writing'),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFC60C30),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
