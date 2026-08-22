import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PricingFaqSection extends StatefulWidget {
  const PricingFaqSection({super.key});

  @override
  State<PricingFaqSection> createState() => _PricingFaqSectionState();
}

class _PricingFaqSectionState extends State<PricingFaqSection> {
  // Default second item expanded matching the Figma screenshot
  int? _expandedIndex = 1;

  static const List<_PricingFaqItemData> _items = [
    _PricingFaqItemData(
      question: 'Is copying US Congress stock trades 100% legal?',
      answer:
          'Yes, 100% legal. Under the federal STOCK Act of 2012, all 535 members of Congress and their spouses are legally mandated to publicly disclose every personal stock and options transaction. PolyTICK continuously ingests, normalizes, and decodes these public government disclosures in real time so retail traders can trade with the exact same data.',
    ),
    _PricingFaqItemData(
      question: 'Why do politicians like Nancy Pelosi beat the S&P 500 so consistently?',
      answer:
          'Key congressional leaders sit on committees that draft legislation, oversee regulatory approvals, and award trillions in government contracts across defense, healthcare, and Big Tech. Historically, top politicians have outperformed the market by double-digit margins. PolyTICK maps every trade directly to committee power, historical win rates, and options leverage so you can ride their highest-conviction moves.',
    ),
    _PricingFaqItemData(
      question: 'What happens if I cancel or want to switch plans?',
      answer:
          "You have complete freedom with zero risk. You can upgrade, downgrade, or cancel anytime with a single click inside your dashboard. If you cancel, you keep 100% full access to all 8 layers until the end of your billing cycle, after which your account seamlessly moves to our permanent Free tier without losing your trade history.",
    ),
    _PricingFaqItemData(
      question: 'How can I use PolyTICK completely free through referrals?',
      answer:
          "Through our 'Invite Friends. Get Rewarded' program, every person who joins using your referral link gets an instant 10% discount, and you earn a recurring 10% cash credit from their subscription. You can stack your credits month after month to use PolyTICK's Pro and Elite layers completely free.",
    ),
    _PricingFaqItemData(
      question: 'Is Elite 1-on-1 Coaching suitable for beginners?',
      answer:
          'Absolutely. Elite Coaching is tailored for both new traders seeking a profitable foundation and experienced traders looking to scale. You get direct weekly 1-on-1 strategy sessions with our founders to master the 8-Layer Engine, implement proven risk management frameworks, and execute institutional-grade political trade strategies.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      margin: const EdgeInsets.only(top: 40, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── DETAILS Tag ──
          Text(
            'DETAILS',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 6),

          // ── Pricing Questions. Header ──
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 32,
                color: const Color(0xFF000000),
                height: 1.05,
              ),
              children: [
                const TextSpan(
                  text: 'Pricing\n',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                TextSpan(
                  text: 'Questions.',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Accordion List ──
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = _items[index];
              final isExpanded = _expandedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isExpanded ? 20 : 16,
                  ),
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isExpanded
                          ? Colors.transparent
                          : const Color(0xFF000000),
                      width: 2,
                    ),
                    boxShadow: isExpanded
                        ? const [
                            BoxShadow(
                              color: Color(0x2E000000),
                              blurRadius: 16,
                              offset: Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Row + Chevron
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.question,
                              style: GoogleFonts.poppins(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                                color: isExpanded
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xFF000000),
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 26,
                            color: isExpanded
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF000000),
                          ),
                        ],
                      ),

                      // Expandable Answer Text
                      if (isExpanded) ...[
                        const SizedBox(height: 16),
                        Text(
                          item.answer,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xB8FFFFFF), // rgba(255,255,255,0.72)
                            height: 1.45,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PricingFaqItemData {
  final String question;
  final String answer;

  const _PricingFaqItemData({
    required this.question,
    required this.answer,
  });
}
