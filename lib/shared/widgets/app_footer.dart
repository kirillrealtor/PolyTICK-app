import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/config/api_config.dart';

class AppFooter extends StatefulWidget {
  const AppFooter({super.key});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _statusMessage;

  Future<void> _launchExternalUrl(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  Future<void> _subscribe() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter an email address.';
      });
      return;
    }

    final bool emailValid = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);

    if (!emailValid) {
      setState(() {
        _statusMessage = 'Please enter a valid email address.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _statusMessage = null;
    });

    try {
      final res = await ApiClient.instance.post(
        ApiConfig.newsletterSubscribe,
        data: {'email': email},
      );

      if (mounted) {
        setState(() {
          if (res.data is Map && res.data['status'] == 'already_subscribed') {
            _statusMessage = '✓ Already subscribed!';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are already subscribed!'),
                backgroundColor: Color(0xFF1E293B),
              ),
            );
          } else {
            _statusMessage = '✓ Thanks for subscribing!';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Welcome! Please check your email.'),
                backgroundColor: Color(0xFF10B981),
              ),
            );
            _emailController.clear();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Failed to subscribe. Please try again.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to subscribe. Please try again.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E1E1E), // Figma Footer Background #1E1E1E
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Top Logo & Tagline Header Row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // PolyTICK Logo
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/PolyTICK-NewLogo-transparent.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.insights,
                      color: Color(0xFF51A2FF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Poly',
                          style: GoogleFonts.poppins(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF51A2FF),
                          ),
                        ),
                        TextSpan(
                          text: 'TICK',
                          style: GoogleFonts.poppins(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC60C30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Right Tagline
              Flexible(
                child: Text(
                  '© 2026 PolyTICK. Powered by 8 layers of insight and analysis.',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 8.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withAlpha(200),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── 2. Stay Ahead Newsletter Section ──
          Text(
            'Stay Ahead',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get weekly market intelligence delivered to your inbox.',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(210),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Capsule Email Input + Submit Button
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 18.0, right: 6.0),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(45),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withAlpha(220),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    onSubmitted: (_) => _loading ? null : _subscribe(),
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withAlpha(180),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _loading ? null : _subscribe,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'SUBMIT',
                              style: GoogleFonts.poppins(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 0.6,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_statusMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _statusMessage!,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: _statusMessage!.startsWith('✓')
                    ? const Color(0xFF00E676)
                    : const Color(0xFFFF5252),
              ),
            ),
          ],
          const SizedBox(height: 44),

          // ── 3. Follow Us & Social Circles ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FOLLOW US',
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
              Row(
                children: [
                  _buildSocialCircle(
                    icon: Icons.mail_outline,
                    onTap: () =>
                        _launchExternalUrl('mailto:polytick7@gmail.com'),
                  ),
                  const SizedBox(width: 12),
                  _buildSocialCircle(
                    customChild: Text(
                      'in',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD9D9D9),
                      ),
                    ),
                    onTap: () => _launchExternalUrl(
                      'https://www.linkedin.com/company/polytick',
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSocialCircle(
                    customChild: Text(
                      '𝕏',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD9D9D9),
                      ),
                    ),
                    onTap: () =>
                        _launchExternalUrl('https://x.com/PolytickUS'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          // ── 4. 3 Navigation Columns (Company, Resources, Legal) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── COMPANY Column ──
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMPANY',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE2E8F0),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _footerLink('About Us', '/about'),
                    const SizedBox(height: 10),
                    _footerLink('Blog', '/blog'),
                    const SizedBox(height: 10),
                    _footerLink('Careers', '/join'),
                    const SizedBox(height: 10),
                    _footerLink('Pricing', '/pricing'),
                    const SizedBox(height: 10),
                    _footerLink('Contact', '/contact'),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // ── RESOURCES Column ──
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESOURCES',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE2E8F0),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _footerLink('FAQ', '/faq'),
                    const SizedBox(height: 14),
                    Text(
                      'For API access/queries:',
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () =>
                          _launchExternalUrl('mailto:polytick7@gmail.com'),
                      child: Text(
                        'PolyTICK7@gmail.com',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF51A2FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // ── LEGAL Column ──
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEGAL',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFE2E8F0),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _footerLink('Terms & Conditions', '/terms'),
                    const SizedBox(height: 10),
                    _footerLink('Privacy Policy', '/privacy'),
                    const SizedBox(height: 10),
                    _footerLink('Disclaimer', '/disclaimer'),
                    const SizedBox(height: 10),
                    _footerLink('Data Sources', '/data-sources'),
                    const SizedBox(height: 10),
                    _footerLink('Cookie Policy', '/cookies'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 44),

          // ── 5. Location & Email Inquiries Section ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: LOCATION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOCATION',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Fairfax, VA\nUnited States',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFE1E1E1),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Right: EMAIL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMAIL',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          _launchExternalUrl('mailto:polytick7@gmail.com'),
                      child: Text(
                        'PolyTICK7@gmail.com',
                        style: GoogleFonts.inter(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF51A2FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // ── 5.5 GOVERNMENT DATA SOURCES & NON-AFFILIATION DISCLAIMER ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF131722),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withAlpha(25),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withAlpha(40),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        size: 18,
                        color: Color(0xFF60A5FA),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'GOVERNMENT DATA SOURCES & DISCLAIMER',
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Non-Affiliation Notice: PolyTICK is an independent data analysis platform developed by ZenAIautomation.com. PolyTICK is NOT affiliated with, endorsed by, authorized by, sponsored by, or in any way officially connected to the United States Government, the U.S. Congress, the U.S. Senate, the U.S. House of Representatives, or any federal, state, or municipal government agency. PolyTICK does not represent any government entity.',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: const Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'All congressional trade disclosures are derived from publicly available federal records mandated under the Stop Trading on Congressional Knowledge Act (STOCK Act of 2012). Official government sources include:',
                  style: GoogleFonts.inter(
                    fontSize: 11.0,
                    color: const Color(0xFF94A3B8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildGovSourceChip(
                      label: 'House Disclosures (clerk.house.gov)',
                      url: 'https://disclosures-clerk.house.gov',
                    ),
                    _buildGovSourceChip(
                      label: 'Senate Disclosures (efdsearch.senate.gov)',
                      url: 'https://efdsearch.senate.gov',
                    ),
                    _buildGovSourceChip(
                      label: 'Congress.gov (Legislative Data)',
                      url: 'https://www.congress.gov',
                    ),
                    _buildGovSourceChip(
                      label: 'SEC EDGAR (sec.gov)',
                      url: 'https://www.sec.gov/edgar',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // ── 6. Bottom Copyright & All Rights Reserved ──
          Container(
            padding: const EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withAlpha(25),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 PolyTICK.',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(180),
                  ),
                ),
                Text(
                  'All rights reserved.',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGovSourceChip({
    required String label,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchExternalUrl(url),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF3B82F6).withAlpha(80),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.open_in_new_rounded,
                size: 12,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialCircle({
    IconData? icon,
    Widget? customChild,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(
              color: Colors.white.withAlpha(40),
              width: 1.0,
            ),
          ),
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    size: 18,
                    color: const Color(0xFFD9D9D9),
                  )
                : customChild,
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String label, String route) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ),
    );
  }
}
