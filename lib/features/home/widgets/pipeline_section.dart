import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PipelineSection extends StatelessWidget {
  const PipelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 1. The U-Shape Transition Area with Upward Box Shadow ──
        SizedBox(
          width: double.infinity,
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Rich upward ambient shadow matching Figma
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF1E1E1E).withAlpha(140),
                        const Color(0xFF1E1E1E).withAlpha(80),
                        const Color(0xFF1E1E1E).withAlpha(30),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.35, 0.70, 1.0],
                    ),
                  ),
                ),
              ),

              // SCROLL TO EXPLORE label directly above the curve
              Positioned(
                top: 22,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SCROLL TO EXPLORE',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),

              // Curved scooped dark edge
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 38,
                child: CustomPaint(
                  painter: _UCurveEdgePainter(),
                ),
              ),
            ],
          ),
        ),

        // ── 2. The Main Dark Container (#1E1E1E) ──
        Container(
          width: double.infinity,
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.only(
            top: 24.0,
            bottom: 56.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Stats Bar (335 Politicians Tracked, 8 Layers, Fast Alerts) ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Politicians Tracked (335)
                  Expanded(
                    child: _buildStatColumn(
                      icon: Icons.groups_outlined,
                      number: '335',
                      numberFontSize: 21.0,
                      label: 'POLITICIANS\nTRACKED',
                      labelFontSize: 9.5,
                    ),
                  ),
                  // 2. Intelligence Layers (8)
                  Expanded(
                    child: _buildStatColumn(
                      icon: Icons.layers_outlined,
                      number: '8',
                      numberFontSize: 26.0,
                      label: 'INTELLIGENCE\nLAYERS',
                      labelFontSize: 11.0,
                    ),
                  ),
                  // 3. Lightning Fast Alerts (<10 min)
                  Expanded(
                    child: _buildStatColumn(
                      icon: Icons.notifications_active_outlined,
                      number: '<10 min',
                      numberFontSize: 20.0,
                      label: 'REAL-TIME\nALERTS',
                      labelFontSize: 10.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),

              // White Divider Line
              Container(
                width: double.infinity,
                height: 1.2,
                color: Colors.white,
              ),
              const SizedBox(height: 32),

              // ── The Pipeline Title Section ──
              Text(
                'The Pipeline',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.12,
                  ),
                  children: [
                    const TextSpan(text: 'From Filing to Your\nAlert in '),
                    TextSpan(
                      text: 'Minutes.',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle Tagline
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Track powerful moves with pinpoint accuracy. Trade with total confidence.',
                  style: GoogleFonts.poppins(
                    fontSize: 13.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ── Tracking Scope Pill Banner ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF51A2FF).withAlpha(90),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.radar_rounded,
                        color: Color(0xFF51A2FF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12.0,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: 'We track insider moves across ',
                            ),
                            TextSpan(
                              text: 'Politicians, Presidents, CEOs, C-Suite Executives, Institutional Investors, and top Wall Street Hedge Funds.',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF51A2FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── 4-Step Vertical Stepper Pipeline (Layman Terms) ──
              _buildStepperStep(
                number: '1',
                title: 'Filing Detected Instantly.',
                description:
                    'We catch STOCK Act disclosures, President Trump trades, CEO insider buys, and 13F hedge fund filings the second they go public.',
                isLast: false,
              ),
              _buildStepperStep(
                number: '2',
                title: 'Cross-Referenced for Accuracy.',
                description:
                    'Every trade is double-checked against committee oversight, political timing, and historical win rates to ensure high-conviction accuracy.',
                isLast: false,
              ),
              _buildStepperStep(
                number: '3',
                title: 'Signal Scored with AI.',
                description:
                    'Our AI connects the dots with Wall Street analyst targets, ARK Invest daily trades, and momentum indicators into a simple, reliable score.',
                isLast: false,
              ),
              _buildStepperStep(
                number: '4',
                title: 'You Get Alerted in Real-Time.',
                description:
                    'Our high-frequency system pushes filtered, high-conviction trade setups with perfect timing—giving you the edge before the broader market reacts.',
                isLast: true,
              ),

              const SizedBox(height: 24),

              // ── Callout: Enable Push Notifications CTA ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00E676).withAlpha(35),
                      const Color(0xFF51A2FF).withAlpha(35),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00E676).withAlpha(120),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notifications_active_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Mobile & Push Alerts',
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Never miss an insider move. Receive real-time entry alerts directly on your device.',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: Colors.white.withAlpha(200),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String number,
    required double numberFontSize,
    required String label,
    required double labelFontSize,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.white,
        ),
        const SizedBox(height: 6),
        Text(
          number,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: numberFontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.18,
          ),
        ),
      ],
    );
  }

  Widget _buildStepperStep({
    required String number,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Glowing Circle + Connecting Vertical Line
          Column(
            children: [
              // Glowing White Circle Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withAlpha(120),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // White Vertical Stepper Line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.8,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18),

          // Right: Step Title & Description
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 4.0,
                bottom: isLast ? 0.0 : 36.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withAlpha(210),
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the concave scooped U-shape top edge (Vector 69) filled with #1E1E1E
class _UCurveEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
