import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  // Default second item expanded matching the Figma screenshot
  int? _expandedIndex = 1;

  Future<void> _launchUrl(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  static const List<_FaqItemData> _faqItems = [
    _FaqItemData(
      number: '01.',
      question: 'How do members of Congress legally trade stocks on insider knowledge?',
      answer:
          'Under the 2012 STOCK Act (Stop Trading on Congressional Knowledge Act), lawmakers must publicly disclose transactions within 45 days. These reports are published as official public records on federal portals: the House Clerk (disclosures-clerk.house.gov) and Senate eFD (efdsearch.senate.gov). While lawmakers attend closed-door briefings on defense contracts, healthcare approvals, and regulatory shifts, PolyTICK analyzes these official public filings to reveal trades executed by committee members.',
    ),
    _FaqItemData(
      number: '02.',
      question: 'What is PolyTICK’s 8-Layer Intelligence Engine and how does it work?',
      answer:
          'Raw disclosures are not enough. PolyTICK combines 8 proprietary layers of intelligence: (1) Real-Time Politician Stock Disclosures from official public records, (2) Congressional Committee & Subcommittee Cross-Referencing (congress.gov), (3) ARK Invest Daily Trade Tracking, (4) Wall Street Analyst Consensus & Price Targets, (5) Proprietary Overlay Momentum Indicators, (6) Motley Fool Stock Advisor Holdings, (7) AI & Machine Learning Alpha Scoring, and (8) Congressional Hearing Sentiment Analysis. This filters out noise and highlights high-conviction legislative plays.',
    ),
    _FaqItemData(
      number: '03.',
      question: 'How do politicians’ portfolios historically perform against the S&P 500?',
      answer:
          'Academic studies and historical filing records show that top congressional traders consistently outperform the S&P 500 by double-digit margins. Lawmakers in key committees—such as Armed Services, Financial Services, and Energy—frequently trade deep-in-the-money LEAPS options and sector leaders right before major legislative or budget breakthroughs. PolyTICK tracks historical hit rates and profit margins for every member of Congress based on official public disclosures.',
    ),
    _FaqItemData(
      number: '04.',
      question: 'Can retail investors legally copy and mirror politician trades?',
      answer:
          'Yes, 100% legally. Every disclosure processed by PolyTICK is a matter of public federal record mandated by US law (STOCK Act of 2012) and published on official government websites (disclosures-clerk.house.gov & efdsearch.senate.gov). Copy-trading or using congressional disclosures as conviction filters is completely legal for all retail and institutional investors. PolyTICK simply transforms raw public filings into actionable, layered trading setups.',
    ),
    _FaqItemData(
      number: '05.',
      question: 'Is PolyTICK free to use, and how do I get started?',
      answer:
          'Yes! PolyTICK offers a 14-day free trial with zero credit card required. You get 100% full access to all real-time politician disclosures, 8 intelligence layers, millionaire mindset audio, trading e-books, and educational gifts. After your trial, you can continue with our Standard tier (\$14.99/mo or \$149.99/yr) or apply for Elite 1-on-1 Mentorship to trade directly alongside our founding team.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 36.0, bottom: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FAQ',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 1.15,
                    ),
                    children: [
                      const TextSpan(text: 'Everything '),
                      TextSpan(
                        text: 'You',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const TextSpan(text: ' Need to Know.'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Non-Affiliation & Government Sources Banner ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Government Data & Non-Affiliation Disclaimer',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'PolyTICK is an independent platform by ZenAIautomation.com and does NOT represent or hold affiliation with any government entity. Data is sourced from official public federal records:',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildGovLink('House: clerk.house.gov', 'https://disclosures-clerk.house.gov'),
                          _buildGovLink('Senate: efdsearch.senate.gov', 'https://efdsearch.senate.gov'),
                          _buildGovLink('Congress: congress.gov', 'https://www.congress.gov'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── FAQ Accordion List ──
          ..._faqItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 18.0),
              child: _buildAccordionItem(
                item: item,
                isExpanded: isExpanded,
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccordionItem({
    required _FaqItemData item,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          // ── Charcoal Gray Container Bar (#4D4C4C) ──
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 36.0),
            padding: const EdgeInsets.only(
              left: 28.0,
              right: 18.0,
              top: 14.0,
              bottom: 14.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4D4C4C), // Charcoal Gray #4D4C4C
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Question Row + Dropdown Chevron
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item.question,
                        style: GoogleFonts.poppins(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0, // Flips arrow smoothly
                      duration: const Duration(milliseconds: 240),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Expanded Answer Content
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                    child: Text(
                      item.answer,
                      style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withAlpha(230),
                        height: 1.45,
                      ),
                    ),
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 240),
                ),
              ],
            ),
          ),

          // ── Left Overlapping Black Circle Badge (#000000) ──
          Positioned(
            left: 12.0,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.black, // #000000
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.number,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovLink(String text, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(6),
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
                text,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
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

class _FaqItemData {
  final String number;
  final String question;
  final String answer;

  const _FaqItemData({
    required this.number,
    required this.question,
    required this.answer,
  });
}
