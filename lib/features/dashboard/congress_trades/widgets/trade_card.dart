import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/trade_model.dart';
import 'package:polytick_app/core/utils/date_utils.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/analyst_targets_gauge.dart';
import 'package:polytick_app/features/dashboard/congress_trades/widgets/source_filing_modal.dart';
import 'package:polytick_app/shared/widgets/politician_avatar.dart';
import 'package:polytick_app/shared/widgets/stock_logo.dart';

class TradeCard extends StatefulWidget {
  final TradeModel trade;
  final bool isDark;

  const TradeCard({
    super.key,
    required this.trade,
    this.isDark = true,
  });

  @override
  State<TradeCard> createState() => _TradeCardState();
}

class _TradeCardState extends State<TradeCard> {
  bool _expanded = false;

  (Color bg, Color text) _getTradeTypeStyle(String? type) {
    if (type == null) {
      return (const Color(0xFF6366F1), Colors.white);
    }
    final lower = type.toLowerCase();
    if (lower.contains('purchase') || lower.contains('buy')) {
      return (const Color(0xFF33B890), Colors.white); // Next.js #33b890
    }
    if (lower.contains('sale') || lower.contains('sell')) {
      return (const Color(0xFFEC4B5E), Colors.white); // Next.js #ec4b5e
    }
    return (const Color(0xFF6366F1), Colors.white);
  }

  (Color fill, Color text) _getValueRangeStyle(String? sizeStr) {
    if (sizeStr == null || sizeStr.isEmpty || sizeStr == '—' || sizeStr == '-') {
      return (Colors.white.withAlpha(12), const Color(0xFF94A3B8));
    }

    final clean = sizeStr.toLowerCase().replaceAll(',', '').trim();

    if (clean.contains('250001') || clean.contains('250k') || clean.contains('250,001')) {
      return (const Color(0xFFC24100), const Color(0xFFFFF2E0)); // Next.js 250K-500K Orange
    }
    if (clean.contains('500001') || clean.contains('500k') || clean.contains('500,001')) {
      return (const Color(0xFFFF5429), const Color(0xFF2B1200)); // Next.js 500K-1M Coral
    }
    if (clean.contains('100001') || clean.contains('100k') || clean.contains('100,001')) {
      return (const Color(0xFFFF910A), const Color(0xFF2B1200)); // Next.js 100K-250K Amber
    }
    if (clean.contains('50001') || clean.contains('50k') || clean.contains('50,001')) {
      return (const Color(0xFFFFCC33), const Color(0xFF2B1200)); // Next.js 50K-100K Yellow
    }
    if (clean.contains('15001') || clean.contains('15k') || clean.contains('15,001')) {
      return (const Color(0xFFFCF288), const Color(0xFF2B1200)); // Next.js 15K-50K Light Yellow
    }
    if (clean.contains('1000001') || clean.contains('1m') || clean.contains('1,000,001')) {
      return (const Color(0xFFD60000), const Color(0xFFFFF2E0)); // Next.js 1M-5M Crimson
    }
    if (clean.contains('5000001') || clean.contains('5m')) {
      return (const Color(0xFF840B15), const Color(0xFFFFF2E0)); // Next.js 5M-25M Dark Red
    }
    if (clean.contains('25000001') || clean.contains('25m')) {
      return (const Color(0xFF570F27), const Color(0xFFFFF2E0)); // Next.js 25M-50M Maroon
    }
    if (clean.contains('50m') || clean.contains('50000000')) {
      return (const Color(0xFF3A0311), const Color(0xFFFFF2E0)); // Next.js >50M Deep Burgundy
    }

    // Default 1K-15K
    return (const Color(0xFFC7C7BE), const Color(0xFF4A4A42));
  }

