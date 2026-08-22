import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrustMarqueeSection extends StatelessWidget {
  const TrustMarqueeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Thousands of',
                  style: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Investors Trust PolyTICK.',
                  style: GoogleFonts.poppins(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Row 1: Left-to-Right Ultra-Smooth Marquee ──
          const _MarqueePillRow(
            key: ValueKey('marquee_row_1_gpu'),
            reverse: false,
            durationSeconds: 38,
            pills: [
              _PillData(text: 'AI Market Intelligence', isRed: true),
              _PillData(text: 'Institutional Investments'),
              _PillData(text: 'STOCK Act Filings'),
              _PillData(text: 'Macro Economic Signals', isBlue: true),
              _PillData(text: 'Insider Activity Tracking'),
              _PillData(text: 'AI Pattern Recognition'),
            ],
          ),
          const SizedBox(height: 14),

          // ── Row 2: Right-to-Left Ultra-Smooth Marquee (Opposite Direction) ──
          const _MarqueePillRow(
            key: ValueKey('marquee_row_2_gpu'),
            reverse: true,
            durationSeconds: 35,
            pills: [
              _PillData(text: 'Real-Time Politician Trades'),
              _PillData(text: 'Analyst Price Targets'),
              _PillData(text: 'Congressional Committees', isBlue: true),
              _PillData(text: 'Market Correlation'),
              _PillData(text: 'Early Warning Signals', isRed: true),
              _PillData(text: 'Live Filings Feed'),
            ],
          ),
          const SizedBox(height: 14),

          // ── Row 3: Left-to-Right Ultra-Smooth Marquee ──
          const _MarqueePillRow(
            key: ValueKey('marquee_row_3_gpu'),
            reverse: false,
            durationSeconds: 40,
            pills: [
              _PillData(text: 'Committee Tracking', isRed: true),
              _PillData(text: 'Smart Alerts'),
              _PillData(text: 'Sentiment Analysis'),
              _PillData(text: 'Multi-Layer AI Scoring', isBlue: true),
              _PillData(text: 'Disruptive Tech Filings'),
              _PillData(text: 'Portfolio Intelligence'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillData {
  final String text;
  final bool isBlue;
  final bool isRed;

  const _PillData({
    required this.text,
    this.isBlue = false,
    this.isRed = false,
  });
}

/// 100% GPU-accelerated marquee using Transform.translate on constant RenderBox
class _MarqueePillRow extends StatefulWidget {
  final List<_PillData> pills;
  final bool reverse;
  final int durationSeconds;

  const _MarqueePillRow({
    super.key,
    required this.pills,
    this.reverse = false,
    this.durationSeconds = 38,
  });

  @override
  State<_MarqueePillRow> createState() => _MarqueePillRowState();
}

class _MarqueePillRowState extends State<_MarqueePillRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  final GlobalKey _rowKey = GlobalKey();
  double _singleSetWidth = 0;

  // Safe field to satisfy Dart VM hot-reload getter lookups
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox = _rowKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _singleSetWidth = renderBox.size.width;
        });
        _animController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 48,
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final width = _singleSetWidth > 0 ? _singleSetWidth : 1200.0;
            final progress = _animController.value;
            final dx = widget.reverse
                ? (progress * width) - width
                : -(progress * width);

            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
          child: OverflowBox(
            maxWidth: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  key: _rowKey,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildPillsList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildPillsList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildPillsList(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildPillsList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPillsList() {
    return widget.pills.map((pill) {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: _buildPillWidget(pill),
      );
    }).toList();
  }

  Widget _buildPillWidget(_PillData pill) {
    if (pill.isBlue) {
      // Solid Blue Pill (#51A2FF)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF51A2FF),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFFD8D8D8),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            pill.text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
    }

    if (pill.isRed) {
      // Solid Red Pill (#C60C30)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFC60C30),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFFD8D8D8),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            pill.text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
    }

    // Default White Pill with crisp dark border (#1E1E1E)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF1E1E1E),
          width: 1.3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          pill.text,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

// Fallback helper for legacy Dart VM hot reload memory
// ignore: unused_element
class _MarqueeRowState extends _MarqueePillRowState {}
