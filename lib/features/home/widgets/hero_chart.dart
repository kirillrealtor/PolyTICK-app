import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroChart extends StatelessWidget {
  const HeroChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width * 1.28; // Proportional height for chart + staircase cards

          const double leftPadding = 34.0;
          const double rightPadding = 14.0;
          const double topPadding = 16.0;
          const double bottomPadding = 30.0;

          final chartWidth = width - leftPadding - rightPadding;
          final chartHeight = height - topPadding - bottomPadding;

          // Normalized price coordinate helper (250 at bottom, 330 at top)
          Offset point(double xFrac, double price) {
            final x = leftPadding + (xFrac * chartWidth);
            final y = topPadding + ((330 - price) / (330 - 250)) * chartHeight;
            return Offset(x, y);
          }

          // 4 Green Buy Marker Dot Coordinates on the chart
          final dotNancy = point(0.48, 248);     // April Low (~248)
          final dotInsider = point(0.68, 270);   // May Rally (~270)
          final dotKamala = point(0.86, 285);    // June Dip (~285)
          final dotTrump = point(0.96, 318);     // July Peak (~318)

          // 4 Staircase Card Positions & Connector Start Heights (Y levels)
          final lineYNancy = point(0.12, 292).dy;
          final lineYInsider = point(0.26, 308).dy;
          final lineYKamala = point(0.46, 322).dy;
          final lineYTrump = point(0.58, 336).dy;

          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── 1. Custom Paint: Grid, Axis, Graph Curve & 90-Degree Step Connectors ──
                Positioned.fill(
                  child: CustomPaint(
                    painter: _FintechChartPainter(
                      leftPadding: leftPadding,
                      rightPadding: rightPadding,
                      topPadding: topPadding,
                      bottomPadding: bottomPadding,
                      chartWidth: chartWidth,
                      chartHeight: chartHeight,
                      dotNancy: dotNancy,
                      dotInsider: dotInsider,
                      dotKamala: dotKamala,
                      dotTrump: dotTrump,
                      lineYNancy: lineYNancy,
                      lineYInsider: lineYInsider,
                      lineYKamala: lineYKamala,
                      lineYTrump: lineYTrump,
                    ),
                  ),
                ),

                // ── 2. Staircase Callout Cards (Left to Right, Ascending) ──

                // Card 1: Nancy Pelosi (Leftmost, Lowest)
                Positioned(
                  left: leftPadding + (chartWidth * 0.08),
                  top: lineYNancy - 36,
                  child: _buildCalloutCard(
                    avatarPath: 'assets/images/politicians/nancy-pelosi.webp',
                    name: 'Nancy Pelosi',
                    action: 'Bought',
                  ),
                ),

                // Card 2: Insider Trade (Silhouette, Stepped Higher)
                Positioned(
                  left: leftPadding + (chartWidth * 0.24),
                  top: lineYInsider - 36,
                  child: _buildCalloutCard(
                    isSilhouette: true,
                    name: 'Insider Trade',
                    action: 'Bought',
                  ),
                ),

                // Card 3: Kamala Harris (Stepped Higher)
                Positioned(
                  left: leftPadding + (chartWidth * 0.44),
                  top: lineYKamala - 36,
                  child: _buildCalloutCard(
                    avatarPath: 'assets/images/politicians/kamala-harris-avatar.png',
                    name: 'Kamala Harris',
                    action: 'Bought',
                  ),
                ),

                // Card 4: Donald Trump (Rightmost, Highest)
                Positioned(
                  left: leftPadding + (chartWidth * 0.56),
                  top: lineYTrump - 36,
                  child: _buildCalloutCard(
                    avatarPath: 'assets/images/politicians/donald-trump-avatar.png',
                    name: 'Donald Trump',
                    action: 'Bought',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalloutCard({
    String? avatarPath,
    bool isSilhouette = false,
    required String name,
    required String action,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: isSilhouette
                  ? Container(
                      color: const Color(0xFFE2E8F0),
                      child: const Icon(
                        Icons.person,
                        size: 18,
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : Image.asset(
                      avatarPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF51A2FF),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0] : 'P',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                action,
                style: GoogleFonts.poppins(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00E676),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FintechChartPainter extends CustomPainter {
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double chartWidth;
  final double chartHeight;
  final Offset dotNancy;
  final Offset dotInsider;
  final Offset dotKamala;
  final Offset dotTrump;
  final double lineYNancy;
  final double lineYInsider;
  final double lineYKamala;
  final double lineYTrump;

  _FintechChartPainter({
    required this.leftPadding,
    required this.rightPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.chartWidth,
    required this.chartHeight,
    required this.dotNancy,
    required this.dotInsider,
    required this.dotKamala,
    required this.dotTrump,
    required this.lineYNancy,
    required this.lineYInsider,
    required this.lineYKamala,
    required this.lineYTrump,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Y-Axis Labels: 250 to 330 in increments of 10 ──
    final yLabels = [330, 320, 310, 300, 290, 280, 270, 260, 250];
    final axisStyle = GoogleFonts.inter(
      fontSize: 9.0,
      color: const Color(0xFF475569),
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < yLabels.length; i++) {
      final y = topPadding + (i * (chartHeight / (yLabels.length - 1)));
      final tp = TextPainter(
        text: TextSpan(text: '${yLabels[i]}', style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(4, y - tp.height / 2));
    }

    // ── X-Axis Labels: Jan 2026 through Jul 2026 ──
    final xLabels = ['Jan 2026', 'Feb 2026', 'Mar 2026', 'Apr 2026', 'May 2026', 'Jun 2026', 'Jul 2026'];
    for (int i = 0; i < xLabels.length; i++) {
      final x = leftPadding + (i * (chartWidth / (xLabels.length - 1)));
      final tp = TextPainter(
        text: TextSpan(text: xLabels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - bottomPadding + 8));
    }

    Offset point(double xFrac, double val) {
      final x = leftPadding + (xFrac * chartWidth);
      final y = topPadding + ((330 - val) / (330 - 250)) * chartHeight;
      return Offset(x, y);
    }

    // ── 1. Gray Segment (Jan to early Apr: choppy, declining to lowest dip) ──
    final grayPoints = [
      point(0.00, 272),
      point(0.03, 270),
      point(0.06, 263),
      point(0.09, 258),
      point(0.12, 261),
      point(0.15, 254),
      point(0.18, 259),
      point(0.21, 265),
      point(0.24, 274),
      point(0.27, 272),
      point(0.29, 277),
      point(0.31, 262),
      point(0.33, 267),
      point(0.35, 268),
      point(0.38, 273),
      point(0.40, 266),
      point(0.42, 268),
      point(0.44, 261),
      point(0.46, 255),
      point(0.48, 248), // April Low Point (Lowest dip)
    ];

    // ── 2. Blue Segment (Apr to Jul: upward trend with small zigzags, June dip, sharp final rally) ──
    final bluePoints = [
      point(0.48, 248), // Starts at April low
      point(0.51, 254),
      point(0.53, 256),
      point(0.56, 252),
      point(0.59, 260),
      point(0.62, 258),
      point(0.65, 265),
      point(0.68, 270), // May Marker
      point(0.71, 268),
      point(0.74, 281),
      point(0.77, 279),
      point(0.80, 292),
      point(0.83, 298),
      point(0.86, 285), // June Pullback / Dip
      point(0.88, 287),
      point(0.91, 298),
      point(0.93, 305),
      point(0.96, 318), // July Peak Marker
      point(0.98, 326), // Sharp final rally upward
      point(1.00, 322),
    ];

    // Draw Gray Line
    final grayPath = Path();
    grayPath.moveTo(grayPoints[0].dx, grayPoints[0].dy);
    for (int i = 1; i < grayPoints.length; i++) {
      grayPath.lineTo(grayPoints[i].dx, grayPoints[i].dy);
    }
    final grayPaint = Paint()
      ..color = const Color(0x73000000) // rgba(0, 0, 0, 0.45)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(grayPath, grayPaint);

    // Draw Blue Line
    final bluePath = Path();
    bluePath.moveTo(bluePoints[0].dx, bluePoints[0].dy);
    for (int i = 1; i < bluePoints.length; i++) {
      bluePath.lineTo(bluePoints[i].dx, bluePoints[i].dy);
    }
    final bluePaint = Paint()
      ..color = const Color(0xFF51A2FF) // #51A2FF
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(bluePath, bluePaint);

    // ── 3. Right-Angle "Step" Connectors (Horizontal line from card, then sharp vertical drop straight down) ──
    final connectorPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    void drawStepConnector({
      required double startX,
      required double startY,
      required Offset targetDot,
    }) {
      final path = Path()
        ..moveTo(startX, startY)
        ..lineTo(targetDot.dx, startY) // Horizontal to target X
        ..lineTo(targetDot.dx, targetDot.dy); // Sharp vertical drop straight down to target
      canvas.drawPath(path, connectorPaint);
    }

    // Connector 1: Nancy Pelosi
    drawStepConnector(
      startX: leftPadding + (chartWidth * 0.08),
      startY: lineYNancy,
      targetDot: dotNancy,
    );

    // Connector 2: Insider Trade
    drawStepConnector(
      startX: leftPadding + (chartWidth * 0.24),
      startY: lineYInsider,
      targetDot: dotInsider,
    );

    // Connector 3: Kamala Harris
    drawStepConnector(
      startX: leftPadding + (chartWidth * 0.44),
      startY: lineYKamala,
      targetDot: dotKamala,
    );

    // Connector 4: Donald Trump
    drawStepConnector(
      startX: leftPadding + (chartWidth * 0.56),
      startY: lineYTrump,
      targetDot: dotTrump,
    );

    // ── 4. Solid Green Circle Markers directly on the blue line ──
    void drawSolidGreenMarker(Offset target) {
      // Outer subtle ring
      final ringPaint = Paint()
        ..color = const Color(0xFF00E676).withAlpha(70)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(target, 6.0, ringPaint);

      // Solid Green Dot
      final solidPaint = Paint()
        ..color = const Color(0xFF00E676)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(target, 3.8, solidPaint);

      // Clean White Border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(target, 3.8, borderPaint);
    }

    drawSolidGreenMarker(dotNancy);
    drawSolidGreenMarker(dotInsider);
    drawSolidGreenMarker(dotKamala);
    drawSolidGreenMarker(dotTrump);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
