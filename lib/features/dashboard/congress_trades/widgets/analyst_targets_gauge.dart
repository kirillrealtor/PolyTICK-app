import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class AnalystTargetsGauge extends StatefulWidget {
  final String ticker;
  final num? low;
  final num? high;
  final num? average;
  final num? current;

  const AnalystTargetsGauge({
    super.key,
    required this.ticker,
    this.low,
    this.high,
    this.average,
    this.current,
  });

  @override
  State<AnalystTargetsGauge> createState() => _AnalystTargetsGaugeState();
}

class _AnalystTargetsGaugeState extends State<AnalystTargetsGauge> {
  num? _low;
  num? _high;
  num? _average;
  num? _current;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _low = widget.low;
    _high = widget.high;
    _average = widget.average;
    _current = widget.current;

    if ((_low == null || _low == 0) && (_high == null || _high == 0)) {
      _fetchYahooData();
    }
  }

  @override
  void didUpdateWidget(covariant AnalystTargetsGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ticker != widget.ticker ||
        oldWidget.low != widget.low ||
        oldWidget.high != widget.high) {
      _low = widget.low;
      _high = widget.high;
      _average = widget.average;
      _current = widget.current;

      if ((_low == null || _low == 0) && (_high == null || _high == 0)) {
        _fetchYahooData();
      }
    }
  }

  Future<void> _fetchYahooData() async {
    final cleanTicker = widget.ticker.contains(':')
        ? widget.ticker.split(':').last.trim()
        : widget.ticker.trim();

    if (cleanTicker.isEmpty || cleanTicker == '—' || cleanTicker == '-') {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await ApiClient.instance.get('/yahoo-v2/${Uri.encodeComponent(cleanTicker)}');
      if (res.statusCode == 200 && res.data is Map) {
        final data = res.data as Map;
        if (mounted) {
          setState(() {
            _low = data['low'] as num? ?? data['analyst_low'] as num?;
            _high = data['high'] as num? ?? data['analyst_high'] as num?;
            _average = data['average'] as num? ?? data['analyst_average'] as num?;
            _current = data['current'] as num? ?? data['current_price'] as num?;
            _isLoading = false;
          });
        }
        return;
      }
    } catch (e) {
      debugPrint('Error fetching analyst targets for ${widget.ticker}: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticker = widget.ticker;
    final l = (_low ?? 0).toDouble();
    final h = (_high ?? 0).toDouble();
    final a = (_average ?? 0).toDouble();
    final c = (_current ?? 0).toDouble();

    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF131722),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF38BDF8)),
            ),
            const SizedBox(width: 12),
            Text(
              'Analyzing $ticker Targets...',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    final hasData = l > 0 && h > 0;

    if (!hasData) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                ticker.isNotEmpty && ticker != '—' && ticker != '-'
                    ? 'Analyst price targets are currently unavailable for $ticker.'
                    : 'Government bonds or non-equity instrument — no analyst target data.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Dynamic scale with generous padding so markers never hit the edges
    final allVals = [l, h, a, c].where((v) => v > 0).toList();
    final minVal = allVals.reduce((curr, next) => curr < next ? curr : next);
    final maxVal = allVals.reduce((curr, next) => curr > next ? curr : next);

    final padding = (maxVal - minVal) * 0.18 > 0 ? (maxVal - minVal) * 0.18 : (h * 0.1);
    final visualMin = minVal - padding;
    final visualMax = maxVal + padding;
    final visualRange = visualMax - visualMin;

    double getPct(double val) {
      if (visualRange <= 0) return 0.5;
      return ((val - visualMin) / visualRange).clamp(0.06, 0.94);
    }

    final lowPct = getPct(l);
    final highPct = getPct(h);
    final avgPct = getPct(a);
    final curPct = getPct(c);

    // Determine signal & upside
    double? upsideToAvg;
    String signalLabel = 'NEUTRAL';
    Color signalColor = const Color(0xFF475569);

    if (a > 0 && c > 0) {
      upsideToAvg = ((a - c) / c) * 100;
      if (upsideToAvg > 15) {
        signalLabel = 'UNDERVALUED';
        signalColor = const Color(0xFF047857); // emerald
      } else if (upsideToAvg > 2) {
        signalLabel = 'UPSIDE';
        signalColor = const Color(0xFF059669);
      } else if (upsideToAvg < -15) {
        signalLabel = 'OVERVALUED';
        signalColor = const Color(0xFFDC2626); // red
      } else if (upsideToAvg < -2) {
        signalLabel = 'DOWNSIDE';
        signalColor = const Color(0xFFD97706); // amber
      } else {
        signalLabel = 'FAIR VALUE';
        signalColor = const Color(0xFF334155);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title: Analyst Insights: TICKER ──
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E1E1E),
                letterSpacing: -0.3,
              ),
              children: [
                const TextSpan(text: 'Analyst Insights: '),
                TextSpan(
                  text: ticker,
                  style: const TextStyle(color: Color(0xFFC60C30)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Horizontal Interactive Gauge with 3 Distinct Vertical Tiers (No Overlap) ──
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;

              final lowX = lowPct * trackWidth;
              final highX = highPct * trackWidth;
              final avgX = avgPct * trackWidth;
              final curX = curPct * trackWidth;

              // Clamped horizontal bounds to prevent card overflow
              const cardWidth = 76.0;
              final avgCardLeft = (avgX - cardWidth / 2).clamp(0.0, trackWidth - cardWidth);
              final curCardLeft = (curX - cardWidth / 2).clamp(0.0, trackWidth - cardWidth);
              final lowLabelLeft = (lowX - 25).clamp(0.0, trackWidth - 55);
              final highLabelLeft = (highX - 25).clamp(0.0, trackWidth - 55);

              return SizedBox(
                height: 165,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Background Track Line (Y = 56)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 56,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // 2. Active Range Bar (Low to High) (Y = 56)
                    Positioned(
                      left: lowX,
                      width: (highX - lowX).clamp(4.0, trackWidth),
                      top: 56,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF94A3B8),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // 3. LOW MARKER (Dot on track at Y = 56, Text directly below at Y = 66..94)
                    Positioned(
                      left: lowX - 5,
                      top: 53,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF64748B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: lowLabelLeft,
                      top: 66,
                      child: SizedBox(
                        width: 55,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${l.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1E1E1E),
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Low',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 4. HIGH MARKER (Dot on track at Y = 56, Text directly below at Y = 66..94)
                    Positioned(
                      left: highX - 5,
                      top: 53,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF64748B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: highLabelLeft,
                      top: 66,
                      child: SizedBox(
                        width: 55,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${h.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1E1E1E),
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'High',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 5. AVERAGE PIN (TOP TIER: Y = 0..46, Line down to track)
                    if (a > 0) ...[
                      // Stem line from Average card down to track
                      Positioned(
                        left: avgX - 0.75,
                        top: 38,
                        child: Container(
                          width: 1.5,
                          height: 16,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      // Dot on track
                      Positioned(
                        left: avgX - 5,
                        top: 53,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      // Average Top Card
                      Positioned(
                        left: avgCardLeft,
                        top: 0,
                        child: Container(
                          width: cardWidth,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF3B82F6), width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${a.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF1E1E1E),
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                'Average',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // 6. CURRENT PRICE PIN (BOTTOM TIER: Y = 108..156, Stem Line: Y = 56..108)
                    // Placed on the bottom tier well below Low & High text so it NEVER overlaps!
                    if (c > 0) ...[
                      // Dot on track
                      Positioned(
                        left: curX - 5,
                        top: 53,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                      // Long stem line going DOWN past the Low/High text tier
                      Positioned(
                        left: curX - 0.75,
                        top: 60,
                        child: Container(
                          width: 1.5,
                          height: 48,
                          color: Colors.black,
                        ),
                      ),
                      // Current Bottom Card (Y = 108)
                      Positioned(
                        left: curCardLeft,
                        top: 108,
                        child: Container(
                          width: cardWidth,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black, width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${c.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF1E1E1E),
                                ),
                                maxLines: 1,
                              ),
                              Text(
                                'Current',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 14),

          // ── Metrics & Consensus Section ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // To Average Target
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TO AVERAGE TARGET',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    upsideToAvg != null
                        ? '${upsideToAvg > 0 ? '+' : ''}${upsideToAvg.toStringAsFixed(1)}%'
                        : 'N/A',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: signalColor,
                    ),
                  ),
                ],
              ),

              // Consensus Signal Pill
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CONSENSUS SIGNAL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1.8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      signalLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Link to Yahoo Finance ──
          GestureDetector(
            onTap: () async {
              if (ticker.isNotEmpty && ticker != '—' && ticker != '-') {
                final url = Uri.parse('https://finance.yahoo.com/quote/$ticker');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Details on Yahoo Finance',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2563EB),
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.open_in_new_rounded, size: 14, color: Color(0xFF2563EB)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
