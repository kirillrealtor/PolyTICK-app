import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/features/dashboard/congress_trades/congress_trades_provider.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/trade_card.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';

class CongressTradesScreen extends ConsumerStatefulWidget {
  const CongressTradesScreen({super.key});

  @override
  ConsumerState<CongressTradesScreen> createState() => _CongressTradesScreenState();
}

class _CongressTradesScreenState extends ConsumerState<CongressTradesScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  String _searchQuery = '';
  String _selectedSize = '';
  bool _underAnalyst = false;
  bool _underPolitician = false;
  bool _optionsOnly = false;
  int _currentPage = 1;
  int _currentLimit = 10;

  final List<(String, String)> _sizeRanges = const [
    ('', 'All Sizes'),
    ('1-15k', '1K–15K'),
    ('15-50k', '15K–50K'),
    ('50-100k', '50K–100K'),
    ('100-250k', '100K–250K'),
    ('250-500k', '250K–500K'),
    ('500-1000k', '500K–1M'),
    ('1m-5m', '1M–5M'),
    ('5m-25m', '5M–25M'),
    ('25m-50m', '25M–50M'),
    ('50m+', '>50M'),
  ];

  final List<int> _pageLimits = const [10, 25, 50, 100];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _syncQueryToBackend() {
    ref.read(congressTradesQueryProvider.notifier).state = CongressTradesQuery(
      page: _currentPage,
      limit: _currentLimit,
      search: _searchQuery,
      sizeRange: _selectedSize,
      undervalued: _underAnalyst,
      underPoliticianPricing: _underPolitician,
      isOption: _optionsOnly ? true : null,
      sort: 'filing_date',
      direction: 'DESC',
    );
    ref.invalidate(congressTradesProvider);
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val.trim();
      _currentPage = 1;
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      _syncQueryToBackend();
    });
  }

  void _onSizeSelected(String sizeKey) {
    setState(() {
      _selectedSize = sizeKey;
      _currentPage = 1;
    });
    _syncQueryToBackend();
  }

  void _onPageChanged(int newPage) {
    setState(() => _currentPage = newPage);
    _syncQueryToBackend();
  }

  void _onLimitChanged(int newLimit) {
    setState(() {
      _currentLimit = newLimit;
      _currentPage = 1;
    });
    _syncQueryToBackend();
  }

  @override
  Widget build(BuildContext context) {
    final asyncResult = ref.watch(congressTradesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Government Data Provenance & Non-Affiliation Header ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF3B82F6).withAlpha(60)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_outlined,
                size: 16,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF94A3B8),
                      height: 1.35,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Public Government Data: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                      TextSpan(
                        text: 'Sourced from public records under the 2012 STOCK Act (House Clerk & Senate eFD). PolyTICK does not represent any government entity.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => context.go('/data-sources'),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withAlpha(40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Sources (.gov)',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF60A5FA),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── 2. Search Bar + Size Filter + Dot Filter Chips ──
        _buildFilterSection(),

        const SizedBox(height: 12),

        // ── 3. Trade Disclosures List + Pagination ──
        asyncResult.when(
          data: (trades) {
            final total = ref.watch(congressTradesTotalProvider);
            final totalPages = (total / _currentLimit).ceil().clamp(1, 99999);

            if (trades.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(10)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF64748B)),
                    const SizedBox(height: 12),
                    Text(
                      'No trades found matching your filters.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF51A2FF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                          _selectedSize = '';
                          _underAnalyst = false;
                          _underPolitician = false;
                          _optionsOnly = false;
                          _currentPage = 1;
                        });
                        _syncQueryToBackend();
                      },
                      child: Text('Reset Filters', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Trade list items
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trades.length,
                  itemBuilder: (context, index) {
                    return TradeCard(trade: trades[index]);
                  },
                ),

                const SizedBox(height: 14),

                // ── 4. Bottom Pagination Controls Bar (Next.js Exact Match) ──
                _buildPaginationBar(total, totalPages),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            child: Center(child: FuturisticLoader(text: 'Loading Congress Disclosures...')),
          ),
          error: (err, stack) => ErrorBoundaryWidget(
            componentName: 'Congress Trades',
            errorMessage: err.toString(),
            onRetry: () {
              ref.invalidate(congressTradesProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Search Bar + Professional Search Button ──
        Row(
          children: [
            Expanded(
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 17, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Search congress trades...',
                          hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: _onSearchChanged,
                        onSubmitted: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                            _currentPage = 1;
                          });
                          _syncQueryToBackend();
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _currentPage = 1;
                          });
                          _syncQueryToBackend();
                        },
                        child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF64748B)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchQuery = _searchController.text.trim();
                  _currentPage = 1;
                });
                _syncQueryToBackend();
              },
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withAlpha(20)),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Search',
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── Size Filter Dropdown ──
        Row(
          children: [
            Text(
              'SIZE:',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSize,
                    isExpanded: true,
                    menuMaxHeight: 280,
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: const Color(0xFF1E293B),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF94A3B8)),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    items: _sizeRanges.map((r) {
                      final isSelected = r.$1 == _selectedSize;
                      return DropdownMenuItem<String>(
                        value: r.$1,
                        child: Text(
                          r.$2,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF60A5FA) : Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) _onSizeSelected(val);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // ── Filter Chips with Dot Selection Indicators ──
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildFilterChip(
              label: 'Under Analyst',
              checked: _underAnalyst,
              onChanged: (v) {
                setState(() {
                  _underAnalyst = v;
                  _currentPage = 1;
                });
                _syncQueryToBackend();
              },
            ),
            _buildFilterChip(
              label: 'Under Politician Pricing',
              checked: _underPolitician,
              onChanged: (v) {
                setState(() {
                  _underPolitician = v;
                  _currentPage = 1;
                });
                _syncQueryToBackend();
              },
            ),
            _buildFilterChip(
              label: 'Options Only',
              checked: _optionsOnly,
              onChanged: (v) {
                setState(() {
                  _optionsOnly = v;
                  _currentPage = 1;
                });
                _syncQueryToBackend();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool checked,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6.5),
        decoration: BoxDecoration(
          color: checked ? const Color(0xFF2563EB) : const Color(0xFF131722),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: checked ? const Color(0xFF3B82F6) : Colors.white.withAlpha(15),
            width: 1,
          ),
          boxShadow: checked
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checked ? Colors.white : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: checked ? FontWeight.w700 : FontWeight.w600,
                color: checked ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Pagination Controls (Matching Website Exactly) ──
  Widget _buildPaginationBar(int total, int totalPages) {
    final startItem = total > 0 ? (_currentPage - 1) * _currentLimit + 1 : 0;
    final endItem = total > 0 ? (_currentPage * _currentLimit).clamp(0, total) : 0;

    String formatCount(int num) {
      return num.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Column(
        children: [
          // Row 1: Page Size Picker + Item Count (e.g. 1–10 of 48,844)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page Size Selector
              PopupMenuButton<int>(
                onSelected: _onLimitChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                color: const Color(0xFF1E293B),
                itemBuilder: (context) {
                  return _pageLimits.map((limit) {
                    return PopupMenuItem<int>(
                      value: limit,
                      height: 36,
                      child: Text(
                        '$limit / page',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: limit == _currentLimit ? FontWeight.w700 : FontWeight.w500,
                          color: limit == _currentLimit ? const Color(0xFF60A5FA) : Colors.white,
                        ),
                      ),
                    );
                  }).toList();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0E14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withAlpha(15)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$_currentLimit / page',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ),
              ),

              // Item Range Text
              Text(
                '$startItem–$endItem of ${formatCount(total)}',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0x1AFFFFFF)),
          const SizedBox(height: 12),

          // Row 2: Prev Button + Page Number Buttons + Next Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prev Button
              IconButton(
                onPressed: _currentPage > 1 ? () => _onPageChanged(_currentPage - 1) : null,
                icon: const Icon(Icons.chevron_left_rounded),
                iconSize: 22,
                color: Colors.white,
                disabledColor: Colors.white.withAlpha(30),
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage > 1 ? Colors.white.withAlpha(10) : Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const SizedBox(width: 6),

              // Page Number Buttons
              ..._buildPageNumbers(totalPages),

              const SizedBox(width: 6),

              // Next Button
              IconButton(
                onPressed: _currentPage < totalPages ? () => _onPageChanged(_currentPage + 1) : null,
                icon: const Icon(Icons.chevron_right_rounded),
                iconSize: 22,
                color: Colors.white,
                disabledColor: Colors.white.withAlpha(30),
                style: IconButton.styleFrom(
                  backgroundColor: _currentPage < totalPages ? Colors.white.withAlpha(10) : Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    List<Widget> list = [];
    final maxPagesToShow = 5;

    int start = (_currentPage - 2).clamp(1, totalPages);
    int end = (start + maxPagesToShow - 1).clamp(1, totalPages);

    if (end - start + 1 < maxPagesToShow && start > 1) {
      start = (end - maxPagesToShow + 1).clamp(1, totalPages);
    }

    for (int i = start; i <= end; i++) {
      final isCurrent = i == _currentPage;
      list.add(
        GestureDetector(
          onTap: () => _onPageChanged(i),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isCurrent ? const Color(0xFF2563EB) : const Color(0xFF0B0E14),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCurrent ? const Color(0xFF3B82F6) : Colors.white.withAlpha(15),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$i',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                  color: isCurrent ? Colors.white : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }
}
