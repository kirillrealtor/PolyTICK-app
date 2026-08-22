import 'package:flutter/material.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class PoliticianDetailScreen extends StatelessWidget {
  final String slug;

  const PoliticianDetailScreen({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    final titleName = slug.replaceAll('-', ' ').toUpperCase();

    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.polyBlue,
                    child: Text(titleName[0], style: AppTheme.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titleName,
                          style: AppTheme.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'U.S. House of Representatives',
                          style: AppTheme.inter(fontSize: 13, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Stock Trade History', style: AppTheme.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text('Displaying recent disclosures for $titleName...', style: AppTheme.inter(fontSize: 13, color: Colors.white60)),
          ],
        ),
      ),
    );
  }
}
