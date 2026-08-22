import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/data/blog_data.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class BlogDetailScreen extends StatefulWidget {
  final String slug;

  const BlogDetailScreen({super.key, required this.slug});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postIndex = BlogData.posts.indexWhere((p) => p.slug == widget.slug);
    final post = postIndex != -1 ? BlogData.posts[postIndex] : null;

    if (post == null) {
      return AppScaffold(
        backgroundColor: const Color(0xFFF2EAEA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Post Not Found',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/blog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC60C30),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to All Posts'),
              ),
            ],
          ),
        ),
      );
    }

    final prevPost = postIndex > 0 ? BlogData.posts[postIndex - 1] : null;
    final nextPost = postIndex < BlogData.posts.length - 1
        ? BlogData.posts[postIndex + 1]
        : null;

    return AppScaffold(
      backgroundColor: const Color(0xFFF2EAEA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Back to Blog Button ──
                GestureDetector(
                  onTap: () => context.go('/blog'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_rounded,
                          size: 18,
                          color: Color(0xFFC60C30),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'BACK TO BLOG',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                            color: const Color(0xFFC60C30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── 2. Metadata (Date, Read Time, Author) ──
                Row(
                  children: [
                    Text(
                      _formatDate(post.publishDate).toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCBD5E1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.readTime.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCBD5E1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post.author.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFC60C30),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── 3. Article Title ──
                Text(
                  post.title,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 28),

                // ── 4. Featured Image Banner (16:9 Aspect Ratio) ──
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      post.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF0F172A),
                        child: Center(
                          child: Text(
                            'POLYTICK',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white24,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── 5. Native Rich Article Content Renderer ──
                if (post.content != null)
                  _NativeHtmlContentRenderer(htmlContent: post.content!),

                // ── 6. FAQ Section (If Applicable) ──
                if (post.faqs != null && post.faqs!.isNotEmpty) ...[
                  const SizedBox(height: 40),
                  Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...post.faqs!.map((faq) => _FaqAccordionItem(faq: faq)),
                ],

                const SizedBox(height: 56),

                // ── 7. Previous & Next Post Navigation Cards ──
                Row(
                  children: [
                    if (prevPost != null)
                      Expanded(
                        child: _buildNavCard(
                          label: 'PREVIOUS POST',
                          title: prevPost.title,
                          slug: prevPost.slug,
                          alignLeft: true,
                        ),
                      )
                    else
                      const Spacer(),
                    const SizedBox(width: 16),
                    if (nextPost != null)
                      Expanded(
                        child: _buildNavCard(
                          label: 'NEXT POST',
                          title: nextPost.title,
                          slug: nextPost.slug,
                          alignLeft: false,
                        ),
                      )
                    else
                      const Spacer(),
                  ],
                ),

                const SizedBox(height: 56),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavCard({
    required String label,
    required String title,
    required String slug,
    required bool alignLeft,
  }) {
    return GestureDetector(
      onTap: () => context.go('/blog/$slug'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: alignLeft ? TextAlign.left : TextAlign.right,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqAccordionItem extends StatefulWidget {
  final BlogFaq faq;

  const _FaqAccordionItem({required this.faq});

  @override
  State<_FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<_FaqAccordionItem> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOpen ? const Color(0xFFC60C30) : const Color(0xFFE2E8F0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _isOpen = !_isOpen),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                widget.faq.answer,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  color: const Color(0xFF475569),
                  height: 1.6,
                ),
              ),
            ),
            crossFadeState:
                _isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── Native HTML / Rich Text Article Renderer ──
class _NativeHtmlContentRenderer extends StatelessWidget {
  final String htmlContent;

  const _NativeHtmlContentRenderer({required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    final blocks = _parseHtml(htmlContent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) => _renderBlock(block)).toList(),
    );
  }

  List<_HtmlBlock> _parseHtml(String html) {
    final List<_HtmlBlock> blocks = [];

    // Match top-level blocks: h1-h6, p, ul, ol, table, blockquote
    final tagPattern = RegExp(
      r'<(h[1-6]|p|ul|ol|table|blockquote)(?:[^>]*)>(.*?)</\1>',
      caseSensitive: false,
      dotAll: true,
    );

    final matches = tagPattern.allMatches(html);
    for (final match in matches) {
      final tag = match.group(1)!.toLowerCase();
      final content = match.group(2)!.trim();

      if (content.isEmpty) continue;

      if (tag.startsWith('h')) {
        final level = int.tryParse(tag.substring(1)) ?? 2;
        blocks.add(_HtmlBlock(
          type: _BlockType.heading,
          rawText: content,
          level: level,
        ));
      } else if (tag == 'p') {
        blocks.add(_HtmlBlock(type: _BlockType.paragraph, rawText: content));
      } else if (tag == 'ul' || tag == 'ol') {
        final liPattern = RegExp(r'<li>(.*?)</li>', caseSensitive: false, dotAll: true);
        final items = liPattern.allMatches(content).map((m) => m.group(1)!.trim()).toList();
        if (items.isNotEmpty) {
          blocks.add(_HtmlBlock(type: _BlockType.list, listItems: items));
        }
      } else if (tag == 'table') {
        final tableData = _parseTable(content);
        if (tableData != null) {
          blocks.add(_HtmlBlock(type: _BlockType.table, tableData: tableData));
        }
      } else if (tag == 'blockquote') {
        blocks.add(_HtmlBlock(type: _BlockType.quote, rawText: content));
      }
    }

    if (blocks.isEmpty && html.trim().isNotEmpty) {
      blocks.add(_HtmlBlock(type: _BlockType.paragraph, rawText: html.trim()));
    }

    return blocks;
  }

  _TableData? _parseTable(String tableHtml) {
    final headers = <String>[];
    final rows = <List<String>>[];

    // Extract headers (th)
    final thPattern = RegExp(r'<th(?:[^>]*)>(.*?)</th>', caseSensitive: false, dotAll: true);
    for (final m in thPattern.allMatches(tableHtml)) {
      headers.add(_stripTags(m.group(1)!).trim());
    }

    // Extract rows (tr)
    final trPattern = RegExp(r'<tr(?:[^>]*)>(.*?)</tr>', caseSensitive: false, dotAll: true);
    for (final m in trPattern.allMatches(tableHtml)) {
      final trContent = m.group(1)!;
      final tdPattern = RegExp(r'<td(?:[^>]*)>(.*?)</td>', caseSensitive: false, dotAll: true);
      final cells = <String>[];
      for (final cellMatch in tdPattern.allMatches(trContent)) {
        cells.add(cellMatch.group(1)!.trim());
      }
      if (cells.isNotEmpty) {
        rows.add(cells);
      }
    }

    if (headers.isEmpty && rows.isEmpty) return null;
    return _TableData(headers: headers, rows: rows);
  }

  Widget _renderBlock(_HtmlBlock block) {
    switch (block.type) {
      case _BlockType.heading:
        final fontSize = block.level == 1
            ? 28.0
            : block.level == 2
                ? 22.0
                : 18.0;
        return Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 12),
          child: Text(
            _stripTags(block.rawText ?? ''),
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
        );

      case _BlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _RichHtmlText(rawText: block.rawText ?? ''),
        );

      case _BlockType.list:
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: block.listItems!.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 7, right: 12),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC60C30),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: _RichHtmlText(rawText: item),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );

      case _BlockType.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: const Border(
              left: BorderSide(color: Color(0xFFC60C30), width: 4),
            ),
          ),
          child: _RichHtmlText(rawText: block.rawText ?? ''),
        );

      case _BlockType.table:
        return _renderTableWidget(block.tableData!);
    }
  }

  Widget _renderTableWidget(_TableData table) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
          headingTextStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
          dataTextStyle: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF334155),
          ),
          columns: table.headers.isNotEmpty
              ? table.headers
                  .map((h) => DataColumn(label: Text(h.toUpperCase())))
                  .toList()
              : List.generate(
                  table.rows.firstOrNull?.length ?? 1,
                  (i) => DataColumn(label: Text('COL ${i + 1}')),
                ),
          rows: table.rows.map((row) {
            return DataRow(
              cells: row.map((cell) {
                return DataCell(_RichHtmlText(rawText: cell));
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _stripTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}

class _RichHtmlText extends StatelessWidget {
  final String rawText;

  const _RichHtmlText({required this.rawText});

  @override
  Widget build(BuildContext context) {
    final spans = _parseInlineSpans(rawText);

    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 16.5,
          color: const Color(0xFF334155),
          height: 1.7,
        ),
        children: spans,
      ),
    );
  }

  List<InlineSpan> _parseInlineSpans(String text) {
    final List<InlineSpan> spans = [];
    final pattern = RegExp(
      r'<strong>(.*?)</strong>|<b>(.*?)</b>|<em>(.*?)</em>|<a[^>]*>(.*?)</a>|([^<]+)',
      dotAll: true,
      caseSensitive: false,
    );
    final matches = pattern.allMatches(text);

    for (final match in matches) {
      if (match.group(1) != null || match.group(2) != null) {
        final boldText = match.group(1) ?? match.group(2)!;
        spans.add(TextSpan(
          text: _stripTags(boldText),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ));
      } else if (match.group(3) != null) {
        final italicText = match.group(3)!;
        spans.add(TextSpan(
          text: _stripTags(italicText),
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ));
      } else if (match.group(4) != null) {
        final linkText = match.group(4)!;
        spans.add(TextSpan(
          text: _stripTags(linkText),
          style: const TextStyle(
            color: Color(0xFFC60C30),
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
          ),
        ));
      } else if (match.group(5) != null) {
        spans.add(TextSpan(text: match.group(5)!));
      }
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: _stripTags(text)));
    }

    return spans;
  }

  String _stripTags(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}

enum _BlockType { heading, paragraph, list, quote, table }

class _TableData {
  final List<String> headers;
  final List<List<String>> rows;

  const _TableData({required this.headers, required this.rows});
}

class _HtmlBlock {
  final _BlockType type;
  final String? rawText;
  final int level;
  final List<String>? listItems;
  final _TableData? tableData;

  const _HtmlBlock({
    required this.type,
    this.rawText,
    this.level = 2,
    this.listItems,
    this.tableData,
  });
}
