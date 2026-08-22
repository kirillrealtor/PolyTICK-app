import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polytick_app/config/app_theme.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  Future<void> _launchExternalUrl(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  final faqs = const [
    (
      q: 'Is tracking politician stock trades legal?',
      a: 'Yes, 100% legal. Under the Stop Trading on Congressional Knowledge Act of 2012 (STOCK Act), all U.S. Representatives and Senators are mandated by federal law to publicly disclose transactions within 45 days. These disclosures are published as public records on official government portals: disclosures-clerk.house.gov (House) and efdsearch.senate.gov (Senate). PolyTICK organizes and digitizes these public filings.',
    ),
    (
      q: 'Does PolyTICK represent or work with the U.S. Government?',
      a: 'No. PolyTICK is an independent data analysis and market research platform operated by ZenAIautomation.com. PolyTICK does NOT represent, hold affiliation with, or act on behalf of the U.S. Government, Congress, or any federal agency.',
    ),
    (
      q: 'Where does PolyTICK get its data?',
      a: 'All data is gathered from official public government portals (disclosures-clerk.house.gov, efdsearch.senate.gov, congress.gov, sec.gov/edgar) as well as public institutional filings (such as ARK Invest daily disclosures) and consensus analyst targets.',
    ),
    (
      q: 'What are the 8 layers of intelligence?',
      a: 'PolyTICK combines: 1) Real-time Politician Disclosures, 2) Committee Cross-Referencing, 3) ARK Invest Daily Bets, 4) Wall Street Analyst Targets, 5) Confluence Overlay Signals, 6) Motley Fool Holdings, 7) AI/ML Pattern Scoring, and 8) Congressional Hearing Sentiment Analysis.',
    ),
    (
      q: 'How do politicians’ portfolios historically perform against the S&P 500?',
      a: 'Academic studies and historical filing records show that top congressional traders frequently outperform the S&P 500 by double-digit margins. Lawmakers in key committees trade options and equities in sectors they directly oversee.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // ── Government Data & Non-Affiliation Disclaimer Banner ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          size: 18,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Government Data Sources & Non-Affiliation',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PolyTICK is an independent data analysis platform by ZenAIautomation.com and is NOT affiliated with or representing any government entity. Data is compiled from public federal records:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildGovChip('House: clerk.house.gov', 'https://disclosures-clerk.house.gov'),
                      _buildGovChip('Senate: efdsearch.senate.gov', 'https://efdsearch.senate.gov'),
                      _buildGovChip('Congress: congress.gov', 'https://www.congress.gov'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = faqs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    title: Text(
                      item.q,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                        child: Text(
                          item.a,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGovChip(String label, String url) {
    return GestureDetector(
      onTap: () => _launchExternalUrl(url),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.open_in_new_rounded,
                size: 11,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


