import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';



class PelosiTradesScreen extends StatelessWidget {
  const PelosiTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nancy Pelosi Stock Tracker', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Real-time stock disclosures, options visualizer, and 3-year performance analysis for Nancy Pelosi.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class TubervilleTradesScreen extends StatelessWidget {
  const TubervilleTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tommy Tuberville Stock Tracker', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Track Senator Tommy Tuberville disclosures and commodity/option bets.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class CrenshawTradesScreen extends StatelessWidget {
  const CrenshawTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dan Crenshaw Stock Tracker', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Track Representative Dan Crenshaw stock trades.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class SenatorTradesScreen extends StatelessWidget {
  const SenatorTradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('U.S. Senate Stock Trades', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('Filter and analyze stock disclosures from all 100 U.S. Senators.', style: AppTheme.inter(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}


