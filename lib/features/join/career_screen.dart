import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/services/payment_service.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _portfolioController = TextEditingController();

  bool _loading = false;
  bool _submittedSuccess = false;
  String? _errorMessage;

  static const List<_JobOpeningData> _jobs = [
    _JobOpeningData(
      title: "Lead, Data Science",
      subtitle: "Explore the complete role & responsibilities",
      icon: Icons.psychology_rounded,
      link:
          "https://docs.google.com/document/d/1r6QKnWlMse_BKfVsWOnRWwCWRWn7WC-yYeVejQluHlM/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "Head of Engineering",
      subtitle: "View full position details",
      icon: Icons.groups_rounded,
      link:
          "https://docs.google.com/document/d/18u389Q82xeU_rEkq6di5TdJrOxsZUsEfRKhul_6j5Vo/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "UI/UX Design Lead",
      subtitle: "See full design leadership role",
      icon: Icons.brush_rounded,
      link:
          "https://docs.google.com/document/d/1QVgcBpUYm0jdF5t2neAy-EIpqvp6jb2uJY_SR5cpDhg/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "Enterprise Architect",
      subtitle: "Open full architecture role",
      icon: Icons.description_rounded,
      link:
          "https://docs.google.com/document/d/1zCKQdVjAyJZVfUigJExu-v4JP2DboH6lScR1b1ahhC8/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "BI Developer",
      subtitle: "Read complete job overview",
      icon: Icons.bar_chart_rounded,
      link:
          "https://docs.google.com/document/d/1RjEKSxOSqU1QC5UVzroix1LzXfu-wd6quWxHfJ2ATQo/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "Growth Strategy Lead",
      subtitle: "Discover full growth role details",
      icon: Icons.campaign_rounded,
      link:
          "https://docs.google.com/document/d/1BIYaKlGzrwxGPNZUdvC-s4OaNx_0saefimf1lubED3M/edit?usp=sharing",
    ),
    _JobOpeningData(
      title: "Senior Mobile Dev",
      subtitle: "View full development role",
      icon: Icons.smartphone_rounded,
      link:
          "https://docs.google.com/document/d/1kGlfG2UKUsgQcJPaxiC9jf-GxmauymTBZa6BLrwR9G8/edit?usp=sharing",
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _handleApplicationSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final portfolio = _portfolioController.text.trim();

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://formsubmit.co/ajax/polytick7@gmail.com',
        data: {
          'name': name,
          'email': email,
          'portfolio': portfolio,
          '_subject': 'New Job Application from $name (PolyTICK Career)',
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (mounted) {
          setState(() {
            _submittedSuccess = true;
            _loading = false;
          });
        }
      } else {
        throw Exception('Application submit failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Error submitting application. Please try again or write to us at PolyTICK7@gmail.com.';
          _loading = false;
        });
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _portfolioController.clear();
    setState(() {
      _submittedSuccess = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // ── Top Career Page Background Graphic ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 480,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                'assets/images/join_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/join_bg.webp',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // ── Foreground Scrollable Content ──
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── 1. Hero Header ──
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        children: const [
                          TextSpan(text: 'JOIN THE '),
                          TextSpan(
                            text: 'TEAM',
                            style: TextStyle(color: Color(0xFF51A2FF)),
                          ),
                          TextSpan(
                            text: ' — Shape the Future of Market Intelligence',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'INNOVATIVE · AMBITIOUS · MARKET-FOCUSED',
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE5E7EB),
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 36),

                    // ── 2. Main Apply Card (Dual Column) ──
                    _buildMainApplyCard(),

                    const SizedBox(height: 56),

                    // ── 3. Career Opportunities Section ──
                    _buildCareerOpportunitiesSection(),

                    const SizedBox(height: 40),

                    // ── 4. Employment Acceptance Agreement Banner ──
                    _buildAgreementBanner(),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainApplyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D11),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Take the First Step — Apply Today',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Curious? Fearless? Ambitious? Tell us about you.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;

              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildApplicationForm()),
                        const SizedBox(width: 36),
                        Container(
                          width: 1,
                          height: 440,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        const SizedBox(width: 36),
                        Expanded(child: _buildBenefitsList()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildApplicationForm(),
                        const SizedBox(height: 36),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 24),
                        _buildBenefitsList(),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationForm() {
    if (_submittedSuccess) {
      return Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF064E3B),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 40,
              color: Color(0xFF34D399),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Application Submitted!',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thank you for applying. We will review your portfolio and get in touch.",
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              color: const Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _resetForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Apply for another role'),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name
          Text(
            'Full name',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Please enter your name' : null,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            decoration: _inputDecoration('Your name'),
          ),
          const SizedBox(height: 16),

          // Email
          Text(
            'Email',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || !v.contains('@')
                ? 'Valid email required'
                : null,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            decoration: _inputDecoration('you@gmail.com'),
          ),
          const SizedBox(height: 16),

          // Link to CV / Portfolio
          Text(
            'Link to CV / Portfolio',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _portfolioController,
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Please share a link to your resume or portfolio'
                : null,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            decoration: _inputDecoration('https://'),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Apply Button
          GestureDetector(
            onTap: _loading ? null : _handleApplicationSubmit,
            child: MouseRegion(
              cursor: _loading ? SystemMouseCursors.basic : SystemMouseCursors.click,
              child: _loading
                  ? const SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/apply_button.png',
                      height: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Submit Application',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 18),
          Center(
            child: Text(
              'should you have issues please write us at PolyTICK7@gmail.com',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13.5, color: const Color(0xFF6B7280)),
      filled: true,
      fillColor: const Color(0xFF18181B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFDC2626),
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildBenefitsList() {
    const benefits = [
      _BenefitItemData(
        text: 'Free access to SuperGrok/xAI subscription.',
        bgColor: Color(0xFF5A1A2A),
        textColor: Color(0xFFE5E7EB),
      ),
      _BenefitItemData(
        text: 'Professional mentorship & growth.',
        bgColor: Color(0xFF1E293B),
        textColor: Color(0xFFD1D5DB),
      ),
      _BenefitItemData(
        text: 'Remote work flexibility.',
        bgColor: Color(0xFFD1D5DB),
        textColor: Color(0xFF000000),
      ),
      _BenefitItemData(
        text: 'Possible full-time contracts & immigration opportunity.',
        bgColor: Color(0xFFDC2626),
        textColor: Color(0xFFFFFFFF),
      ),
      _BenefitItemData(
        text: 'Chance to join accelerator & Hedge Fund.',
        bgColor: Color(0xFF3B82F6),
        textColor: Color(0xFFFFFFFF),
      ),
      _BenefitItemData(
        text: 'Stock options potential.',
        bgColor: Color(0xFF5A1A2A),
        textColor: Color(0xFFE5E7EB),
      ),
      _BenefitItemData(
        text: 'Tourist flight to the US (Possibility).',
        bgColor: Color(0xFF1E293B),
        textColor: Color(0xFFD1D5DB),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: benefits.map((b) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: b.bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                b.text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: b.textColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCareerOpportunitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Career Opportunities',
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Opportunities That Inspire Growth – Find a role that challenges and rewards you.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 28),

        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 760;

            return isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: _jobs
                              .sublist(0, 4)
                              .map((j) => _buildJobCard(j))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: _jobs
                              .sublist(4)
                              .map((j) => _buildJobCard(j))
                              .toList(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: _jobs.map((j) => _buildJobCard(j)).toList(),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildJobCard(_JobOpeningData job) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => PaymentService.instance.launchExternalLink(job.link),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D11),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFDC2626),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(job.icon, size: 22, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgreementBanner() {
    return GestureDetector(
      onTap: () => PaymentService.instance.launchExternalLink(
        'https://docs.google.com/document/d/15DJJYevaXDac-bgEf3aj0JCXwfdivdTEjQ1npvVGfnc/edit?usp=sharing',
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/acceptance_agreement.png',
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildFallbackAgreementCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAgreementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.assignment_turned_in_rounded,
              size: 28,
              color: Color(0xFF60A5FA),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PolyTICK Employment Acceptance Agreement',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Review standard terms and onboarding agreement template for new team members.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_outward_rounded,
            size: 20,
            color: Color(0xFF60A5FA),
          ),
        ],
      ),
    );
  }
}

class _JobOpeningData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String link;

  const _JobOpeningData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.link,
  });
}

class _BenefitItemData {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _BenefitItemData({
    required this.text,
    required this.bgColor,
    required this.textColor,
  });
}
