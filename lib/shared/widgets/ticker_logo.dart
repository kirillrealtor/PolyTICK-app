import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';

class TickerLogo extends StatelessWidget {
  final double scale;
  final bool isDark;

  const TickerLogo({
    super.key,
    this.scale = 1.0,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/PolyTICK-NewLogo-transparent.png',
          height: 32 * scale,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.bug_report,
              color: AppTheme.polyBlue,
              size: 26 * scale,
            );
          },
        ),
        SizedBox(width: 8 * scale),
        Text(
          'Poly',
          style: AppTheme.poppins(
            fontSize: 22 * scale,
            fontWeight: FontWeight.w700,
            color: AppTheme.polyBlue,
          ),
        ),
        Text(
          'TICK',
          style: AppTheme.poppins(
            fontSize: 22 * scale,
            fontWeight: FontWeight.w700,
            color: AppTheme.tickRed,
          ),
        ),
      ],
    );
  }
}
