import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';
import 'package:polytick_app/shared/widgets/politician_avatar.dart';

class WINScreen extends StatefulWidget {
  const WINScreen({super.key});

  @override
  State<WINScreen> createState() => _WINScreenState();
}

class _WINScreenState extends State<WINScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  int _tradesPerPage = 6;
  int? _selectedDays = 7;
  String _searchTerm = '';
  Timer? _debounceTimer;

  bool _loading = true;
  bool _isFetching = false;
  String? _error;

  List<Map<String, dynamic>> _trades = [];
  int _totalCount = 0;

  static const List<_TimeframeOption> _timeframes = [
    _TimeframeOption(label: 'ALL', days: null),
    _TimeframeOption(label: '7D', days: 7),
    _TimeframeOption(label: '14D', days: 14),
    _TimeframeOption(label: '30D', days: 30),
    _TimeframeOption(label: '45D', days: 45),
    _TimeframeOption(label: '60D', days: 60),
    _TimeframeOption(label: '90D', days: 90),
    _TimeframeOption(label: '180D', days: 180),
    _TimeframeOption(label: '1Y', days: 365),
  ];

  @override
  void initState() {
    super.initState();
    _fetchWins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() {
          _searchTerm = value.trim();
          _currentPage = 1;
        });
        _fetchWins();
      }
    });
  }

  Future<void> _fetchWins() async {
    setState(() {
      _isFetching = true;
      _error = null;
    });

    final skip = (_currentPage - 1) * _tradesPerPage;
    final queryParams = <String, dynamic>{
      'wins_only': 'true',
      'sort': 'gain_percent',
      'direction': 'DESC',
      'limit': _tradesPerPage,
      'skip': skip,
    };

    if (_selectedDays != null) {
      queryParams['days'] = _selectedDays;
    }
    if (_searchTerm.isNotEmpty) {
      queryParams['search'] = _searchTerm;
    }

    try {
      final response = await ApiClient.instance.get(
        ApiConfig.congressTrades,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>?;
      final rawList = data?['data'] as List<dynamic>? ?? [];
      final total = data?['total'] as int? ?? 0;

      if (mounted) {
        setState(() {
          _trades = rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _totalCount = total;
          _loading = false;
          _isFetching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load profitable trades';
          _loading = false;
          _isFetching = false;
        });
      }
    }
  }

  String _getTimeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      final days = diff.inDays;
      if (days == 0) return 'Today';
      if (days == 1) return 'Yesterday';
      if (days < 30) return '${days}d ago';
      if (days < 365) return '${(days / 30).floor()}m ago';
      return '${(days / 365).toStringAsFixed(1)}y ago';
    } catch (_) {
      return '';
    }
  }

  int get _totalPages => (_totalCount / _tradesPerPage).ceil().clamp(1, 9999);

  void _handlePageChange(int page) {
    if (page >= 1 && page <= _totalPages && !_isFetching) {
      setState(() => _currentPage = page);
      _fetchWins();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  List<dynamic> _getPageNumbers() {
    final pages = <dynamic>[];
    if (_totalPages <= 5) {
      for (int i = 1; i <= _totalPages; i++) {
        pages.add(i);
      }
    } else {
      if (_currentPage <= 3) {
        pages.addAll([1, 2, 3, '...', _totalPages]);
      } else if (_currentPage >= _totalPages - 2) {
        pages.addAll([1, '...', _totalPages - 2, _totalPages - 1, _totalPages]);
      } else {
        pages.addAll([1, '...', _currentPage, '...', _totalPages]);
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFFF2EAEA),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                // ── 1. Top Trophy Badge ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        size: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'HALL OF GAINS',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── 2. Title & Subtitle ──
                Text(
                  'MOST PROFITABLE TRADES',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF020617),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Track the highest stock returns and outlier gains on Capitol Hill. Updated in real-time.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // ── 3. Search & Timeframe Toolbar ──
                _buildSearchAndFilters(),

                const SizedBox(height: 28),

                if (_loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.black,
                      ),
                    ),
                  )
                else if (_error != null)
                  _buildErrorState()
                else if (_trades.isEmpty)
                  _buildEmptyState()
                else ...[
                  // ── 4. Top Alpha Spotlight Card (Page 1 only) ──
                  if (_currentPage == 1 && _trades.isNotEmpty) ...[
                    _buildTopAlphaSpotlightCard(_trades.first),
                    const SizedBox(height: 32),
                  ],

                  // ── 5. Outperformance Grid (Remaining Trades) ──
                  _buildOutperformanceSection(),

                  const SizedBox(height: 36),

                  // ── 6. Pagination Bar ──
                  if (_totalPages > 1) _buildPaginationBar(),
                ],

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Search Bar with Brutalist Border
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2.5, 2.5),
                blurRadius: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, size: 20, color: Colors.black),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search Politician or Ticker...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  child: const Icon(Icons.close_rounded, size: 18, color: Colors.black54),
                ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Timeframe Selector Segmented Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(2.5, 2.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _timeframes.map((tf) {
                final isSelected = _selectedDays == tf.days;
                return GestureDetector(
                  onTap: () {
                    if (_selectedDays != tf.days) {
                      setState(() {
                        _selectedDays = tf.days;
                        _currentPage = 1;
                      });
                      _fetchWins();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFDE047) : Colors.white,
                      border: Border(
                        right: tf == _timeframes.last
                            ? BorderSide.none
                            : const BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Text(
                      tf.label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
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

  Widget _buildTopAlphaSpotlightCard(Map<String, dynamic> trade) {
    final name = trade['politician_name'] as String? ?? 'Politician';
    final imageUrl = trade['profile_image_url'] as String?;
    final rawTicker = trade['traded_issuer_ticker'] as String? ?? 'N/A';
    final ticker = rawTicker.split(':').first;
    final issuerName = trade['traded_issuer_name'] as String? ?? '';
    final tradedDate = trade['traded'] as String? ?? '';
    final timeAgo = _getTimeAgo(tradedDate);

    final buyPrice = (trade['price'] as num?)?.toDouble();
    final currentPrice = (trade['current_market_price'] as num?)?.toDouble();
    final gainPercent = (trade['gain_percent'] as num?)?.toDouble() ?? 0.0;
    final multiplier = (buyPrice != null && buyPrice > 0 && currentPrice != null)
        ? (currentPrice / buyPrice).toStringAsFixed(1)
        : '1.0';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar + Top Alpha Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: PoliticianAvatar(
                  name: name,
                  imageUrl: imageUrl,
                  size: 96,
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(1.5, 1.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    'TOP ALPHA',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Politician Name
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          // Ticker & Date Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                  ],
                ),
                child: Text(
                  ticker,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              if (issuerName.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: Text(
                    issuerName,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              if (tradedDate.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                    ],
                  ),
                  child: Text(
                    'Traded: $tradedDate ${timeAgo.isNotEmpty ? '($timeAgo)' : ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Trade Math Flow Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Entry Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ENTRY PRICE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        buyPrice != null
                            ? '\$${buyPrice.toStringAsFixed(2)}'
                            : '—',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Flow & Return Multiplier
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.black, width: 1.5),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                          ],
                        ),
                        child: Text(
                          '+${gainPercent.toStringAsFixed(1)}% (${multiplier}x Return)',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF065F46),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(child: Container(height: 1.5, color: Colors.black)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.black),
                          ),
                          Expanded(child: Container(height: 1.5, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Current Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'CURRENT PRICE',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentPrice != null
                            ? '\$${currentPrice.toStringAsFixed(2)}'
                            : '—',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutperformanceSection() {
    final subTrades = _currentPage == 1 ? _trades.skip(1).toList() : _trades;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: Color(0xFFCA8A04),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Outperformance',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            if (_isFetching)
              Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Refreshing...',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Grid of Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subTrades.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                mainAxisExtent: 310,
              ),
              itemBuilder: (context, index) {
                return _buildWinnerCard(subTrades[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildWinnerCard(Map<String, dynamic> trade) {
    final name = trade['politician_name'] as String? ?? 'Politician';
    final imageUrl = trade['profile_image_url'] as String?;
    final family = trade['politician_family'] as String? ?? 'U.S. Congress';
    final rawTicker = trade['traded_issuer_ticker'] as String? ?? 'N/A';
    final ticker = rawTicker.split(':').first;
    final issuerName = trade['traded_issuer_name'] as String? ?? '';
    final tradedDate = trade['traded'] as String? ?? '';
    final timeAgo = _getTimeAgo(tradedDate);

    final buyPrice = (trade['price'] as num?)?.toDouble();
    final currentPrice = (trade['current_market_price'] as num?)?.toDouble();
    final gainPercent = (trade['gain_percent'] as num?)?.toDouble() ?? 0.0;
    final multiplier = (buyPrice != null && buyPrice > 0 && currentPrice != null)
        ? (currentPrice / buyPrice).toStringAsFixed(1)
        : '1.0';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Avatar + Politician Name
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                      ],
                    ),
                    child: PoliticianAvatar(
                      name: name,
                      imageUrl: imageUrl,
                      size: 48,
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE047),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.trending_up_rounded,
                        size: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      family.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Ticker + Issuer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Text(
                      ticker,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      issuerName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                ),
                child: Text(
                  'EQUITY',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),

          // Mini Math Flow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1.5),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Buy
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BUY',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      buyPrice != null ? '\$${buyPrice.toStringAsFixed(2)}' : '—',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                // Return Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF059669), width: 1),
                  ),
                  child: Text(
                    '+${gainPercent.toStringAsFixed(0)}% (${multiplier}x)',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF047857),
                    ),
                  ),
                ),

                // Current
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'CURRENT',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    Text(
                      currentPrice != null
                          ? '\$${currentPrice.toStringAsFixed(2)}'
                          : '—',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Date & Time Ago Footer
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 11, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      'Purchased: $tradedDate',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                if (timeAgo.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.15)),
                    ),
                    child: Text(
                      timeAgo,
                      style: GoogleFonts.poppins(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationBar() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFCBD5E1), width: 1.5)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Show per page
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SHOW ',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    DropdownButton<int>(
                      value: _tradesPerPage,
                      isDense: true,
                      underline: const SizedBox(),
                      items: [6, 12, 24, 48, 96].map((count) {
                        return DropdownMenuItem<int>(
                          value: count,
                          child: Text(
                            count.toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newCount) {
                        if (newCount != null && newCount != _tradesPerPage) {
                          setState(() {
                            _tradesPerPage = newCount;
                            _currentPage = 1;
                          });
                          _fetchWins();
                        }
                      },
                    ),
                    Text(
                      ' PER PAGE',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Total Count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                  ],
                ),
                child: Text(
                  'Total Wins: $_totalCount',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Numbered page buttons
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              // Prev
              _buildPageButton(
                icon: Icons.chevron_left_rounded,
                enabled: _currentPage > 1,
                onTap: () => _handlePageChange(_currentPage - 1),
              ),

              // Pages
              ..._getPageNumbers().map((p) {
                if (p is int) {
                  final isSelected = p == _currentPage;
                  return GestureDetector(
                    onTap: () => _handlePageChange(p),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFDE047) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1.8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          p.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 30,
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      '...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  );
                }
              }),

              // Next
              _buildPageButton(
                icon: Icons.chevron_right_rounded,
                enabled: _currentPage < _totalPages,
                onTap: () => _handlePageChange(_currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? Colors.black : Colors.black38,
            width: 1.8,
          ),
          boxShadow: enabled
              ? const [BoxShadow(color: Colors.black, offset: Offset(1.5, 1.5))]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.black : Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 540),
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(5, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.black),
          const SizedBox(height: 12),
          Text(
            _selectedDays != null
                ? 'No profitable Congressional trades found in the last $_selectedDays days${_searchTerm.isNotEmpty ? ' matching "$_searchTerm"' : ''}.'
                : 'No profitable Congressional trades found${_searchTerm.isNotEmpty ? ' matching "$_searchTerm"' : ''}.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            _error ?? 'An error occurred',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFDC2626),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchWins,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _TimeframeOption {
  final String label;
  final int? days;

  const _TimeframeOption({
    required this.label,
    required this.days,
  });
}
