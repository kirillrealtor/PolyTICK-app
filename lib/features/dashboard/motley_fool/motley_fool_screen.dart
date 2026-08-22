import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/models/motley_fool_item.dart';
import 'package:polytick_app/features/dashboard/motley_fool/motley_fool_provider.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:polytick_app/shared/widgets/stock_logo.dart';

class MotleyFoolScreen extends ConsumerStatefulWidget {
  const MotleyFoolScreen({super.key});

  @override
  ConsumerState<MotleyFoolScreen> createState() => _MotleyFoolScreenState();
}

class _MotleyFoolScreenState extends ConsumerState<MotleyFoolScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Independent pagination pages for each section
  int _pageT100 = 1;
  int _pageT10To29 = 1;
  int _pageTUnder10 = 1;

  static const int _itemsPerPage = 20;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeType = ref.watch(motleyFoolTypeProvider);
    final asyncData = ref.watch(motleyFoolDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Top Controls: Long/Short Toggle Tabs & Search Bar ──
        _buildHeaderControls(activeType),

        const SizedBox(height: 20),

        // ── 2. Content Sections ──
        asyncData.when(
          data: (allData) {
            // Local search filtering
            final query = _searchQuery.toLowerCase().trim();
            final filtered = allData.where((item) {
              if (query.isEmpty) return true;
              return item.companyName.toLowerCase().contains(query) ||
                  item.ticker.toLowerCase().contains(query);
            }).toList();

            // Categorize into 3 sections (exact Next.js behavior)
            final t100 = <MotleyFoolItem>[];
            final t10To29 = <MotleyFoolItem>[];
            final tUnder10 = <MotleyFoolItem>[];

            for (final item in filtered) {
              final cat = item.heldByFools ?? '';
              if (item.rank != null) {
                t100.push(item);
              } else if (cat.contains('10-29') ||
                  cat.contains('10~29') ||
                  cat.contains('10 - 29') ||
                  cat.contains('More Than 10')) {
                t10To29.push(item);
              } else {
                tUnder10.push(item);
              }
            }

            final sections = [
              _SectionData(
                id: 't100',
                title: activeType == 'short' ? 'Top 100 Short Positions' : 'Top 100 Long Positions',
                items: t100,
                page: _pageT100,
                isTop100: true,
                onPageChange: (p) => setState(() => _pageT100 = p),
              ),
              _SectionData(
                id: 't10to29',
                title: 'Positions Held by 10~29 Fools',
                items: t10To29,
                page: _pageT10To29,
                isTop100: false,
                onPageChange: (p) => setState(() => _pageT10To29 = p),
              ),
              _SectionData(
                id: 'tUnder10',
                title: 'Positions held by 10 or fewer Fools',
                items: tUnder10,
                page: _pageTUnder10,
                isTop100: false,
                onPageChange: (p) => setState(() => _pageTUnder10 = p),
              ),
            ];

            if (filtered.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF64748B)),
                    const SizedBox(height: 12),
                    Text(
                      'No positions found matching "$_searchQuery"',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                for (final section in sections)
                  if (section.items.isNotEmpty || _searchQuery.isNotEmpty) ...[
                    _buildSectionView(section),
                    const SizedBox(height: 24),
                  ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: FuturisticLoader(text: 'Loading Motley Fool Holdings...'),
            ),
          ),
          error: (err, stack) => ErrorBoundaryWidget(
            componentName: 'Motley Fool Holdings',
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(motleyFoolDataProvider),
          ),
        ),
      ],
    );
  }

  // ── Top Bar: Long/Short Selector & Search Bar ──
  Widget _buildHeaderControls(String activeType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Long / Short Switcher Tabs
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Long Positions Tab
              GestureDetector(
                onTap: () {
                  if (activeType != 'long') {
                    ref.read(motleyFoolTypeProvider.notifier).state = 'long';
                    setState(() {
                      _pageT100 = 1;
                      _pageT10To29 = 1;
                      _pageTUnder10 = 1;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: activeType == 'long' ? const Color(0xFF2563EB) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: activeType == 'long'
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withAlpha(100),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 18,
                        color: activeType == 'long' ? Colors.white : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Long Positions',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: activeType == 'long' ? Colors.white : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Short Positions Tab
              GestureDetector(
                onTap: () {
                  if (activeType != 'short') {
                    ref.read(motleyFoolTypeProvider.notifier).state = 'short';
                    setState(() {
                      _pageT100 = 1;
                      _pageT10To29 = 1;
                      _pageTUnder10 = 1;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: activeType == 'short' ? const Color(0xFFDC2626) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: activeType == 'short'
                        ? [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withAlpha(100),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_down_rounded,
                        size: 18,
                        color: activeType == 'short' ? Colors.white : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Short Positions',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: activeType == 'short' ? Colors.white : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Search Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search company or ticker...',
              hintStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
                _pageT100 = 1;
                _pageT10To29 = 1;
                _pageTUnder10 = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  // ── Section View ──
  Widget _buildSectionView(_SectionData section) {
    final startIndex = (section.page - 1) * _itemsPerPage;
    final itemsToShow = section.items.skip(startIndex).take(_itemsPerPage).toList();
    final totalPages = (section.items.length / _itemsPerPage).ceil().clamp(1, 9999);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header (With Expanded Title & Pinned Total Badge - Zero Overflow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF3B82F6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(10)),
                  ),
                  child: Text(
                    '${section.items.length} TOTAL',
                    style: GoogleFonts.inter(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0x1AFFFFFF)),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white.withAlpha(4),
            child: Row(
              children: [
                if (section.isTop100) ...[
                  SizedBox(
                    width: 45,
                    child: Text(
                      'RANK',
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Text(
                    'COMPANY',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(
                  width: 95,
                  child: Text(
                    'TICKER',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                if (section.isTop100) ...[
                  SizedBox(
                    width: 75,
                    child: Text(
                      'HELD BY',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0x1AFFFFFF)),

          // Items List
          if (itemsToShow.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No results found in this category.',
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                ),
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
                final cleanTicker = item.ticker.contains(':')
                    ? item.ticker.split(':').last.trim()
                    : item.ticker.trim();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Rank Badge
                      if (section.isTop100) ...[
                        SizedBox(
                          width: 45,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(8),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white.withAlpha(12)),
                              ),
                              child: Center(
                                child: Text(
                                  item.rank != null ? '${item.rank}' : '-',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],

                      // Company Name
                      Expanded(
                        child: Text(
                          item.companyName,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Ticker + Logo (Clean Ticker)
                      SizedBox(
                        width: 95,
                        child: Row(
                          children: [
                            StockLogo(ticker: cleanTicker, size: 22),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                cleanTicker.isNotEmpty ? cleanTicker : '—',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF60A5FA),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Held by Fools
                      if (section.isTop100) ...[
                        SizedBox(
                          width: 75,
                          child: Text(
                            item.heldByFools ?? '-',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFF1F5F9),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

          // Pagination Controls Bar (if more than 1 page)
          if (totalPages > 1) ...[
            const Divider(height: 1, color: Color(0x1AFFFFFF)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prev / Page / Next Buttons
                  Row(
                    children: [
                      // Prev Button
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                        ),
                        icon: const Icon(Icons.chevron_left_rounded, size: 18, color: Colors.white),
                        onPressed: section.page > 1
                            ? () => section.onPageChange(section.page - 1)
                            : null,
                      ),
                      const SizedBox(width: 8),

                      // Page Indicator
                      Text(
                        'Page ${section.page} of $totalPages',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Next Button
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(8),
                        ),
                        icon: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.white),
                        onPressed: section.page < totalPages
                            ? () => section.onPageChange(section.page + 1)
                            : null,
                      ),
                    ],
                  ),

                  // Range Counter Text
                  Text(
                    'Showing ${startIndex + 1}-${(startIndex + _itemsPerPage).clamp(1, section.items.length)} of ${section.items.length}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionData {
  final String id;
  final String title;
  final List<MotleyFoolItem> items;
  final int page;
  final bool isTop100;
  final ValueChanged<int> onPageChange;

  const _SectionData({
    required this.id,
    required this.title,
    required this.items,
    required this.page,
    required this.isTop100,
    required this.onPageChange,
  });
}

extension _ListPushExtension<T> on List<T> {
  void push(T item) => add(item);
}
