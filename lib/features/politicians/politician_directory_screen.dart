import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class PoliticianDirectoryScreen extends StatefulWidget {
  const PoliticianDirectoryScreen({super.key});

  @override
  State<PoliticianDirectoryScreen> createState() => _PoliticianDirectoryScreenState();
}

class _PoliticianDirectoryScreenState extends State<PoliticianDirectoryScreen> {
  String _search = '';

  final mockPoliticians = [
    (name: 'Nancy Pelosi', slug: 'nancy-pelosi', party: 'Democrat', chamber: 'House', state: 'CA'),
    (name: 'Tommy Tuberville', slug: 'tommy-tuberville', party: 'Republican', chamber: 'Senate', state: 'AL'),
    (name: 'Dan Crenshaw', slug: 'dan-crenshaw', party: 'Republican', chamber: 'House', state: 'TX'),
    (name: 'Ro Khanna', slug: 'ro-khanna', party: 'Democrat', chamber: 'House', state: 'CA'),
    (name: 'Mark Green', slug: 'mark-green', party: 'Republican', chamber: 'House', state: 'TN'),
    (name: 'Josh Gottheimer', slug: 'josh-gottheimer', party: 'Democrat', chamber: 'House', state: 'NJ'),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = mockPoliticians.where((p) => p.name.toLowerCase().contains(_search.toLowerCase())).toList();

    return AppScaffold(
      backgroundColor: AppTheme.bgCream,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Politician Directory', style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 4),
            Text('Track individual portfolios and trades across Congress', style: AppTheme.inter(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 16),

            TextField(
              style: AppTheme.inter(fontSize: 14, color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Search politician by name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final p = filtered[index];
                return GestureDetector(
                  onTap: () => context.go('/politicians/${p.slug}'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppTheme.polyBlue,
                          child: Text(p.name[0], style: AppTheme.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          p.name,
                          style: AppTheme.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${p.party} • ${p.chamber} (${p.state})',
                          style: AppTheme.inter(fontSize: 11, color: Colors.white60),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
