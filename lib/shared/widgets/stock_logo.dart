import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockLogo extends StatelessWidget {
  final String? ticker;
  final double size;

  const StockLogo({
    super.key,
    required this.ticker,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (ticker == null || ticker!.trim().isEmpty || ticker == '—' || ticker == '-') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.show_chart_rounded, size: size * 0.55, color: const Color(0xFF94A3B8)),
      );
    }

    final clean = ticker!.split('.')[0].replaceAll('\$', '').toUpperCase().trim();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(25)),
      ),
      child: ClipOval(
        child: Image.network(
          'https://financialmodelingprep.com/image-stock/$clean.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF334155),
            alignment: Alignment.center,
            child: Text(
              clean.length >= 2 ? clean.substring(0, 2) : clean,
              style: GoogleFonts.inter(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