  @override
  Widget build(BuildContext context) {
    final trade = widget.trade;
    final (typeBg, typeText) = _getTradeTypeStyle(trade.transactionType);
    final (valueBg, valueText) = _getValueRangeStyle(trade.amountRange);

    final hasFilingPdf = trade.chamber?.toLowerCase() != 'senate' &&
        trade.sourceUrl != null &&
        trade.sourceUrl!.isNotEmpty &&
        (trade.sourceUrl!.toLowerCase().endsWith('.pdf') || trade.sourceUrl!.contains('house.gov'));

    final chamberText = (trade.chamber != null && trade.chamber!.isNotEmpty)
        ? (trade.chamber!.toLowerCase().contains('senat') ? 'Senate' : 'House')
        : 'Congress';
    final districtText = (trade.state != null && trade.state!.isNotEmpty && trade.state != '—')
        ? ' • District: ${trade.state}'
        : '';
    final ownerText = (trade.owner != null && trade.owner!.isNotEmpty && trade.owner != '—' && trade.owner != '-')
        ? ' • Owner: ${trade.owner}'
        : (trade.party != null && trade.party!.isNotEmpty ? ' • ${trade.party}' : '');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF131722), // Matching Next.js website card background
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _expanded ? const Color(0xFF3B82F6).withAlpha(120) : Colors.white.withAlpha(15),
          width: _expanded ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header: Politician Avatar, Name, Chamber + District + Owner, Type Badge + Source Eye ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PoliticianAvatar(
                    name: trade.politicianName,
                    imageUrl: trade.photoUrl,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trade.politicianName,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$chamberText$districtText$ownerText',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF94A3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // TYPE BADGE (Next.js Exact Colors: #33b890 Purchase / #ec4b5e Sale)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: typeBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (trade.transactionType ?? 'PURCHASE').toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                        color: typeText,
                      ),
                    ),
                  ),

                  // Source PDF Eye Button (Shown ONLY for House trades with direct PDFs, never for Senate)
                  if (hasFilingPdf) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF94A3B8)),
                      visualDensity: VisualDensity.compact,
                      tooltip: 'View Source Filing',
                      onPressed: () => SourceFilingModal.show(context, trade),
                    ),
                  ],

                  const SizedBox(width: 2),

                  // Expand Indicator Arrow
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── 2. Asset Description & Security Heading ──
              Text(
                'ASSET DESCRIPTION',
                style: GoogleFonts.inter(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stock Logo Symbol
                  StockLogo(ticker: trade.ticker, size: 24),
                  const SizedBox(width: 8),

                  // Clean Neutral Ticker Pill (No Blue!)
                  if (trade.ticker != null && trade.ticker!.trim().isNotEmpty && trade.ticker != '—' && trade.ticker != '-') ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(14),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white.withAlpha(25)),
                      ),
                      child: Text(
                        '\$${trade.ticker!.replaceAll('\$', '')}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Asset Description Text
                  Expanded(
                    child: Text(
                      trade.assetDescription != null && trade.assetDescription!.isNotEmpty
                          ? trade.assetDescription!
                          : (trade.ticker ?? 'Stock Disclosure'),
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE2E8F0),
                        height: 1.35,
                      ),
                      maxLines: _expanded ? 10 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0x1AFFFFFF)),
              const SizedBox(height: 10),

              // ── 3. Value Range Pill + Price + Dates Row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // VALUE RANGE PILL (Exact Next.js VALUE_RANGE_COLORS matching)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: valueBg,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: valueBg.withAlpha(60),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      trade.amountRange ?? '—',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: valueText,
                      ),
                    ),
                  ),

                  // PRICE COLUMN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRICE',
                        style: GoogleFonts.inter(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        trade.price != null && trade.price! > 0
                            ? '\$${NumberFormat('#,##0.00').format(trade.price)}'
                            : (trade.currentMarketPrice != null && trade.currentMarketPrice! > 0
                                ? '\$${NumberFormat('#,##0.00').format(trade.currentMarketPrice)}'
                                : '—'),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: (trade.price != null && trade.price! > 0) ||
                                  (trade.currentMarketPrice != null && trade.currentMarketPrice! > 0)
                              ? Colors.white
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),

                  // Dates: Traded & Filed (Format: 7 Feb 2025 / 13 Aug 2026)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Traded: ',
                            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                          ),
                          Text(
                            AppDateUtils.formatDate(trade.transactionDate),
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Filed: ',
                            style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF64748B)),
                          ),
                          Text(
                            AppDateUtils.formatDate(trade.disclosureDate),
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF38BDF8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // ── 4. COMMENTS Column / Row (Matching Web Table Structure) ──
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withAlpha(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.comment_outlined, size: 11, color: Color(0xFF64748B)),
                        const SizedBox(width: 5),
                        Text(
                          'COMMENTS',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      (trade.comments != null &&
                              trade.comments!.trim().isNotEmpty &&
                              trade.comments != '—' &&
                              trade.comments != '-' &&
                              trade.comments!.toLowerCase() != 'null' &&
                              trade.comments!.toLowerCase() != 'none')
                          ? '"${trade.comments!.trim().replaceAll(RegExp(r'^"|"$'), '')}"'
                          : '—',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontStyle: (trade.comments != null &&
                                trade.comments!.trim().isNotEmpty &&
                                trade.comments != '—' &&
                                trade.comments != '-' &&
                                trade.comments!.toLowerCase() != 'null' &&
                                trade.comments!.toLowerCase() != 'none')
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: (trade.comments != null &&
                                trade.comments!.trim().isNotEmpty &&
                                trade.comments != '—' &&
                                trade.comments != '-' &&
                                trade.comments!.toLowerCase() != 'null' &&
                                trade.comments!.toLowerCase() != 'none')
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF64748B),
                        height: 1.3,
                      ),
                      maxLines: _expanded ? 20 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // ── Expandable Section: Live Analyst Insights Gauge & Comments ──
              if (_expanded) ...[
                const SizedBox(height: 16),

                // 1. Analyst Price Targets Interactive Gauge
                AnalystTargetsGauge(
                  ticker: trade.ticker ?? '',
                  low: trade.analystLow,
                  high: trade.analystHigh,
                  average: trade.analystTargetMean,
                  current: trade.currentMarketPrice ?? trade.price,
                ),

                // 2. Comments / Notes
                if (trade.comments != null && trade.comments!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withAlpha(12)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes_rounded, size: 16, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            trade.comments!,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 3. Source Filing Viewer Button (Only for House trades with PDF filings)
                if (hasFilingPdf) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        backgroundColor: const Color(0xFF38BDF8).withAlpha(20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => SourceFilingModal.show(context, trade),
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 15, color: Color(0xFF38BDF8)),
                      label: Text(
                        'View Source Filing PDF',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
