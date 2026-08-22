import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/ark_models.dart';
import 'package:polytick_app/features/dashboard/ark_invest/ark_provider.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/analyst_targets_gauge.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:polytick_app/shared/widgets/stock_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class ArkScreen extends ConsumerStatefulWidget {
  const ArkScreen({super.key});

  @override
  ConsumerState<ArkScreen> createState() => _ArkScreenState();
}

class _ArkScreenState extends ConsumerState<ArkScreen> {
  int _tradesPage = 1;
  int _holdingsPage = 1;
  int _newsPage = 1;
  int _stockTradesPage = 1;
  static const int _itemsPerPage = 20;

  // Track expanded cards for Analyst Targets gauge
  String? _expandedTicker;

  final TextEditingController _stockInputController = TextEditingController(text: 'TSLA');

  @override
  void dispose() {
    _stockInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSection = ref.watch(arkActiveSectionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Header Title ──
        Text(
          'ARK ETF & Stock Insights',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Track Cathie Wood and ARK Invest fund holdings and trades in real-time',
          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 16),

        // ── 2. Top Navigation Tabs ──
        _buildSectionTabs(activeSection),

        const SizedBox(height: 16),

        // ── 3. Filter Controls ──
        _buildFiltersCard(activeSection),

        const SizedBox(height: 20),

        // ── 4. Main Section Content ──
        _buildActiveContent(activeSection),
      ],
    );
  }

  // ── Navigation Tabs ──
  Widget _buildSectionTabs(String activeSection) {
    final tabs = [
      ('etfTrades', 'ETF Trades', Icons.trending_up_rounded),
      ('etfHoldings', 'ETF Holdings', Icons.pie_chart_outline_rounded),
      ('etfProfile', 'ETF Profile', Icons.info_outline_rounded),
      ('etfNews', 'ETF News', Icons.newspaper_rounded),
      ('stockTrades', 'Stock Trades', Icons.swap_horiz_rounded),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) {
          final isSelected = activeSection == t.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(arkActiveSectionProvider.notifier).state = t.$1;
                setState(() {
                  _tradesPage = 1;
                  _holdingsPage = 1;
                  _newsPage = 1;
                  _stockTradesPage = 1;
                  _expandedTicker = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF3B82F6) : Colors.white.withAlpha(15),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withAlpha(100),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      t.$3,
                      size: 15,
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      t.$2,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Filters Card ──
  Widget _buildFiltersCard(String activeSection) {
    final isEtf = activeSection.startsWith('etf');
    final selectedSymbols = ref.watch(arkSelectedSymbolsProvider);
    final dateFrom = ref.watch(arkDateFromProvider);
    final dateTo = ref.watch(arkDateToProvider);
    final direction = ref.watch(arkDirectionProvider);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF60A5FA)),
              const SizedBox(width: 6),
              Text(
                'FILTER CONTROLS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filters Row
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // ETF Symbols Selector (For ETF tabs)
              if (isEtf)
                GestureDetector(
                  onTap: _showSymbolSelectorModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withAlpha(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedSymbols.length == tradesEnabledSymbols.length
                              ? 'All ETFs'
                              : '${selectedSymbols.length} ETFs selected',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF94A3B8)),
                      ],
                    ),
                  ),
                ),

              // Stock Symbol Input (For Stock Trades)
              if (!isEtf)
                SizedBox(
                  width: 130,
                  height: 36,
                  child: TextField(
                    controller: _stockInputController,
                    style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: 'TSLA',
                      hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                      prefixIcon: const Icon(Icons.search, size: 16, color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: Colors.white.withAlpha(8),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                      ),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        ref.read(arkStockSymbolProvider.notifier).state = val.trim().toUpperCase();
                      }
                    },
                  ),
                ),

              // Date Range Picker
              GestureDetector(
                onTap: () => _pickDateRange(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF60A5FA)),
                      const SizedBox(width: 6),
                      Text(
                        '$dateFrom  ➔  $dateTo',
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
                      ),
                    ],
                  ),
                ),
              ),

              // Direction Dropdown (For Stock Trades)
              if (activeSection == 'stockTrades')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withAlpha(20)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: direction,
                      dropdownColor: const Color(0xFF1E293B),
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
                      items: const [
                        DropdownMenuItem(value: '', child: Text('All Directions')),
                        DropdownMenuItem(value: 'Buy', child: Text('Buy Only')),
                        DropdownMenuItem(value: 'Sell', child: Text('Sell Only')),
                      ],
                      onChanged: (val) {
                        ref.read(arkDirectionProvider.notifier).state = val ?? '';
                      },
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Main Dynamic Content ──
  Widget _buildActiveContent(String activeSection) {
    if (activeSection == 'etfTrades') {
      return _buildEtfTradesView();
    } else if (activeSection == 'etfHoldings') {
      return _buildEtfHoldingsView();
    } else if (activeSection == 'etfProfile') {
      return _buildEtfProfileView();
    } else if (activeSection == 'etfNews') {
      return _buildEtfNewsView();
    } else if (activeSection == 'stockTrades') {
      return _buildStockTradesView();
    }
    return const SizedBox();
  }

  // ── 1. ETF Trades View ──
  Widget _buildEtfTradesView() {
    final asyncData = ref.watch(arkEtfTradesProvider);

    return asyncData.when(
      data: (trades) {
        if (trades.isEmpty) {
          return _buildEmptyState('No ARK ETF trades found for the selected filters.');
        }

        final totalPages = (trades.length / _itemsPerPage).ceil().clamp(1, 9999);
        final startIndex = (_tradesPage - 1) * _itemsPerPage;
        final itemsToShow = trades.skip(startIndex).take(_itemsPerPage).toList();

        return Column(
          children: [
            for (final t in itemsToShow) ...[
              _buildTradeCard(t),
              const SizedBox(height: 10),
            ],
            if (totalPages > 1)
              _buildPaginationBar(
                currentPage: _tradesPage,
                totalPages: totalPages,
                totalItems: trades.length,
                onPageChange: (p) => setState(() => _tradesPage = p),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading ARK ETF Trades...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'ARK ETF Trades',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(arkEtfTradesProvider),
      ),
    );
  }

  // ── Trade Card with Analyst Gauge Expansion ──
  Widget _buildTradeCard(ArkTradeItem t) {
    final isBuy = t.direction.toLowerCase() == 'buy';
    final isExpanded = _expandedTicker == '${t.fund}_${t.ticker}_${t.date}';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? const Color(0xFF3B82F6).withAlpha(120) : Colors.white.withAlpha(15),
          width: isExpanded ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            final key = '${t.fund}_${t.ticker}_${t.date}';
            _expandedTicker = isExpanded ? null : key;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Fund Badge, Ticker + Logo, Company, Direction
              Row(
                children: [
                  // Fund badge (Clean white pill)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(16),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withAlpha(25)),
                    ),
                    child: Text(
                      t.fund,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Stock Logo + Ticker
                  StockLogo(ticker: t.ticker, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    t.ticker,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),

                  const Spacer(),

                  // Direction Badge (Matching Congress Dashboard #33B890 Buy / #EC4B5E Sell)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: isBuy ? const Color(0xFF33B890) : const Color(0xFFEC4B5E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t.direction.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Company Name
              Text(
                t.company,
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0x14FFFFFF)),
              const SizedBox(height: 10),

              // Details Row: Shares, ETF %, Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SHARES', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text(
                        t.shares != null ? NumberFormat('#,###').format(t.shares) : '—',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                  if (t.etfPercent != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ETF %', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                        const SizedBox(height: 2),
                        Text(
                          '${t.etfPercent}%',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF60A5FA)),
                        ),
                      ],
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('DATE', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text(
                        t.date,
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),

              // Expandable Analyst Targets Section
              if (isExpanded) ...[
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0x1AFFFFFF)),
                const SizedBox(height: 12),
                AnalystTargetsGauge(ticker: t.ticker),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── 2. ETF Holdings View ──
  Widget _buildEtfHoldingsView() {
    final asyncData = ref.watch(arkEtfHoldingsProvider);

    return asyncData.when(
      data: (holdings) {
        if (holdings.isEmpty) {
          return _buildEmptyState('No ARK ETF holdings found.');
        }

        final totalPages = (holdings.length / _itemsPerPage).ceil().clamp(1, 9999);
        final startIndex = (_holdingsPage - 1) * _itemsPerPage;
        final itemsToShow = holdings.skip(startIndex).take(_itemsPerPage).toList();

        return Column(
          children: [
            for (final h in itemsToShow) ...[
              _buildHoldingCard(h),
              const SizedBox(height: 10),
            ],
            if (totalPages > 1)
              _buildPaginationBar(
                currentPage: _holdingsPage,
                totalPages: totalPages,
                totalItems: holdings.length,
                onPageChange: (p) => setState(() => _holdingsPage = p),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading ARK ETF Holdings...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'ARK ETF Holdings',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(arkEtfHoldingsProvider),
      ),
    );
  }

  Widget _buildHoldingCard(ArkHoldingItem h) {
    final isExpanded = _expandedTicker == 'holding_${h.fund}_${h.ticker}';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? const Color(0xFF3B82F6).withAlpha(120) : Colors.white.withAlpha(15),
          width: isExpanded ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            final key = 'holding_${h.fund}_${h.ticker}';
            _expandedTicker = isExpanded ? null : key;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(16),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withAlpha(25)),
                    ),
                    child: Text(
                      h.fund,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (h.weightRank != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Rank #${h.weightRank}',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8)),
                      ),
                    ),
                  const Spacer(),
                  StockLogo(ticker: h.ticker, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    h.ticker,
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF60A5FA)),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                h.company,
                style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0x14FFFFFF)),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SHARES', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text(
                        h.shares != null ? NumberFormat('#,###').format(h.shares) : '—',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                  if (h.marketValue != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MARKET VALUE', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                        const SizedBox(height: 2),
                        Text(
                          '\$${NumberFormat('#,###').format(h.marketValue)}',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF34D399)),
                        ),
                      ],
                    ),
                  if (h.weight != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('WEIGHT', style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
                        const SizedBox(height: 2),
                        Text(
                          '${h.weight}%',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF60A5FA)),
                        ),
                      ],
                    ),
                ],
              ),

              if (isExpanded) ...[
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0x1AFFFFFF)),
                const SizedBox(height: 12),
                AnalystTargetsGauge(ticker: h.ticker),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── 3. ETF Profile View ──
  Widget _buildEtfProfileView() {
    final asyncData = ref.watch(arkEtfProfilesProvider);

    return asyncData.when(
      data: (profiles) {
        if (profiles.isEmpty) {
          return _buildEmptyState('No ETF profile data found.');
        }

        return Column(
          children: [
            for (final p in profiles) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 14),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF3B82F6)),
                          ),
                          child: Text(
                            p.symbol,
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF60A5FA)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            p.name,
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      p.description,
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8), height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0x14FFFFFF)),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        _profileField('Fund Type', p.fundType),
                        _profileField('Inception', p.inceptionDate),
                        _profileField('CUSIP', p.cusip),
                        _profileField('ISIN', p.isin),
                      ],
                    ),

                    if (p.website.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => launchUrl(Uri.parse(p.website), mode: LaunchMode.externalApplication),
                          icon: const Icon(Icons.open_in_new, size: 14, color: Color(0xFF60A5FA)),
                          label: Text(
                            'Official ARK Fund Website',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF60A5FA)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading ETF Profiles...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'ARK ETF Profiles',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(arkEtfProfilesProvider),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B))),
        const SizedBox(height: 2),
        Text(
          value.isNotEmpty ? value : '—',
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
        ),
      ],
    );
  }

  // ── 4. ETF News View ──
  Widget _buildEtfNewsView() {
    final asyncData = ref.watch(arkEtfNewsProvider);

    return asyncData.when(
      data: (news) {
        if (news.isEmpty) {
          return _buildEmptyState('No ARK ETF news found.');
        }

        final totalPages = (news.length / _itemsPerPage).ceil().clamp(1, 9999);
        final startIndex = (_newsPage - 1) * _itemsPerPage;
        final itemsToShow = news.skip(startIndex).take(_itemsPerPage).toList();

        return Column(
          children: [
            for (final n in itemsToShow) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.newspaper_rounded, size: 16, color: Color(0xFF60A5FA)),
                        const SizedBox(width: 8),
                        Text(
                          n.date,
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n.headline,
                      style: GoogleFonts.poppins(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    if (n.summary.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        n.summary,
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8), height: 1.4),
                      ),
                    ],
                    if (n.url.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => launchUrl(Uri.parse(n.url), mode: LaunchMode.externalApplication),
                          icon: const Icon(Icons.arrow_outward_rounded, size: 14, color: Color(0xFF60A5FA)),
                          label: Text(
                            'Read Story',
                            style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: const Color(0xFF60A5FA)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (totalPages > 1)
              _buildPaginationBar(
                currentPage: _newsPage,
                totalPages: totalPages,
                totalItems: news.length,
                onPageChange: (p) => setState(() => _newsPage = p),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading ARK ETF News...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'ARK ETF News',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(arkEtfNewsProvider),
      ),
    );
  }

  // ── 5. Stock Trades View ──
  Widget _buildStockTradesView() {
    final asyncData = ref.watch(arkStockTradesProvider);
    final targetStock = ref.watch(arkStockSymbolProvider);

    return asyncData.when(
      data: (trades) {
        if (trades.isEmpty) {
          return _buildEmptyState('No ARK trades found for \$$targetStock.');
        }

        final totalPages = (trades.length / _itemsPerPage).ceil().clamp(1, 9999);
        final startIndex = (_stockTradesPage - 1) * _itemsPerPage;
        final itemsToShow = trades.skip(startIndex).take(_itemsPerPage).toList();

        return Column(
          children: [
            for (final t in itemsToShow) ...[
              _buildTradeCard(t),
              const SizedBox(height: 10),
            ],
            if (totalPages > 1)
              _buildPaginationBar(
                currentPage: _stockTradesPage,
                totalPages: totalPages,
                totalItems: trades.length,
                onPageChange: (p) => setState(() => _stockTradesPage = p),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading ARK Stock Trades...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'ARK Stock Trades',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(arkStockTradesProvider),
      ),
    );
  }

  // ── Helpers: Empty State ──
  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 36, color: Color(0xFF64748B)),
          const SizedBox(height: 10),
          Text(
            message,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Helpers: Pagination Bar ──
  Widget _buildPaginationBar({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required ValueChanged<int> onPageChange,
  }) {
    final startIndex = (currentPage - 1) * _itemsPerPage;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(6),
                ),
                icon: const Icon(Icons.chevron_left_rounded, size: 18, color: Colors.white),
                onPressed: currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Page $currentPage of $totalPages',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFCBD5E1)),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(6),
                ),
                icon: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white),
                onPressed: currentPage < totalPages ? () => onPageChange(currentPage + 1) : null,
              ),
            ],
          ),
          Text(
            'Showing ${startIndex + 1}-${(startIndex + _itemsPerPage).clamp(1, totalItems)} of $totalItems',
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // ── Date Range Modal Picker ──
  Future<void> _pickDateRange(BuildContext context) async {
    final fromStr = ref.read(arkDateFromProvider);
    final toStr = ref.read(arkDateToProvider);

    final initialFrom = DateTime.tryParse(fromStr) ?? DateTime.now().subtract(const Duration(days: 30));
    final initialTo = DateTime.tryParse(toStr) ?? DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: initialFrom, end: initialTo),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Color(0xFF1E293B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(arkDateFromProvider.notifier).state = DateFormat('yyyy-MM-dd').format(picked.start);
      ref.read(arkDateToProvider.notifier).state = DateFormat('yyyy-MM-dd').format(picked.end);
      setState(() {
        _tradesPage = 1;
        _holdingsPage = 1;
        _newsPage = 1;
        _stockTradesPage = 1;
      });
    }
  }

  // ── Multi-select Symbol Bottom Sheet ──
  void _showSymbolSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final selected = ref.watch(arkSelectedSymbolsProvider);

            return Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select ARK ETFs',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(arkSelectedSymbolsProvider.notifier).state = List.from(allEtfSymbols);
                              setModalState(() {});
                            },
                            child: Text('All', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF60A5FA))),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(arkSelectedSymbolsProvider.notifier).state = [];
                              setModalState(() {});
                            },
                            child: Text('Clear', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Color(0x1AFFFFFF)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allEtfSymbols.length,
                      itemBuilder: (context, idx) {
                        final sym = allEtfSymbols[idx];
                        final isChecked = selected.contains(sym);

                        return CheckboxListTile(
                          title: Text(sym, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                          value: isChecked,
                          activeColor: const Color(0xFF3B82F6),
                          checkColor: Colors.white,
                          onChanged: (val) {
                            final current = List<String>.from(ref.read(arkSelectedSymbolsProvider));
                            if (isChecked) {
                              current.remove(sym);
                            } else {
                              current.add(sym);
                            }
                            ref.read(arkSelectedSymbolsProvider.notifier).state = current;
                            setModalState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Done', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
