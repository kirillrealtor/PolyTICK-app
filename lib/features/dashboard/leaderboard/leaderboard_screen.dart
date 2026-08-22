import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/leaderboard_model.dart';
import 'package:polytick_app/features/dashboard/congress_trades/congress_trades_provider.dart';
import 'package:polytick_app/features/dashboard/leaderboard/leaderboard_provider.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:polytick_app/shared/widgets/politician_avatar.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  int _lbPage = 1;
  int _lbPerPage = 25;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(leaderboardDataProvider);
    final selectedPeriod = ref.watch(leaderboardPeriodProvider);
    final sortKey = ref.watch(leaderboardSortKeyProvider);
    final sortDir = ref.watch(leaderboardSortDirProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Header Title & Timeframe Selector ──
        _buildHeader(selectedPeriod),

        const SizedBox(height: 16),

        // ── 2. Content ──
        asyncData.when(
          data: (list) => _buildLeaderboardTable(list, selectedPeriod, sortKey, sortDir),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: FuturisticLoader(text: 'Ranking Congressional Traders...')),
          ),
          error: (err, _) => ErrorBoundaryWidget(
            componentName: 'Politician Leaderboard',
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(leaderboardDataProvider),
          ),
        ),
      ],
    );
  }

  // ── 1. Header & Timeframe Horizontal Selector ──
  Widget _buildHeader(String selectedPeriod) {
    final periods = [
      ('14', 'Last 14 Days'),
      ('30', 'Last 30 Days'),
      ('45', 'Last 45 Days'),
      ('60', 'Last 60 Days'),
      ('90', 'Last 90 Days'),
      ('180', 'Last 180 Days'),
      ('365', 'Last 365 Days'),
      ('1095', 'Last 1095 Days'),
      ('all', 'All Time'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Congressional Trader Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Top performing members of Congress ranked by volume and trade activity',
          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 14),

        // Timeframe Selector Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(12)),
            ),
            child: Row(
              children: periods.map((p) {
                final isSelected = selectedPeriod == p.$1;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () {
                      if (selectedPeriod != p.$1) {
                        ref.read(leaderboardPeriodProvider.notifier).state = p.$1;
                        setState(() {
                          _lbPage = 1;
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
                        p.$2,
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
        ),
      ],
    );
  }

  // ── 2. Leaderboard Table Container ──
  Widget _buildLeaderboardTable(
    List<LeaderboardItem> items,
    String selectedPeriod,
    String sortKey,
    String sortDir,
  ) {
    final query = _searchQuery.toLowerCase().trim();

    // 1. Filter by search
    final filtered = items.where((item) {
      if (query.isEmpty) return true;
      return item.politician.toLowerCase().contains(query);
    }).toList();

    // 2. Sort by active column
    filtered.sort((a, b) {
      final aStats = a.getPeriodStats(selectedPeriod);
      final bStats = b.getPeriodStats(selectedPeriod);

      num aVal = 0;
      num bVal = 0;

      switch (sortKey) {
        case 'num_buys':
          aVal = aStats.numBuys;
          bVal = bStats.numBuys;
          break;
        case 'num_sells':
          aVal = aStats.numSells;
          bVal = bStats.numSells;
          break;
        case 'total_trades':
          aVal = aStats.totalTrades;
          bVal = bStats.totalTrades;
          break;
        case 'vol_bought':
          aVal = aStats.volBought;
          bVal = bStats.volBought;
          break;
        case 'vol_sold':
          aVal = aStats.volSold;
          bVal = bStats.volSold;
          break;
        case 'median_buy':
          aVal = aStats.medianBuy;
          bVal = bStats.medianBuy;
          break;
        case 'median_sell':
          aVal = aStats.medianSell;
          bVal = bStats.medianSell;
          break;
        default:
          aVal = aStats.totalTrades;
          bVal = bStats.totalTrades;
      }

      return sortDir == 'desc' ? bVal.compareTo(aVal) : aVal.compareTo(bVal);
    });

    // 3. Paginate
    final totalPages = (filtered.length / _lbPerPage).ceil().clamp(1, 9999);
    final startIndex = (_lbPage - 1) * _lbPerPage;
    final itemsToShow = filtered.skip(startIndex).take(_lbPerPage).toList();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search politician (e.g. Pelosi, Tuberville)...',
                hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                            _lbPage = 1;
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
                  _searchQuery = val;
                  _lbPage = 1;
                });
              },
            ),
          ),

          const Divider(height: 1, color: Color(0x1AFFFFFF)),

          // ── Horizontally Scrollable 9-Column Table (Exact Desktop Screenshot Parity) ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 980,
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
                          width: 40,
                          child: Text('#', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        const SizedBox(
                          width: 170,
                          child: Text('Politician', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8))),
                        ),
                        _sortHeader('# Buys', 'num_buys', sortKey, sortDir, 75, const Color(0xFF34D399)),
                        _sortHeader('# Sells', 'num_sells', sortKey, sortDir, 75, const Color(0xFFF87171)),
                        _sortHeader('Total Trades', 'total_trades', sortKey, sortDir, 95),
                        _sortHeader('Vol Bought', 'vol_bought', sortKey, sortDir, 130),
                        _sortHeader('Vol Sold', 'vol_sold', sortKey, sortDir, 130),
                        _sortHeader('Median Buy', 'median_buy', sortKey, sortDir, 115),
                        _sortHeader('Median Sell', 'median_sell', sortKey, sortDir, 110),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0x1AFFFFFF)),

                  // Rows
                  if (itemsToShow.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Center(
                        child: Text('No politicians found.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
                        final stats = item.getPeriodStats(selectedPeriod);
                        final rank = startIndex + idx + 1;

                        return InkWell(
                          onTap: () {
                            // Filter Congress Trades screen to this politician
                            ref.read(congressTradesQueryProvider.notifier).state =
                                CongressTradesQuery(search: item.politician);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Filtering trades for ${item.politician}...'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                // Rank #
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '$rank',
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF94A3B8)),
                                  ),
                                ),

                                // Politician Avatar + Name
                                SizedBox(
                                  width: 170,
                                  child: Row(
                                    children: [
                                      PoliticianAvatar(name: item.politician, imageUrl: item.profileImageUrl, size: 24),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          item.politician,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // # Buys (Green)
                                SizedBox(
                                  width: 75,
                                  child: Text(
                                    '${stats.numBuys}',
                                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF34D399)),
                                  ),
                                ),

                                // # Sells (Red)
                                SizedBox(
                                  width: 75,
                                  child: Text(
                                    '${stats.numSells}',
                                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFFF87171)),
                                  ),
                                ),

                                // Total Trades
                                SizedBox(
                                  width: 95,
                                  child: Text(
                                    '${stats.totalTrades}',
                                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),

                                // Vol Bought (White Mono)
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    _formatDecimalNumber(stats.volBought),
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),

                                // Vol Sold (White Mono)
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    _formatDecimalNumber(stats.volSold),
                                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),

                                // Median Buy (Grey Mono)
                                SizedBox(
                                  width: 115,
                                  child: Text(
                                    _formatDecimalNumber(stats.medianBuy),
                                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFCBD5E1)),
                                  ),
                                ),

                                // Median Sell (Grey Mono)
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    _formatDecimalNumber(stats.medianSell),
                                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFCBD5E1)),
                                  ),
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
                          value: _lbPerPage,
                          dropdownColor: const Color(0xFF1E293B),
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          icon: const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF94A3B8)),
                          items: const [
                            DropdownMenuItem(value: 10, child: Text('10')),
                            DropdownMenuItem(value: 25, child: Text('25')),
                            DropdownMenuItem(value: 50, child: Text('50')),
                            DropdownMenuItem(value: 100, child: Text('100')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _lbPerPage = val;
                                _lbPage = 1;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
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
                      onPressed: _lbPage > 1 ? () => setState(() => _lbPage--) : null,
                    ),
                    Text('$_lbPage / $totalPages', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      icon: const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.white),
                      onPressed: _lbPage < totalPages ? () => setState(() => _lbPage++) : null,
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

  Widget _sortHeader(
    String label,
    String sortField,
    String activeSortKey,
    String activeSortDir,
    double width, [
    Color? color,
  ]) {
    final isSorted = activeSortKey == sortField;
    final isDesc = activeSortDir == 'desc';

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (activeSortKey == sortField) {
            ref.read(leaderboardSortDirProvider.notifier).state = isDesc ? 'asc' : 'desc';
          } else {
            ref.read(leaderboardSortKeyProvider.notifier).state = sortField;
            ref.read(leaderboardSortDirProvider.notifier).state = 'desc';
          }
          setState(() {
            _lbPage = 1;
          });
        },
        child: Row(
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

  String _formatDecimalNumber(num? val) {
    if (val == null || val == 0) return '0';
    if (val % 1 == 0) {
      return NumberFormat('#,###').format(val);
    }
    return NumberFormat('#,###.0').format(val);
  }
}
