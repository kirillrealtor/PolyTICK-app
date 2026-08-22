import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';

class FuturisticLoader extends StatelessWidget {
  final String text;
  final double size;

  const FuturisticLoader({
    super.key,
    this.text = 'Loading...',
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.activeBlue),
          ),
        ),
        if (text.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            text,
            style: AppTheme.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ],
    );
  }
}
