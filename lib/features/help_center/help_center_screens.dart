import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help Center', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Find guides and assistance for your PolyTICK subscription.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('API & Platform Documentation', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Comprehensive guide to our 8-layer market intelligence algorithms.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}



class ApiAccessScreen extends StatelessWidget {
  const ApiAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PolyTICK API Access', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Developer access to our real-time congressional trade streams.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
