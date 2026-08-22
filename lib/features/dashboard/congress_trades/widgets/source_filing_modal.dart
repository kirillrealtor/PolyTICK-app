import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polytick_app/config/api_config.dart';
import 'package:polytick_app/core/models/trade_model.dart';
import 'package:polytick_app/core/utils/date_utils.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SourceFilingModal extends StatefulWidget {
  final TradeModel trade;

  const SourceFilingModal({
    super.key,
    required this.trade,
  });

  static void show(BuildContext context, TradeModel trade) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(220),
      builder: (ctx) => SourceFilingModal(trade: trade),
    );
  }

  @override
  State<SourceFilingModal> createState() => _SourceFilingModalState();
}

class _SourceFilingModalState extends State<SourceFilingModal> {
  late PdfViewerController _pdfViewerController;
  int _pageCount = 0;
  int _currentPage = 1;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  String _getPdfUrl(String rawUrl) {
    if (rawUrl.isEmpty) return '';
    // Route via backend pdf-proxy to bypass government CORS/blocking headers (exact Next.js behavior)
    final encoded = Uri.encodeComponent(rawUrl);
    return '${ApiConfig.baseUrl}/pdf-proxy?url=$encoded';
  }

  @override
  Widget build(BuildContext context) {
    final trade = widget.trade;
    final pdfUrl = _getPdfUrl(trade.sourceUrl ?? '');

    return Dialog(
      backgroundColor: const Color(0xFF0C0C0C),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withAlpha(30), width: 1),
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.85,
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            // ── 1. Top Header: SOURCE FILING VIEWER + Page Counter + Close ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF131722),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(bottom: BorderSide(color: Colors.white.withAlpha(15))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 16,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SOURCE FILING VIEWER',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Page Indicator & Action Icons
                  Row(
                    children: [
                      if (_pageCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(10),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$_currentPage / $_pageCount',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),

                      // Close button
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20, color: Colors.white70),
                        visualDensity: VisualDensity.compact,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 2. Middle Content: Embedded PDF Viewer ──
            Expanded(
              child: Container(
                color: const Color(0xFF1E293B),
                child: pdfUrl.isEmpty
                    ? Center(
                        child: Text(
                          'No official source PDF attached to this disclosure.',
                          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                        ),
                      )
                    : Stack(
                        children: [
                          if (_errorMessage == null)
                            SfPdfViewer.network(
                              pdfUrl,
                              controller: _pdfViewerController,
                              canShowScrollHead: true,
                              canShowScrollStatus: true,
                              enableDoubleTapZooming: true,
                              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                                setState(() {
                                  _isLoading = false;
                                  _pageCount = details.document.pages.count;
                                });
                              },
                              onPageChanged: (PdfPageChangedDetails details) {
                                setState(() {
                                  _currentPage = details.newPageNumber;
                                });
                              },
                              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                                setState(() {
                                  _isLoading = false;
                                  _errorMessage = details.description;
                                });
                              },
                            ),

                          // Loading State
                          if (_isLoading && _errorMessage == null)
                            const Center(
                              child: FuturisticLoader(text: 'Loading Filing PDF...'),
                            ),

                          // Error State with fallback
                          if (_errorMessage != null)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      size: 40,
                                      color: Color(0xFFEF4444),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Unable to render inline preview',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'The congressional clerk server requires external browser access.',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                          _errorMessage = null;
                                        });
                                      },
                                      icon: const Icon(Icons.refresh_rounded, size: 18),
                                      label: const Text('Retry Loading PDF'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ),

            // ── 3. Bottom Bar: Filer Summary & Official Source Button ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0C0C0C),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Colors.white.withAlpha(15))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${trade.politicianName} (${trade.chamber ?? 'House'})',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Public Record: ${AppDateUtils.formatDate(trade.disclosureDate)} • ${trade.chamber?.toLowerCase() == 'senate' ? 'efdsearch.senate.gov' : 'disclosures-clerk.house.gov'}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trade.sourceUrl != null && trade.sourceUrl!.isNotEmpty)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6).withAlpha(30),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        try {
                          final uri = Uri.parse(trade.sourceUrl!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        } catch (_) {}
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 14, color: Color(0xFF60A5FA)),
                      label: Text(
                        'Open Source (.gov)',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
