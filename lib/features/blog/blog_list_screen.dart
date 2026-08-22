import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/data/blog_data.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  String _selectedCategory = 'All';
  int _currentPage = 1;
  static const int _postsPerPage = 9;

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _selectedCategory == 'All'
        ? BlogData.posts
        : BlogData.posts.where((p) => p.category == _selectedCategory).toList();

    final totalPages = (filteredPosts.length / _postsPerPage).ceil();
    final startIndex = (_currentPage - 1) * _postsPerPage;
    final displayedPosts = filteredPosts
        .skip(startIndex)
        .take(_postsPerPage)
        .toList();

    return AppScaffold(
      backgroundColor: const Color(0xFFF2EAEA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Header ──
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Text(
                    'Deep dives into congressional corruption: track where market makers are moving, how institutions are investing their money, and which stocks hedge funds are buying. Stop trading the old way and follow where the big money is going.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── 2. Category Filter Pills ──
                _buildCategoryFilters(),

                const SizedBox(height: 36),

                // ── 3. Blog Grid ──
                if (displayedPosts.isNotEmpty)
                  _buildBlogGrid(displayedPosts)
                else
                  _buildEmptyState(),

                const SizedBox(height: 48),

                // ── 4. Pagination ──
                if (totalPages > 1) _buildPagination(totalPages),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: BlogData.categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                    _currentPage = 1;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    category.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                      color: isSelected
                          ? const Color(0xFFC60C30)
                          : const Color(0xFF64748B),
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

  Widget _buildBlogGrid(List<BlogPost> posts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 960
            ? 3
            : constraints.maxWidth > 640
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            mainAxisExtent: 490,
          ),
          itemBuilder: (context, index) {
            return _BlogCardWidget(post: posts[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Text(
            'No posts found in this category.',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _selectedCategory = 'All'),
            child: Text(
              'BACK TO ALL POSTS',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFC60C30),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentPage > 1)
          ElevatedButton(
            onPressed: () => setState(() => _currentPage--),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Previous'),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Page $_currentPage of $totalPages',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        if (_currentPage < totalPages)
          ElevatedButton(
            onPressed: () => setState(() => _currentPage++),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Next'),
          ),
      ],
    );
  }
}

class _BlogCardWidget extends StatefulWidget {
  final BlogPost post;

  const _BlogCardWidget({required this.post});

  @override
  State<_BlogCardWidget> createState() => _BlogCardWidgetState();
}

class _BlogCardWidgetState extends State<_BlogCardWidget> {
  bool _isHovered = false;

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.go('/blog/${widget.post.slug}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFFC60C30).withValues(alpha: 0.4)
                  : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? Colors.black.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Featured Image Banner (16:9 Aspect Ratio)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: const Color(0xFFF8FAFC),
                  child: Image.asset(
                    widget.post.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF0F172A),
                      child: Center(
                        child: Text(
                          'POLYTICK',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white24,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Card Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date & Read Time
                      Row(
                        children: [
                          Text(
                            _formatDate(widget.post.publishDate).toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
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
                            widget.post.readTime.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF64748B),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Title
                      Text(
                        widget.post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _isHovered
                              ? const Color(0xFFC60C30)
                              : const Color(0xFF0F172A),
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Excerpt
                      Expanded(
                        child: Text(
                          widget.post.excerpt,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF475569),
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Read Article CTA Link
                      Row(
                        children: [
                          Text(
                            'READ ARTICLE',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: _isHovered
                                  ? const Color(0xFFC60C30)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: _isHovered
                                ? const Color(0xFFC60C30)
                                : const Color(0xFF0F172A),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
