import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class DashboardShell extends ConsumerWidget {
  final Widget child;

  const DashboardShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.path;

    final tabs = [
      ('Congress Dashboard', '/dashboard/congress-trades', Icons.description_outlined),
      ('Analytics', '/dashboard/analytics', Icons.bar_chart_rounded),
      ('Leaderboard', '/dashboard/leaderboard', Icons.emoji_events_outlined),
      ('ARK Invest', '/dashboard/ark-invest', Icons.my_location_rounded),
      ('Overlay', '/dashboard/overlay', Icons.waves_rounded),
      ('Motley Fool', '/dashboard/motley-fool', Icons.pie_chart_outline_rounded),
      ('Referrals', '/dashboard/referrals', Icons.people_outline_rounded),
      ('Scanned Filings', '/dashboard/scanned-filings', Icons.document_scanner_outlined),
      ('Help', '/faq', Icons.help_outline_rounded),
    ];

    return AppScaffold(
      backgroundColor: const Color(0xFF0B0E14), // Premium dark theme matching website
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Navigation Tabs Scroll (Exact website style) ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  for (final tab in tabs) ...[
                    GestureDetector(
                      onTap: () => context.go(tab.$2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: currentPath == tab.$2
                              ? const Color(0xFF2563EB) // Active Solid Blue
                              : const Color(0xFF131722), // Dark pill
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: currentPath == tab.$2
                                ? const Color(0xFF3B82F6)
                                : Colors.white.withAlpha(12),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tab.$3,
                              size: 15,
                              color: currentPath == tab.$2
                                  ? Colors.white
                                  : const Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              tab.$1,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: currentPath == tab.$2
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: currentPath == tab.$2
                                    ? Colors.white
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
