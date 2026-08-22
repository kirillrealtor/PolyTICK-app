import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/services/payment_service.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static const List<_LayerData> _layers = [
    _LayerData(
      title: "Politician Stock Trades (Free)",
      icon: Icons.account_balance_rounded,
      description:
          "Unlock the ultimate insider advantage. We meticulously track the real-time stock trades and portfolio shifts of U.S. politicians. Because insiders consistently move markets before the headlines catch up, this foundational layer illuminates exactly where the most connected decision-makers are deploying their capital.",
    ),
    _LayerData(
      title: "Committee & Subcommittee (Free)",
      icon: Icons.alt_route_rounded,
      description:
          "Delve deeper into the corridors of power. By mapping politicians to their specific legislative assignments, we reveal the hidden nexus between upcoming regulatory shifts and market movements. You already know the profound value of this insight: anticipating industry-altering legislation long before it becomes law.",
    ),
    _LayerData(
      title: "ARK Invest (Free)",
      icon: Icons.trending_up_rounded,
      description:
          "Follow the profound conviction of Cathie Wood and visionary capital. We continuously monitor the aggressive, future-focused portfolio strategies of ARK Invest. By tracking these high-conviction bets on disruptive innovation, you gain front-row access to the institutional movements shaping the technologies of tomorrow.",
    ),
    _LayerData(
      title: "Analyst Price Targets (Free)",
      icon: Icons.work_rounded,
      description:
          "Ground your strategy in rigorous institutional foresight. We aggregate and distill the latest price targets and ratings from top-tier Wall Street analysts. This critical layer provides a synthesized, consensus-driven benchmark, allowing you to gauge professional market expectations and validate your investment thesis with confidence.",
    ),
    _LayerData(
      title: "Overlay (Free)",
      icon: Icons.layers_rounded,
      description:
          "Experience the synergy of elite intelligence. This powerful convergence activates when the localized insider knowledge of politicians aligns perfectly with the institutional conviction of ARK Invest. When these two disparate worlds of high-level influence intersect on a single asset, it creates an undeniably strong, high-probability market signal.",
    ),
    _LayerData(
      title: "Motley Fool Holdings (Free)",
      icon: Icons.menu_book_rounded,
      description:
          "Incorporate decades of retail advisory mastery. We integrate the curated, time-tested stock picks and deep holding strategies from one of the most respected names in investment research. This layer seamlessly blends long-term, research-driven wisdom with our dynamic data, providing a deeply trusted perspective on enduring market value.",
    ),
    _LayerData(
      title: "AI/ML (Coming Soon)",
      icon: Icons.psychology_rounded,
      description:
          "Elevate your analysis from human limitation to computational supremacy. We feed our massive, multi-dimensional datasets into advanced AI algorithms that tirelessly synthesize and detect hidden market correlations. This layer transforms overwhelming noise into crystal-clear, actionable trading intelligence tailored precisely for your success.",
    ),
    _LayerData(
      title: "Sentiment Analysis of all Congressional Hearings (Coming Soon)",
      icon: Icons.record_voice_over_rounded,
      description:
          "Anticipate the legislative winds of change. Utilizing advanced natural language processing, we decode the tone, urgency, and underlying intent embedded within congressional hearings. This layer strips away political rhetoric to reveal the true regulatory pressures that will inevitably dictate future market directions.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFF000000),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── 1. Header ──
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    children: const [
                      TextSpan(text: 'OUR '),
                      TextSpan(
                        text: 'MISSION',
                        style: TextStyle(color: Color(0xFF51A2FF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Text(
                    'We provide the tools to track the people who write the rules. Our 8-layer intelligence system brings transparency to Capitol Hill.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 36),

                // ── 2. Featured YouTube Video Section ──
                const _AnimatedYouTubeVideoSection(),

                const SizedBox(height: 48),

                // ── 3. 8 Layers Unified Container with Center-Expanding Red Circle Animations ──
                _buildEightLayersUnifiedSection(),

                const SizedBox(height: 48),

                // ── 4. Leadership / CEO & CTO ──
                _buildLeadershipFooter(),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEightLayersUnifiedSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(44),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          final isMedium = constraints.maxWidth > 600;

          if (isWide) {
            // Desktop 4x2 layout with dividers
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < 4; i++) ...[
                        Expanded(
                          child: _LayerCardWidget(layer: _layers[i]),
                        ),
                        if (i < 3)
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Color(0xFFE5E7EB),
                          ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 4; i < 8; i++) ...[
                        Expanded(
                          child: _LayerCardWidget(layer: _layers[i]),
                        ),
                        if (i < 7)
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Color(0xFFE5E7EB),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          } else if (isMedium) {
            // Tablet 2x4 layout
            return Column(
              children: [
                for (int r = 0; r < 4; r++) ...[
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _LayerCardWidget(layer: _layers[r * 2]),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFFE5E7EB),
                        ),
                        Expanded(
                          child: _LayerCardWidget(layer: _layers[r * 2 + 1]),
                        ),
                      ],
                    ),
                  ),
                  if (r < 3)
                    const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                ],
              ],
            );
          } else {
            // Mobile 1-column layout
            return Column(
              children: [
                for (int i = 0; i < _layers.length; i++) ...[
                  _LayerCardWidget(layer: _layers[i]),
                  if (i < _layers.length - 1)
                    const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                ],
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLeadershipFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CEO: ',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF51A2FF),
              ),
            ),
            GestureDetector(
              onTap: () => PaymentService.instance.launchExternalLink(
                'https://www.linkedin.com/company/polytick',
              ),
              child: Row(
                children: [
                  Text(
                    'Kirill Gorbounov',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF51A2FF),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: Color(0xFF51A2FF),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          '|',
          style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF6B7280)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CTO: ',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFEF4444),
              ),
            ),
            Text(
              'Noor ul Hassan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Clean YouTube Video Section ──
class _AnimatedYouTubeVideoSection extends StatefulWidget {
  const _AnimatedYouTubeVideoSection();

  @override
  State<_AnimatedYouTubeVideoSection> createState() =>
      _AnimatedYouTubeVideoSectionState();
}

class _AnimatedYouTubeVideoSectionState
    extends State<_AnimatedYouTubeVideoSection>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openVideo() {
    PaymentService.instance.launchExternalLink(
      'https://www.youtube.com/watch?v=LMhp4diibiI',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _openVideo,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1000),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: _isHovered
                  ? const Color(0xFF51A2FF)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF51A2FF).withValues(
                  alpha: _isHovered ? 0.45 : 0.25,
                ),
                blurRadius: _isHovered ? 50 : 35,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // YouTube High-Res Thumbnail
                CachedNetworkImage(
                  imageUrl:
                      'https://img.youtube.com/vi/LMhp4diibiI/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => CachedNetworkImage(
                    imageUrl:
                        'https://img.youtube.com/vi/LMhp4diibiI/hqdefault.jpg',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFF18181B),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 64,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),
                ),

                // Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                ),

                // Hover Blue Tint
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isHovered ? 1.0 : 0.0,
                  child: Container(
                    color: const Color(0xFF51A2FF).withValues(alpha: 0.1),
                  ),
                ),

                // Center Pulsing YouTube Play Button
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = _isHovered ? 1.15 : _pulseAnimation.value;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 80,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0000),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF0000).withValues(
                                  alpha: 0.6,
                                ),
                                blurRadius: 28,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── 1:1 Parity Layer Card with Center-Expanding Red Circle Animation ──
class _LayerCardWidget extends StatefulWidget {
  final _LayerData layer;

  const _LayerCardWidget({required this.layer});

  @override
  State<_LayerCardWidget> createState() => _LayerCardWidgetState();
}

class _LayerCardWidgetState extends State<_LayerCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _isHovered = !_isHovered),
        child: ClipRect(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // ── Background Circle that expands from the icon center to 25x ──
                Positioned(
                  top: 24,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedScale(
                      scale: _isHovered ? 25.0 : 1.0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      alignment: Alignment.center,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9002A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Foreground Card Content ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon Container (The Center Trigger)
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Center(
                          child: Icon(
                            widget.layer.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        widget.layer.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: _isHovered
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        widget.layer.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: _isHovered
                              ? Colors.white.withValues(alpha: 0.92)
                              : const Color(0xFF374151),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LayerData {
  final String title;
  final IconData icon;
  final String description;

  const _LayerData({
    required this.title,
    required this.icon,
    required this.description,
  });
}
