import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class TradeHistoryScreen extends StatelessWidget {
  const TradeHistoryScreen({super.key});

  static const List<_YearCardData> _history = [
    _YearCardData(
      year: "2020",
      headline:
          "COVID Crash Dodge—Senators Sell Millions Pre-Plunge in Scandalous Stock Shenanigans!",
      paragraph:
          "The year the world stopped, but Congress's portfolios didn't—~6,000 trades beat the S&P's 18.4% with ~25% Dem and ~20% Rep averages, spotlighting the insider scandal. Senators like Kelly Loeffler (R-GA) and Richard Burr (R-NC) dumped millions in stocks after private COVID briefings but before the crash, sparking outrage and DOJ probes. Meanwhile, Pelosi bought big tech into the dip, riding Apple and Amazon's rebound to millions in profit. When Americans lost jobs, Congress gained wealth—and 2020 became the year Capitol Hill's credibility crashed harder than the markets.",
      backgroundColor: Color(0xFF1F2937),
      titleColor: Color(0xFFFFFFFF),
      paragraphColor: Color(0xFFD9D9D9),
    ),
    _YearCardData(
      year: "2021",
      headline:
          "Pandemic Payday—Congress Cashes In 30%+ as Recovery Rallies Ignite Insider Fireworks!",
      paragraph:
          "As America clawed back from COVID chaos, 2021 saw Congress go all-in with ~10,000 trades, holdings ballooning to \$631M including \$296M buys—averaging ~30% returns. Pelosi pocketed millions from bullish Tesla calls, while Republicans piled into oil and gas pre-price surges. Healthcare was another darling, with Moderna and Pfizer sprinkled like candy across portfolios. Democrats bagged ~35%, Republicans ~28%, while the S&P trailed at 26%. In plain English? Congress wasn't just reopening the economy—they were reopening the money printer for themselves.",
      backgroundColor: Color(0xFF600617),
      titleColor: Color(0xFFFFFFFF),
      paragraphColor: Color(0xFFD9D9D9),
    ),
    _YearCardData(
      year: "2022",
      headline:
          "Bear Market? Not for Congress—They Turned Turmoil into 51.6% Triumphs!",
      paragraph:
          "In the savage 2022 bear maul where the S&P plunged -19.4%, Congress played defense like pros, disclosing ~10,000 trades with Democrats at -2% and Republicans +0.4%. The real fireworks? Senators like Josh Hawley (R-MO) dodged the carnage by dumping tech in January, while Dems like Mark Kelly (D-AZ) scooped energy at the lows. Healthcare and defense were havens, with Northrop Grumman and Pfizer padding returns. Average lawmaker? Still cruising at 5–10% up, with standout portfolios peaking at 51.6%—a reminder that in Washington, bear markets are just buying opportunities in disguise.",
      backgroundColor: Color(0xFFD9D9D9),
      titleColor: Color(0xFF191919),
      paragraphColor: Color(0xFF191919),
    ),
    _YearCardData(
      year: "2023",
      headline:
          "Pelosi's 65% Magic—Congress Dodges Recession Blues with Billion-Dollar Bets!",
      paragraph:
          "Picture this: As the economy teetered on recession fears, Congress laughed all the way to the bank in 2023, logging ~4,000 trades topping \$1B in value. Pelosi stole headlines with a 65% portfolio surge—Nvidia, Microsoft, and Tesla padding her millions—while Rep. Dan Crenshaw (R-TX) flipped energy stocks for 45%. Financials and AI were the playgrounds, with lawmakers front-running Fed signals and AI hearings like seasoned pros. Democrats averaged +18%, Republicans +15%, while the S&P limped at 13%. Turns out, recession worries are just background noise when your \"research\" comes with a Congressional badge.",
      backgroundColor: Color(0xFF51A2FF),
      titleColor: Color(0xFF191919),
      paragraphColor: Color(0xFF191919),
    ),
    _YearCardData(
      year: "2024",
      headline:
          "Congress Crushes Wall Street—149% Returns? The Year Lawmakers Turned Hearings into Hedge Funds!",
      paragraph:
          "Hold onto your wallets: 2024 was the blockbuster where Congress didn't just beat the market—they obliterated it, with 113 members unleashing 9,261 trades worth \$706M. Senator Tom Carper (D-DE) casually clocked 149% returns, while Rep. Nancy Pelosi (D-CA) proved she's still the \"Oracle of Congress\" with Nvidia options up triple digits. Republican Rep. Brian Mast rode defense stocks for 80% gains, and bipartisan biotech plays saw lawmakers buying into Moderna and Regeneron pre-FDA nods. Average returns? Dems at 34%, GOP at 38%—all while the S&P scraped by at 24%. Forget hedge funds; Capitol Hill was the hottest investment club in America.",
      backgroundColor: Color(0xFF1E1E1E),
      titleColor: Color(0xFFEBEBEB),
      paragraphColor: Color(0xFFFFFFFF),
    ),
    _YearCardData(
      year: "2025",
      headline:
          "Capitol Hill's Crystal Ball? Lawmakers Ride AI Waves and Defense Dramas to Eye-Popping Gains Amid Election Fever!",
      paragraph:
          "Buckle up, because 2025 is shaping up as the year Congress turned policy previews into portfolio fireworks, with over 12,000 trades disclosed YTD through September 25—eclipsing 2024's record by 15%. Senator Tommy Tuberville (R-AL) banked \$1M off Palantir before a \$480M Army contract hit, while Rep. Ro Khanna (D-CA) surfed Nvidia's +190% run as AI mania swept the market. Defense darlings like Lockheed and Northrop got scooped up weeks before Pentagon budget boosts, and election-year energy is fueling even riskier bets. With Democrats boasting 30% YTD and Republicans at 27%, Congress is on pace to torch Wall Street's mere 12%—because apparently, democracy isn't the only thing they're trading this season!",
      backgroundColor: Color(0xFFC60C30),
      titleColor: Color(0xFF000000),
      paragraphColor: Color(0xFFFFFFFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Header Text ──
                Text(
                  'Verified Political Trading Activity.',
                  style: GoogleFonts.inter(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF191919),
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Where political decisions meet stock market performance.',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF000000),
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 36),

                // ── 2. Pricing Banner CTA ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Want Real-Time Alerts & Advanced Analytics ?',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFFFFF),
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => context.go('/pricing'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9CA3AF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View plans',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1E1E1E),
                                  width: 2.5,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── 3. Six Stylized Era Year Cards ──
                ..._history.map((card) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: card.backgroundColor,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${card.year}: ${card.headline}',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: card.titleColor,
                            height: 1.25,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          card.paragraph,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: card.paragraphColor,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _YearCardData {
  final String year;
  final String headline;
  final String paragraph;
  final Color backgroundColor;
  final Color titleColor;
  final Color paragraphColor;

  const _YearCardData({
    required this.year,
    required this.headline,
    required this.paragraph,
    required this.backgroundColor,
    required this.titleColor,
    required this.paragraphColor,
  });
}
