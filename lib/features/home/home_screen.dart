import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';
import 'package:polytick_app/features/home/widgets/hero_chart.dart';
import 'package:polytick_app/features/home/widgets/pipeline_section.dart';
import 'package:polytick_app/features/home/widgets/intelligence_layers_section.dart';
import 'package:polytick_app/features/home/widgets/trust_marquee_section.dart';
import 'package:polytick_app/features/home/widgets/why_built_section.dart';
import 'package:polytick_app/features/home/widgets/faq_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.white,
      showFooter: true,
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Hero Section ──
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 18.0,
                bottom: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top Tagline: PolyTICK, the #1 data platform built specifically for traders. ──
                  Text(
                    'PolyTICK, the #1 data platform built specifically for traders.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Main Headline: PolyTICK, Where Traders Find Success. ──
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.15,
                        letterSpacing: -0.4,
                      ),
                      children: [
                        TextSpan(
                          text: 'Poly',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF0052CC),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'TICK',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFC60C30),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const TextSpan(text: ', Where Traders Find Success.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Subheading Paragraph ──
                  Text(
                    'The #1 Stock AI that tracks real-time insider trading across Politicians, Presidents, CEOs, C-Suite Executives, Institutional Investors, and top Wall Street Hedge Funds — 100% Free. Combine multi-layer market signals to spot high-probability trades before the crowd.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1E293B),
                      height: 1.5,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── CTA Buttons (Start Free Trial & Watch Demo) ──
                  Row(
                    children: [
                      // Start Free Trial Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/pricing'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF51A2FF),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Start Free Trial',
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Watch Demo Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/dashboard/congress-trades'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC60C30),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Watch Demo',
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Trust Checkpoints ──
                  _trustItem('Setup in 30 seconds'),
                  const SizedBox(height: 6),
                  _trustItem('No credit card required'),
                  const SizedBox(height: 6),
                  _trustItem('Cancel anytime'),
                  const SizedBox(height: 20),

                  // ── Inflection Point Stock Timeline Chart ──
                  const HeroChart(),
                ],
              ),
            ),

            // ── 2. The Pipeline U-Shape Dark Section (#1E1E1E) ──
            const PipelineSection(),

            // ── 3. The 8 Intelligence Layers Section ──
            const IntelligenceLayersSection(),

            // ── 4. Why Thousands of Investors Trust PolyTICK (Animated Marquee) ──
            const TrustMarqueeSection(),

            // ── 5. Why We Built PolyTICK (Hard 3D Shadow Bento Section) ──
            const WhyBuiltSection(),

            // ── 6. FAQ Section (Everything You Need to Know) ──
            const FaqSection(),
          ],
        ),
      ),
    );
  }

  Widget _trustItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: Color(0xFF00E676),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 11,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
