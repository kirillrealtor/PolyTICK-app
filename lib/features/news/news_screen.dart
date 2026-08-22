import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock Market News', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text('Real-time breaking financial news affecting legislative trading.', style: AppTheme.inter(fontSize: 14, color: Colors.white60)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
