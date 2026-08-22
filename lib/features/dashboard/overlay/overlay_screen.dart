import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/overlay_models.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/analyst_targets_gauge.dart';
import 'package:polytick_app/features/dashboard/overlay/overlay_provider.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:polytick_app/shared/widgets/politician_avatar.dart';
import 'package:polytick_app/shared/widgets/stock_logo.dart';

class OverlayScreen extends ConsumerStatefulWidget {
  const OverlayScreen({super.key});

  @override
  ConsumerState<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends ConsumerState<OverlayScreen> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final asyncOverlays = ref.watch(overlayDataProvider);
    final timeRange = ref.watch(overlayTimeRangeProvider);
    final showMotleyFool = ref.watch(overlayShowMotleyFoolProvider);
    final sortBy = ref.watch(overlaySortByProvider);
    final sortDir = ref.watch(overlaySortDirProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Header & Controls Strip ──
        _buildHeader(timeRange, showMotleyFool),

        const SizedBox(height: 16),

        // ── 2. Content ──
        asyncOverlays.when(
          data: (overlaps) => _buildOverlayContent(overlaps, showMotleyFool, sortBy, sortDir),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: FuturisticLoader(text: 'Synthesizing ARK, Motley Fool & Congress Overlays...')),
          ),
          error: (err, _) => ErrorBoundaryWidget(
            componentName: 'Trade Overlays',
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(overlayDataProvider),
          ),
        ),
      ],
    );
  }

  // ── 1. Header & Timeframe / Motley Filter ──
  Widget _buildHeader(int? timeRange, bool showMotleyFool) {
    final timeOptions = [
      (null, 'All'),
      (14, '14d'),
      (30, '30d'),
      (45, '45d'),
      (60, '60d'),
      (90, '90d'),
      (180, '180d'),
      (365, '365d'),
      (1095, '3y'),
    ];

    final timeLabel = timeRange != null ? 'last $timeRange days' : 'All Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ARK, Motley Fool & Politicians Trade Overlays',
          style: GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
            children: [
              const TextSpan(text: 'Stocks where ARK Invest, Motley Fool, and US politicians are all active in '),
              TextSpan(text: timeLabel, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF60A5FA))),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Filter Controls Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Motley Fool Overlay Toggle Button
              GestureDetector(
                onTap: () {
                  ref.read(overlayShowMotleyFoolProvider.notifier).state = !showMotleyFool;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: showMotleyFool ? const Color(0xFF191919) : const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: showMotleyFool ? const Color(0xFF3B82F6) : const Color(0xFF334155),
                      width: showMotleyFool ? 1.5 : 1,
                    ),
                    boxShadow: showMotleyFool
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withAlpha(60),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: showMotleyFool ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Show Motley Fool Overlay',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: showMotleyFool ? const Color(0xFF60A5FA) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Timeframe Chips
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withAlpha(12)),
                ),
                child: Row(
                  children: timeOptions.map((opt) {
                    final isSelected = timeRange == opt.$1;
                    return GestureDetector(
                      onTap: () {
                        if (timeRange != opt.$1) {
                          ref.read(overlayTimeRangeProvider.notifier).state = opt.$1;
                          setState(() {
                            _expandedIndex = null;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          opt.$2,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 2. Full Overlay Content ──
  Widget _buildOverlayContent(
    List<OverlayItem> items,
    bool showMotleyFool,
    String sortBy,
    String sortDir,
  ) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF131722),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(12)),
        ),
        child: const Center(
          child: Text(
            'No trade overlaps found in this timeframe.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    final aligned = items.where((o) => o.isAligned).length;
    final divergent = items.where((o) => !o.isAligned).length;
    final uniqueTickers = items.length;
    final allPolNames = items.expand((o) => o.polDetails.map((d) => d.name)).toSet();

    OverlayItem? topTicker;
    int maxPols = 0;
    for (final item in items) {
      if (item.uniquePols > maxPols) {
        maxPols = item.uniquePols;
        topTicker = item;
      }
    }

    // Sort items
    final sortedItems = List<OverlayItem>.from(items);
    sortedItems.sort((a, b) {
      int cmp = 0;
      if (sortBy == 'mostRecentDate') {
        cmp = a.mostRecentDate.compareTo(b.mostRecentDate);
      } else if (sortBy == 'shares') {
        cmp = a.arkNet.abs().compareTo(b.arkNet.abs());
      } else if (sortBy == 'fools') {
        final fA = int.tryParse(a.motleyData?.heldBy?.toString() ?? '0') ?? 0;
        final fB = int.tryParse(b.motleyData?.heldBy?.toString() ?? '0') ?? 0;
        cmp = fA.compareTo(fB);
      }
      return sortDir == 'desc' ? -cmp : cmp;
    });

    final tableWidth = showMotleyFool ? 1460.0 : 1300.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── A. 5 KPI Summary Cards (Compact with Uniform White Numbers) ──
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.85,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _kpiCard('ALIGNED', '$aligned', 'ARK & politicians trading in the same direction.'),
            _kpiCard('DIVERGENT', '$divergent', 'ARK & politicians disagree on direction.'),
            _kpiCard('UNIQUE TICKERS', '$uniqueTickers', 'Distinct stocks with overlapping activity.'),
            _kpiCard('POLITICIANS INVOLVED', '${allPolNames.length}', 'Unique lawmakers trading alongside ARK.'),
            _kpiCard('TOP TICKER', topTicker?.ticker ?? '—', '${topTicker?.uniquePols ?? 0} politicians involved.'),
          ],
        ),

        const SizedBox(height: 20),

        // ── B. Master Horizontally Scrollable Overlays Table ──
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.white.withAlpha(4),
                    child: Row(
                      children: [
                        _sortHeader('Ticker', 'mostRecentDate', sortBy, sortDir, 160),
                        const SizedBox(width: 12),
                        const SizedBox(
                          width: 85,
                          child: Text('Direction', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        const SizedBox(width: 12),
                        _sortHeader('ARK Net Shares', 'shares', sortBy, sortDir, 120, null, TextAlign.right),
                        const SizedBox(width: 28), // Clear breathing spacer between Net Shares and Trades
                        const SizedBox(
                          width: 230,
                          child: Text('ARK Trades', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        const SizedBox(width: 20),
                        if (showMotleyFool) ...[
                          _sortHeader('Motley Fool', 'fools', sortBy, sortDir, 140, null, TextAlign.center),
                          const SizedBox(width: 16),
                        ],
                        const SizedBox(
                          width: 65,
                          child: Text('Pol Buys', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF34D399))),
                        ),
                        const SizedBox(
                          width: 65,
                          child: Text('Pol Sells', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFF87171))),
                        ),
                        const SizedBox(
                          width: 75,
                          child: Text('Unique Pols', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFA855F7))),
                        ),
                        const SizedBox(width: 16),
                        const SizedBox(
                          width: 230,
                          child: Text('Politician Trades', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        const SizedBox(width: 16),
                        const SizedBox(
                          width: 120,
                          child: Text('Signal', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0x1AFFFFFF)),

                  // Table Rows
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0x0FFFFFFF)),
                    itemBuilder: (context, idx) {
                      final item = sortedItems[idx];
                      final isExpanded = _expandedIndex == idx;
                      final isBuy = item.direction == 'Buy';
                      final bgTint = item.isAligned
                          ? (isBuy ? const Color(0xFF10B981).withAlpha(15) : const Color(0xFFEF4444).withAlpha(15))
                          : const Color(0xFFF59E0B).withAlpha(12);

                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : idx;
                              });
                            },
                            child: Container(
                              color: bgTint,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Ticker + Company Name
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            StockLogo(ticker: item.ticker, size: 22),
                                            const SizedBox(width: 8),
                                            Text(
                                              item.ticker,
                                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        if (item.companyName.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            item.companyName,
                                            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // 2. Direction Badge (Matching Congress Dashboard: #33B890 Buy / #EC4B5E Sell)
                                  SizedBox(
                                    width: 85,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                        decoration: BoxDecoration(
                                          color: isBuy ? const Color(0xFF33B890) : const Color(0xFFEC4B5E),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.direction.toUpperCase(),
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // 3. ARK Net Shares
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      '${item.arkNet > 0 ? '+' : ''}${NumberFormat('#,###').format(item.arkNet)}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 28), // Clear breathing spacer between Net Shares and Trades

                                  // 4. ARK Trades List (First 4 items)
                                  SizedBox(
                                    width: 230,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: item.arkDetails.take(4).map((d) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 2),
                                          child: Text(
                                            '${d.etf}: ${d.direction} ${NumberFormat('#,###').format(d.shares)} shares  ${d.date}',
                                            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF60A5FA)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // 5. Motley Fool Overlay Card
                                  if (showMotleyFool) ...[
                                    SizedBox(
                                      width: 140,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 28,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(12),
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.white.withAlpha(15)),
                                            ),
                                            child: Image.asset(
                                              'assets/images/motley-fool-logo.png',
                                              height: 22,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) => const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('🃏 ', style: TextStyle(fontSize: 12)),
                                                  Text('Motley Fool', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          if (item.motleyData != null) ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: item.motleyData!.dir == 'Long' ? const Color(0xFF10B981).withAlpha(25) : const Color(0xFFEF4444).withAlpha(25),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: item.motleyData!.dir == 'Long' ? const Color(0xFF10B981) : const Color(0xFFEF4444), width: 0.8),
                                              ),
                                              child: Text(
                                                item.motleyData!.dir.toUpperCase(),
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                  color: item.motleyData!.dir == 'Long' ? const Color(0xFF34D399) : const Color(0xFFF87171),
                                                ),
                                              ),
                                            ),
                                            if (item.motleyData!.heldBy != null) ...[
                                              const SizedBox(height: 3),
                                              Text(
                                                'HELD BY FOOLS: ${item.motleyData!.heldBy}',
                                                style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.white),
                                              ),
                                            ],
                                          ] else ...[
                                            Text(
                                              'NO MATCH',
                                              style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF64748B)),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],

                                  // 6. Pol Buys
                                  SizedBox(
                                    width: 65,
                                    child: Text(
                                      '${item.polBuys}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF34D399)),
                                    ),
                                  ),

                                  // 7. Pol Sells
                                  SizedBox(
                                    width: 65,
                                    child: Text(
                                      '${item.polSells}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFF87171)),
                                    ),
                                  ),

                                  // 8. Unique Pols
                                  SizedBox(
                                    width: 75,
                                    child: Text(
                                      '${item.uniquePols}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFA855F7)),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 9. Politician Trades List
                                  SizedBox(
                                    width: 230,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: item.polDetails.take(4).map((d) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            children: [
                                              PoliticianAvatar(name: d.name, imageUrl: d.image, size: 16),
                                              const SizedBox(width: 4),
                                              Flexible(
                                                child: Text(
                                                  d.name,
                                                  style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFFE2E8F0)),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(d.size, style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF94A3B8))),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 10. Signal Column
                                  SizedBox(
                                    width: 120,
                                    child: Column(
                                      children: [
                                        if (item.isAligned)
                                          Text(
                                            '🚀 Strong ${item.direction}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w900,
                                              color: isBuy ? const Color(0xFF33B890) : const Color(0xFFEC4B5E),
                                            ),
                                          )
                                        else
                                          Column(
                                            children: [
                                              Text(
                                                '⚠️ Divergent',
                                                style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w900, color: const Color(0xFFFBBF24)),
                                              ),
                                              Text(
                                                'ARK: ${item.direction}',
                                                style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFFF59E0B)),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Expandable Live Analyst Targets Gauge
                          if (isExpanded) ...[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
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
        ),
      ],
    );
  }

  Widget _kpiCard(String title, String value, String tooltip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.info_outline_rounded, size: 11, color: Color(0xFF64748B)),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _sortHeader(
    String label,
    String sortKey,
    String activeSortKey,
    String activeSortDir,
    double width, [
    Color? color,
    TextAlign align = TextAlign.left,
  ]) {
    final isSorted = activeSortKey == sortKey;
    final isDesc = activeSortDir == 'desc';

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (activeSortKey == sortKey) {
            ref.read(overlaySortDirProvider.notifier).state = isDesc ? 'asc' : 'desc';
          } else {
            ref.read(overlaySortByProvider.notifier).state = sortKey;
            ref.read(overlaySortDirProvider.notifier).state = 'desc';
          }
        },
        child: Row(
          mainAxisAlignment: align == TextAlign.right
              ? MainAxisAlignment.end
              : (align == TextAlign.center ? MainAxisAlignment.center : MainAxisAlignment.start),
          mainAxisSize: MainAxisSize.min,
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
            Icon(
              isSorted ? (isDesc ? Icons.arrow_drop_down : Icons.arrow_drop_up) : Icons.arrow_drop_down,
              size: 14,
              color: isSorted ? const Color(0xFF60A5FA) : const Color(0xFF475569),
            ),
          ],
        ),
      ),
    );
  }
}
