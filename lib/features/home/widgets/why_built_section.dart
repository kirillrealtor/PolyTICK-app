import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhyBuiltSection extends StatefulWidget {
  const WhyBuiltSection({super.key});

  @override
  State<WhyBuiltSection> createState() => _WhyBuiltSectionState();
}

class _WhyBuiltSectionState extends State<WhyBuiltSection> {
  late final ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (!_scrollController.hasClients) return;
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll <= 0) return;
        setState(() {
          _scrollProgress = (_scrollController.offset / maxScroll).clamp(0.0, 1.0);
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 36.0, bottom: 44.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.15,
                ),
                children: [
                  const TextSpan(text: 'Why We Built '),
                  TextSpan(
                    text: 'PolyTICK.',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Horizontal Scrollable Bento Columns (All 8 Cards) ──
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Column 1: Josh Gottheimer (Blue) + Tommy Tuberville (Red) ──
                SizedBox(
                  width: 295,
                  child: Column(
                    children: [
                      _buildPoliticianCard(
                        cardColor: const Color(0xFF51A2FF),
                        shadowColor: const Color(0xFF0F172A),
                        textColor: Colors.black,
                        title: 'Josh Gottheimer\n(D-NJ).',
                        description:
                            'Visa and Mastercard trades around DOJ antitrust probes returned 65% in 2024, helping boost wealth to \$30M+.',
                        badgeColor: const Color(0xFFE2E8F0),
                        badgeIcon: Icons.calendar_today_outlined,
                        badgeIconColor: Colors.black87,
                        badgeOnRight: false,
                      ),
                      const SizedBox(height: 26),
                      _buildPoliticianCard(
                        cardColor: const Color(0xFFC60C30),
                        shadowColor: const Color(0xFF600617),
                        textColor: Colors.white,
                        title: 'Tommy Tuberville\n(R-AL).',
                        description:
                            'One of Congress\'s most active traders with 1,300+ trades since 2021. Profited from ExxonMobil and Lockheed Martin ahead of energy and defense hearings, lifting wealth to \$15M+.',
                        badgeColor: const Color(0xFFFEB40D),
                        badgeIcon: Icons.account_balance,
                        badgeIconColor: Colors.white,
                        badgeOnRight: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),

                // ── Column 2: Nancy Pelosi & Family (Red) + Brian Higgins (Blue) ──
                SizedBox(
                  width: 295,
                  child: Column(
                    children: [
                      _buildPoliticianCard(
                        cardColor: const Color(0xFFC60C30),
                        shadowColor: const Color(0xFF600617),
                        textColor: Colors.white,
                        title: 'Nancy Pelosi &\nFamily.',
                        description:
                            'Paul Pelosi’s high-profile trades in Visa and Nvidia often aligned with legislative actions, growing their net worth beyond \$400M. Trackers like \'Pelosi Tracker\' highlight how retail investors profited by following these trades.',
                        badgeColor: const Color(0xFFFEB40D),
                        badgeIcon: Icons.arrow_upward,
                        badgeIconColor: Colors.white,
                        badgeOnRight: true,
                      ),
                      const SizedBox(height: 26),
                      _buildPoliticianCard(
                        cardColor: const Color(0xFF51A2FF),
                        shadowColor: const Color(0xFF0F172A),
                        textColor: Colors.black,
                        title: 'Brian Higgins\n(D-NY).',
                        description:
                            'Bought Nvidia options before CHIPS Act rollout — 180% surge netted millions before leaving Congress in 2024.',
                        badgeColor: const Color(0xFFE2E8F0),
                        badgeIcon: Icons.memory,
                        badgeIconColor: Colors.black87,
                        badgeOnRight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),

                // ── Column 3: Dan Crenshaw (Blue) + Markwayne Mullin (Red) ──
                SizedBox(
                  width: 295,
                  child: Column(
                    children: [
                      _buildPoliticianCard(
                        cardColor: const Color(0xFF51A2FF),
                        shadowColor: const Color(0xFF0F172A),
                        textColor: Colors.black,
                        title: 'Dan Crenshaw\n(R-TX).',
                        description:
                            'His portfolio beat the market in 2024, with Microsoft and JPMorgan trades timed around AI and banking policies. Net worth rose from \$1M in 2019 to \$10M+.',
                        badgeColor: const Color(0xFFE2E8F0),
                        badgeIcon: Icons.trending_up,
                        badgeIconColor: Colors.black87,
                        badgeOnRight: true,
                      ),
                      const SizedBox(height: 26),
                      _buildPoliticianCard(
                        cardColor: const Color(0xFFC60C30),
                        shadowColor: const Color(0xFF600617),
                        textColor: Colors.white,
                        title: 'Markwayne Mullin\n(R-OK).',
                        description:
                            'Heavy trades in Chevron and Archer-Daniels-Midland aligned with farm bill and oil policy debates. Net worth doubled.',
                        badgeColor: const Color(0xFFFEB40D),
                        badgeIcon: Icons.local_gas_station,
                        badgeIconColor: Colors.white,
                        badgeOnRight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),

                // ── Column 4: Ron Wyden (Red) + Defense Sector Trades (Blue) ──
                SizedBox(
                  width: 295,
                  child: Column(
                    children: [
                      _buildPoliticianCard(
                        cardColor: const Color(0xFFC60C30),
                        shadowColor: const Color(0xFF600617),
                        textColor: Colors.white,
                        title: 'Ron Wyden\n(D-OR).',
                        description:
                            'As Senate Finance Chair, Wyden traded Eli Lilly before FDA obesity approvals and Amazon during policy talks, boosting wealth to \$20M.',
                        badgeColor: const Color(0xFFFEB40D),
                        badgeIcon: Icons.medical_services_outlined,
                        badgeIconColor: Colors.white,
                        badgeOnRight: true,
                      ),
                      const SizedBox(height: 26),
                      _buildPoliticianCard(
                        cardColor: const Color(0xFF51A2FF),
                        shadowColor: const Color(0xFF0F172A),
                        textColor: Colors.black,
                        title: 'Defense Sector\nTrades.',
                        description:
                            'Lawmakers traded Lockheed Martin and Raytheon while serving on Armed Services Committees. 97 members traded sectors they oversee — profiting 20-30% from conflicts.',
                        badgeColor: const Color(0xFFE2E8F0),
                        badgeIcon: Icons.shield_outlined,
                        badgeIconColor: Colors.black87,
                        badgeOnRight: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Custom Figma Horizontal Scroll Track & Indicator (Frame 1618871344) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFE4E0E0), // Track background #E4E0E0
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // Left Arrow ◀ (play_arrow rotated 180deg)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.arrow_left,
                      size: 16,
                      color: Color(0xFF1D1B20),
                    ),
                  ),

                  // Middle Scroll Track with Pill Thumb (#A29D9D)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const thumbWidth = 90.0;
                        final availableWidth = constraints.maxWidth - thumbWidth;
                        final leftOffset = (_scrollProgress * availableWidth).clamp(0.0, availableWidth);

                        return Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Positioned(
                              left: leftOffset,
                              child: Container(
                                width: thumbWidth,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFA29D9D), // Thumb pill #A29D9D
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Right Arrow ▶ (play_arrow filled)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.arrow_right,
                      size: 16,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoliticianCard({
    required Color cardColor,
    required Color shadowColor,
    required Color textColor,
    required String title,
    required String description,
    required Color badgeColor,
    required IconData badgeIcon,
    required Color badgeIconColor,
    required bool badgeOnRight,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Main Card Container with Neo-Brutalist Hard 3D Shadow ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                offset: const Offset(10, 10), // Exact 3D hard offset
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Politician Title
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),

              // Description Body
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: textColor.withAlpha(235),
                  height: 1.42,
                ),
              ),
            ],
          ),
        ),

        // ── Floating Corner Badge ──
        Positioned(
          top: -14,
          right: badgeOnRight ? -8 : null,
          left: badgeOnRight ? null : -8,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                badgeIcon,
                size: 20,
                color: badgeIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
