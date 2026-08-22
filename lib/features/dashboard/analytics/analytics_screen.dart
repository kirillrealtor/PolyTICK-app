import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/analytics_model.dart';
import 'package:polytick_app/features/dashboard/analytics/analytics_provider.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/analyst_targets_gauge.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:polytick_app/shared/widgets/stock_logo.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _tickersPage = 1;
  int _itemsPerPage = 10;
  int _industryRotationPage = 1;
  int _industryRoiPage = 1;
  static const int _itemsPerIndustryPage = 10;

  bool _showSignificantOnly = true;

  final TextEditingController _tickerSearchController = TextEditingController();
  String _tickerSearch = '';
  String? _expandedTicker;

  @override
  void dispose() {
    _tickerSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(analyticsDataProvider);
    final selectedDays = ref.watch(analyticsDaysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Global Timeframe Selector Chips ──
        _buildGlobalTimeframeSelector(selectedDays),

        const SizedBox(height: 16),

        // ── 2. Async Content ──
        asyncData.when(
          data: (data) => _buildAnalyticsContent(data),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: FuturisticLoader(text: 'Analyzing Congressional Trades...')),
          ),
          error: (err, _) => ErrorBoundaryWidget(
            componentName: 'Trading Analytics',
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(analyticsDataProvider),
          ),
        ),
      ],
    );
  }

  // ── 1. Global Timeframe Selector (Matching Screenshot 1) ──
  Widget _buildGlobalTimeframeSelector(int? selectedDays) {
    final frames = [
      (null, 'All Time'),
      (7, 'Last 7 Days'),
      (14, 'Last 14 Days'),
      (30, 'Last 30 Days'),
      (45, 'Last 45 Days'),
      (60, 'Last 60 Days'),
      (90, 'Last 90 Days'),
      (180, 'Last 180 Days'),
      (365, 'Last 365 Days'),
      (1095, 'Last 1095 Days'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF131722),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(12)),
        ),
        child: Row(
          children: frames.map((f) {
            final isSelected = selectedDays == f.$1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () {
                  if (selectedDays != f.$1) {
                    ref.read(analyticsDaysProvider.notifier).state = f.$1;
                    setState(() {
                      _tickersPage = 1;
                      _expandedTicker = null;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF2563EB) : Colors.white.withAlpha(5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF60A5FA) : Colors.transparent,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withAlpha(120),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    f.$2,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── 2. Full Analytics Body ──
  Widget _buildAnalyticsContent(AnalyticsData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── A. 13 Macro Stats Cards Grid (Screenshot 1) ──
        _buildStatsCardsGrid(data),

        const SizedBox(height: 24),

        // ── B. Top Tickers Table Section (Screenshot 1) ──
        _buildTopTickersSection(data),

        const SizedBox(height: 24),

        // ── C. Trades By Year & Trades By Party (Screenshot 2) ──
        _buildYearAndPartyGrid(data),

        const SizedBox(height: 24),

        // ── D. Market Mood Index & Momentum Line Chart (Screenshot 2) ──
        _buildMoodAndMomentumSection(data),

        const SizedBox(height: 24),

        // ── E. Industry Rotation & Industry Performance ROI (Screenshot 3) ──
        _buildIndustrySection(data),

        const SizedBox(height: 24),

        // ── F. Convergence (Bipartisan Bets) (Screenshot 3) ──
        _buildConvergenceSection(data),

        const SizedBox(height: 20),
      ],
    );
  }

  // ── A. 13 Stats Cards Grid (Matching Screenshot 1) ──
  Widget _buildStatsCardsGrid(AnalyticsData data) {
    final cards = [
      ('POLITICIANS', '${data.politicians}', 'The number of individual members of Congress who filed trades.'),
      ('TOTAL TRADES', NumberFormat('#,###').format(data.trades), 'The total count of all purchase and sale transactions filed.'),
      ('BUYS', NumberFormat('#,###').format(data.buys), 'Total purchase transactions.'),
      ('SELLS', NumberFormat('#,###').format(data.sells), 'Total sale transactions.'),
      ('UNIQUE TICKERS', '${data.uniqueTickers}', 'The number of different stocks or ETFs traded.'),
      ('AVG/POLITICIAN', data.avgTradesPerPolitician.toStringAsFixed(1), 'Average trades per active member.'),
      ('B/S RATIO', data.buySellRatio.toStringAsFixed(2), 'Ratio of purchases to sales.'),
      ('SPOUSE', '${data.spouseTrades}', 'Trades made on behalf of a spouse.'),
      ('JOINT', '${data.jointTrades}', 'Trades made from joint family accounts.'),
      ('SELF', '${data.selfTrades}', 'Trades made in politician\'s own account.'),
      ('TOTAL VOL', _formatVolumeNumber(data.totalVolume), 'Estimated total dollar value traded.'),
      ('VOL BOUGHT', _formatVolumeNumber(data.volBought), 'Estimated dollar amount of purchases.'),
      ('VOL SOLD', _formatVolumeNumber(data.volSold), 'Estimated dollar amount of sales.'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, idx) {
        final c = cards[idx];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      c.$1,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: const Color(0xFF94A3B8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.info_outline_rounded, size: 12, color: Color(0xFF64748B)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                c.$2,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // ── B. Top Tickers Table Section (Matching Screenshot 1) ──
  Widget _buildTopTickersSection(AnalyticsData data) {
    final selectedSort = ref.watch(analyticsSortByProvider);
    final query = _tickerSearch.toLowerCase().trim();

    final filtered = data.topTickers.where((t) {
      if (query.isEmpty) return true;
      return t.ticker.toLowerCase().contains(query);
    }).toList();

    final totalPages = (filtered.length / _itemsPerPage).ceil().clamp(1, 9999);
    final startIndex = (_tickersPage - 1) * _itemsPerPage;
    final itemsToShow = filtered.skip(startIndex).take(_itemsPerPage).toList();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Top Tickers title & Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top Tickers',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tickerSearchController,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search ticker (e.g. NVDA)...',
                    hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B)),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                    suffixIcon: _tickerSearch.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              setState(() {
                                _tickerSearchController.clear();
                                _tickerSearch = '';
                                _tickersPage = 1;
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withAlpha(6),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withAlpha(15)),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _tickerSearch = val;
                      _tickersPage = 1;
                    });
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0x1AFFFFFF)),

          // Horizontally Scrollable 8-Column Table (Matching Desktop Web App)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 850,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: Colors.white.withAlpha(4),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text('Ticker', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        _sortHeader('Trades', 'tradeCount', selectedSort, 70),
                        _sortHeader('Pols', 'uniquePoliticians', selectedSort, 60),
                        _sortHeader('Buys', 'numBuys', selectedSort, 60, const Color(0xFF34D399)),
                        _sortHeader('Sells', 'numSells', selectedSort, 60, const Color(0xFFF87171)),
                        _sortHeader('Aggregate Buy Volume', 'buyVolume', selectedSort, 150),
                        _sortHeader('Aggregate Sell Volume', 'sellVolume', selectedSort, 150),
                        _sortHeader('Direction', 'netVolume', selectedSort, 110, null, TextAlign.right),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0x1AFFFFFF)),

                  // Rows
                  if (itemsToShow.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text('No tickers found.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemsToShow.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x0FFFFFFF)),
                      itemBuilder: (context, idx) {
                        final item = itemsToShow[idx];
                        final isExpanded = _expandedTicker == item.ticker;
                        final isNetPos = item.netVolume >= 0;

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedTicker = isExpanded ? null : item.ticker;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    // Ticker with logo
                                    SizedBox(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          StockLogo(ticker: item.ticker, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            item.ticker,
                                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Trades
                                    SizedBox(
                                      width: 70,
                                      child: Text('${item.tradeCount}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white)),
                                    ),

                                    // Pols
                                    SizedBox(
                                      width: 60,
                                      child: Text('${item.uniquePoliticians}', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFFCBD5E1))),
                                    ),

                                    // Buys (Green)
                                    SizedBox(
                                      width: 60,
                                      child: Text('${item.numBuys}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF34D399))),
                                    ),

                                    // Sells (Red)
                                    SizedBox(
                                      width: 60,
                                      child: Text('${item.numSells}', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFF87171))),
                                    ),

                                    // Aggregate Buy Volume (White Mono)
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        _formatVolume(item.buyVolume),
                                        style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ),

                                    // Aggregate Sell Volume (White Mono)
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        _formatVolume(item.sellVolume),
                                        style: GoogleFonts.poppins(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ),

                                    // Direction / Net Volume (Green/Red Mono)
                                    SizedBox(
                                      width: 110,
                                      child: Text(
                                        '${isNetPos ? '+' : ''}${_formatVolume(item.netVolume)}',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w900,
                                          color: isNetPos ? const Color(0xFF34D399) : const Color(0xFFF87171),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Expandable Live Analyst Targets Gauge
                            if (isExpanded) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: AnalystTargetsGauge(ticker: item.ticker),
                              ),
                              const Divider(height: 1, color: Color(0x14FFFFFF)),
                            ],
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),

          // Pagination Bar (Compact, Responsive, No Overflow)
          const Divider(height: 1, color: Color(0x1AFFFFFF)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Show ', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white.withAlpha(20)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _itemsPerPage,
                          dropdownColor: const Color(0xFF1E293B),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          icon: const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF94A3B8)),
                          items: const [
                            DropdownMenuItem(value: 10, child: Text('10')),
                            DropdownMenuItem(value: 20, child: Text('20')),
                            DropdownMenuItem(value: 50, child: Text('50')),
                            DropdownMenuItem(value: 100, child: Text('100')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _itemsPerPage = val;
                                _tickersPage = 1;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('${itemsToShow.length} of ${filtered.length}',
                        style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF64748B))),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      icon: const Icon(Icons.chevron_left_rounded, size: 16, color: Colors.white),
                      onPressed: _tickersPage > 1 ? () => setState(() => _tickersPage--) : null,
                    ),
                    Text('$_tickersPage / $totalPages', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      icon: const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.white),
                      onPressed: _tickersPage < totalPages ? () => setState(() => _tickersPage++) : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortHeader(String label, String sortKey, String currentSort, double width, [Color? color, TextAlign align = TextAlign.left]) {
    final isSorted = currentSort == sortKey;
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          ref.read(analyticsSortByProvider.notifier).state = sortKey;
          setState(() {
            _tickersPage = 1;
            _expandedTicker = null;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: align == TextAlign.right ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: isSorted ? FontWeight.w800 : FontWeight.w600,
                  color: color ?? (isSorted ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8)),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSorted)
              const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF60A5FA)),
          ],
        ),
      ),
    );
  }

  // ── C. Trades By Year & Trades By Party (Matching Screenshot 2) ──
  Widget _buildYearAndPartyGrid(AnalyticsData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trades By Year Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trades By Year',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 10),
                for (final y in data.tradesByYear) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(y.year, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(8),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withAlpha(12)),
                          ),
                          child: Text(
                            NumberFormat('#,###').format(y.tradeCount),
                            style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Trades By Party Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withAlpha(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trades By Party',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 10),
                for (final p in data.tradesByParty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.party,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: p.party.toLowerCase() == 'democrat'
                                ? const Color(0xFF60A5FA)
                                : (p.party.toLowerCase() == 'republican' ? const Color(0xFFF87171) : const Color(0xFF94A3B8)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(8),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withAlpha(12)),
                          ),
                          child: Text(
                            NumberFormat('#,###').format(p.tradeCount),
                            style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── D. Market Mood Index & Momentum Line Chart (Matching Screenshot 2) ──
  Widget _buildMoodAndMomentumSection(AnalyticsData data) {
    final score = data.sentimentScore.toDouble();
    final pct = ((score + 1) / 2 * 100).round().clamp(0, 100);
    final isBullish = score > 0.15;
    final isBearish = score < -0.15;
    final sentimentLabel = isBullish ? 'BULLISH' : (isBearish ? 'BEARISH' : 'NEUTRAL');
    final sentimentColor = isBullish ? const Color(0xFF10B981) : (isBearish ? const Color(0xFFEF4444) : const Color(0xFFF59E0B));

    final totalTradesCount = (data.buys + data.sells);
    final buyPct = totalTradesCount > 0 ? ((data.buys / totalTradesCount) * 100).round() : 50;
    final sellPct = 100 - buyPct;

    return Column(
      children: [
        // Market Mood Index Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            children: [
              Text(
                'Market Mood Index',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFFCBD5E1)),
              ),
              const SizedBox(height: 12),

              // Semicircular Mood Gauge
              SizedBox(
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(200, 100),
                      painter: _GaugePainter(percentage: pct / 100, color: sentimentColor),
                    ),
                    Positioned(
                      bottom: 4,
                      child: Column(
                        children: [
                          Text(
                            '$pct%',
                            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                          Text(
                            sentimentLabel,
                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w800, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Buy/Sell Count Balance Bar (Matching Screenshot 2)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('BUYS (${NumberFormat('#,###').format(data.buys)})',
                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w800, color: const Color(0xFF34D399))),
                        Text('SELLS (${NumberFormat('#,###').format(data.sells)})',
                            style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w800, color: const Color(0xFFF87171))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 7,
                        child: Row(
                          children: [
                            Expanded(flex: buyPct, child: Container(color: const Color(0xFF10B981))),
                            Expanded(flex: sellPct, child: Container(color: const Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$buyPct%', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
                        Text('Buy/Sell Count Balance', style: GoogleFonts.inter(fontSize: 10, fontStyle: FontStyle.italic, color: const Color(0xFF94A3B8))),
                        Text('$sellPct%', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Volume-weighted sentiment index calculated from total Buy vs. Sell dollar amounts in the selected period.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B), height: 1.4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Political Trading Momentum Chart Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Political Trading Momentum',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  Text(
                    'Daily Buy vs. Sell volume',
                    style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dual Line Area Visualizer
              SizedBox(
                height: 160,
                width: double.infinity,
                child: CustomPaint(
                  painter: _MomentumChartPainter(data.momentumSeries),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Buy Vol', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFCBD5E1))),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Sell Vol', style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: const Color(0xFFCBD5E1))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── E. Industry Rotation & Performance ROI (Matching Screenshot 3) ──
  Widget _buildIndustrySection(AnalyticsData data) {
    final filteredSectors = data.sectorSummary
        .where((s) => !_showSignificantOnly || s.totalVol >= 1000000)
        .toList();

    // 1. Industry Rotation
    final rotationTotalPages = (filteredSectors.length / _itemsPerIndustryPage).ceil().clamp(1, 9999);
    final rotationStart = (_industryRotationPage - 1) * _itemsPerIndustryPage;
    final rotationItems = filteredSectors.skip(rotationStart).take(_itemsPerIndustryPage).toList();

    // 2. Industry Performance (Sorted by ROI desc)
    final roiSorted = List<SectorSummaryItem>.from(filteredSectors)..sort((a, b) => b.avgRoi.compareTo(a.avgRoi));
    final roiTotalPages = (roiSorted.length / _itemsPerIndustryPage).ceil().clamp(1, 9999);
    final roiStart = (_industryRoiPage - 1) * _itemsPerIndustryPage;
    final roiItems = roiSorted.skip(roiStart).take(_itemsPerIndustryPage).toList();

    return Column(
      children: [
        // ── 1. Industry Rotation (Horizontal Diverging Net Flows) ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Industry Rotation',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (data.totalNetFlow >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: data.totalNetFlow >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444), width: 0.8),
                    ),
                    child: Text(
                      'NET: ${data.totalNetFlow >= 0 ? '+' : ''}${_formatVolumeShort(data.totalNetFlow)} ${data.totalNetFlow >= 0 ? 'INFLOW' : 'OUTFLOW'}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: data.totalNetFlow >= 0 ? const Color(0xFF34D399) : const Color(0xFFF87171),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Filter Checkbox
              GestureDetector(
                onTap: () => setState(() {
                  _showSignificantOnly = !_showSignificantOnly;
                  _industryRotationPage = 1;
                  _industryRoiPage = 1;
                }),
                child: Row(
                  children: [
                    Checkbox(
                      value: _showSignificantOnly,
                      activeColor: const Color(0xFF3B82F6),
                      checkColor: Colors.white,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) => setState(() {
                        _showSignificantOnly = val ?? true;
                        _industryRotationPage = 1;
                        _industryRoiPage = 1;
                      }),
                    ),
                    Text(
                      'Significant Only (> \$1M Total Vol)',
                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Diverging Bar Rows
              for (final s in rotationItems) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              s.industry,
                              style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${s.netFlow >= 0 ? '+' : ''}${_formatVolumeShort(s.netFlow)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: s.netFlow >= 0 ? const Color(0xFF34D399) : const Color(0xFFF87171),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          height: 6,
                          child: Row(
                            children: [
                              if (s.netFlow < 0) ...[
                                Expanded(child: Container(color: const Color(0xFFEF4444))),
                                Expanded(child: Container(color: Colors.white.withAlpha(8))),
                              ] else ...[
                                Expanded(child: Container(color: Colors.white.withAlpha(8))),
                                Expanded(child: Container(color: const Color(0xFF10B981))),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Prev / Next
              if (rotationTotalPages > 1) ...[
                const Divider(height: 1, color: Color(0x1AFFFFFF)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _industryRotationPage > 1 ? () => setState(() => _industryRotationPage--) : null,
                        child: Text('< PREV', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ),
                      Text('Page $_industryRotationPage / $rotationTotalPages', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
                      TextButton(
                        onPressed: _industryRotationPage < rotationTotalPages ? () => setState(() => _industryRotationPage++) : null,
                        child: Text('NEXT >', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 8),
              Text(
                'Logic: Calculates Net Flow (Total Buy Volume - Total Sell Volume) per industry to identify where smart political capital is rotating.',
                style: GoogleFonts.inter(fontSize: 9.5, fontStyle: FontStyle.italic, color: const Color(0xFF64748B), height: 1.3),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── 2. Industry Performance ROI ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Industry Performance (ROI)',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 12),

              for (final s in roiItems) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          s.industry,
                          style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFFCBD5E1)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (s.avgRoi >= 0 ? const Color(0xFF3B82F6) : const Color(0xFF64748B)).withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${s.avgRoi >= 0 ? '+' : ''}${s.avgRoi.toStringAsFixed(1)}%',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: s.avgRoi >= 0 ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (roiTotalPages > 1) ...[
                const Divider(height: 1, color: Color(0x1AFFFFFF)),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _industryRoiPage > 1 ? () => setState(() => _industryRoiPage--) : null,
                        child: Text('< PREV', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ),
                      Text('Page $_industryRoiPage / $roiTotalPages', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B))),
                      TextButton(
                        onPressed: _industryRoiPage < roiTotalPages ? () => setState(() => _industryRoiPage++) : null,
                        child: Text('NEXT >', style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8))),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 8),
              Text(
                'Average performance of stocks within each sector relative to the price when politicians first entered.',
                style: GoogleFonts.inter(fontSize: 9.5, fontStyle: FontStyle.italic, color: const Color(0xFF64748B), height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── F. Convergence (Bipartisan Bets) (Matching Screenshot 3) ──
  Widget _buildConvergenceSection(AnalyticsData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤝', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Convergence',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Grid of Bipartisan Cards (Screenshot 3)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.0,
            ),
            itemCount: data.convergence.length,
            itemBuilder: (context, idx) {
              final c = data.convergence[idx];
              final total = (c.demVol + c.repVol).toDouble();
              final demPct = total > 0 ? ((c.demVol / total) * 100).round() : 50;
              final repPct = 100 - demPct;

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StockLogo(ticker: c.ticker, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          c.ticker,
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          'Bipartisan',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFF60A5FA)),
                        ),
                      ],
                    ),

                    // Dual Color Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 5,
                        child: Row(
                          children: [
                            Expanded(flex: demPct, child: Container(color: const Color(0xFF3B82F6))),
                            Expanded(flex: repPct, child: Container(color: const Color(0xFFEF4444))),
                          ],
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('D: ${_formatVolumeShort(c.demVol)}', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFF60A5FA))),
                        Text('R: ${_formatVolumeShort(c.repVol)}', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFF87171))),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),
          Text(
            'Stocks with significant buy volume from both Democratic and Republican parties.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  String _formatVolumeNumber(num? val) {
    if (val == null || val == 0) return '\$0';
    return '\$${NumberFormat('#,###').format(val)}';
  }

  String _formatVolume(num? val) => _formatVolumeShort(val);

  String _formatVolumeShort(num? val) {
    if (val == null || val == 0) return '\$0';
    final isNegative = val < 0;
    final abs = val.abs();
    String formatted;
    if (abs >= 1000000000) {
      formatted = '\$${(abs / 1000000000).toStringAsFixed(2)}B';
    } else if (abs >= 1000000) {
      formatted = '\$${(abs / 1000000).toStringAsFixed(2)}M';
    } else if (abs >= 1000) {
      formatted = '\$${(abs / 1000).toStringAsFixed(1)}K';
    } else {
      formatted = '\$${abs.toStringAsFixed(0)}';
    }
    return isNegative ? '-$formatted' : formatted;
  }
}

// ── Momentum Area Chart Custom Painter ──
class _MomentumChartPainter extends CustomPainter {
  final List<MomentumPoint> series;

  _MomentumChartPainter(this.series);

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;

    final maxVal = series.map((s) => math.max(s.buyVol, s.sellVol)).reduce(math.max).toDouble();
    if (maxVal <= 0) return;

    final buyPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final sellPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final buyPath = Path();
    final sellPath = Path();

    final stepX = size.width / (series.length - 1).clamp(1, 9999);

    for (int i = 0; i < series.length; i++) {
      final x = i * stepX;
      final yBuy = size.height - (series[i].buyVol / maxVal * (size.height - 10));
      final ySell = size.height - (series[i].sellVol / maxVal * (size.height - 10));

      if (i == 0) {
        buyPath.moveTo(x, yBuy);
        sellPath.moveTo(x, ySell);
      } else {
        buyPath.lineTo(x, yBuy);
        sellPath.lineTo(x, ySell);
      }
    }

    canvas.drawPath(buyPath, buyPaint);
    canvas.drawPath(sellPath, sellPaint);
  }

  @override
  bool shouldRepaint(covariant _MomentumChartPainter oldDelegate) => true;
}

// ── Semicircular Gauge Custom Painter ──
class _GaugePainter extends CustomPainter {
  final double percentage;
  final Color color;

  const _GaugePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 8;

    final bgPaint = Paint()
      ..color = Colors.white.withAlpha(20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Background Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Filled Arc
    final sweepAngle = math.pi * percentage.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
