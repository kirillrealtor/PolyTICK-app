import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/models/referral_model.dart';
import 'package:polytick_app/features/dashboard/referrals/referrals_provider.dart';
import 'package:polytick_app/shared/widgets/error_boundary.dart';
import 'package:polytick_app/shared/widgets/futuristic_loader.dart';

class ReferralsScreen extends ConsumerStatefulWidget {
  const ReferralsScreen({super.key});

  @override
  ConsumerState<ReferralsScreen> createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends ConsumerState<ReferralsScreen> {
  bool _copied = false;

  void _copyToClipboard(String link) {
    Clipboard.setData(ClipboardData(text: link));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
            const SizedBox(width: 8),
            Text(
              'Referral link copied to clipboard!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(referralDashboardProvider);

    return asyncData.when(
      data: (data) => _buildContent(data),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: FuturisticLoader(text: 'Loading Referral Dashboard...')),
      ),
      error: (err, _) => ErrorBoundaryWidget(
        componentName: 'Referral Dashboard',
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(referralDashboardProvider),
      ),
    );
  }

  Widget _buildContent(ReferralDashboardData data) {
    final refCode = data.referralCode ?? 'POLYTICK';
    final referralLink = 'https://www.polytick.us/ref/$refCode/';
    final referralsList = data.referrals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── 1. Referral 3D Gift Image ──
        Center(
          child: Image.asset(
            'assets/images/ReferralprogramGift.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 10),

        // ── 2. Hero Title & Rich Description ──
        Text(
          'Invite Friends. Get Rewarded.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 13, height: 1.5, color: const Color(0xFF94A3B8)),
              children: const [
                TextSpan(text: 'Share '),
                TextSpan(
                  text: 'PolyTICK',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                TextSpan(
                  text:
                      ' with your network using your personal invite link below. They get ',
                ),
                TextSpan(
                  text: '10% off',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                TextSpan(
                  text:
                      ' their subscription, and you instantly earn ',
                ),
                TextSpan(
                  text: '10% of their payment',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                TextSpan(
                  text: ' as account credit. Stack your credits and use ',
                ),
                TextSpan(
                  text: 'PolyTICK',
                  style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
                TextSpan(text: ' for free!'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── 3. Metrics Grid (3 Cards) ──
        Row(
          children: [
            Expanded(
              child: _metricCard(
                'AVAILABLE CREDIT',
                '\$${data.accountCredit.toStringAsFixed(2)}',
                'Auto-applied to next invoice',
                Icons.toll_rounded,
                const Color(0xFF60A5FA),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricCard(
                'TOTAL CREDITS EARNED',
                '\$${data.totalCreditEarned.toStringAsFixed(2)}',
                'Cumulative earnings to date',
                Icons.attach_money_rounded,
                const Color(0xFF34D399),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricCard(
                'TOTAL REFERRALS',
                '${referralsList.length}',
                'Total referred members',
                Icons.people_alt_rounded,
                const Color(0xFFA855F7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // ── 4. Your Personal Invite Link Card ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF60A5FA)),
                  const SizedBox(width: 8),
                  Text(
                    'Your Personal Invite Link',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Use this link to invite other people in your network. As soon as they subscribe, your earnings will automatically track in the table below!',
                style: GoogleFonts.inter(fontSize: 12, height: 1.4, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 16),

              // Link & Copy Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(60),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withAlpha(15)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          referralLink,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _copyToClipboard(referralLink),
                      icon: Icon(
                        _copied ? Icons.check_rounded : Icons.copy_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                      label: Text(
                        _copied ? 'Copied!' : 'Copy Link',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // ── 5. Referrals List Card ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.group_rounded, size: 18, color: Color(0xFFA855F7)),
                      const SizedBox(width: 8),
                      Text(
                        'Referrals List',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA855F7).withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFA855F7).withAlpha(80), width: 0.8),
                    ),
                    child: Text(
                      '${referralsList.length} Referrals',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFC084FC),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (referralsList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(40),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withAlpha(8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(8),
                        ),
                        child: const Icon(Icons.person_add_alt_1_rounded, size: 24, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "You haven't referred anyone yet",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your network is your net worth! Grab your link above and start building your passive credits today.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 650,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.white.withAlpha(6)),
                      columnSpacing: 16,
                      horizontalMargin: 12,
                      headingTextStyle: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                      columns: const [
                        DataColumn(label: Text('REFEREE EMAIL')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('JOINED DATE')),
                        DataColumn(label: Text('CONVERTED DATE')),
                        DataColumn(label: Text('CREDIT EARNED'), numeric: true),
                      ],
                      rows: referralsList.map((ref) {
                        final isConverted = ref.status.toLowerCase() == 'converted';
                        final createdDate = ref.createdAt != null
                            ? DateFormat('MMM dd, yyyy').format(DateTime.tryParse(ref.createdAt!) ?? DateTime.now())
                            : '—';
                        final convertedDate = ref.convertedAt != null
                            ? DateFormat('MMM dd, yyyy').format(DateTime.tryParse(ref.convertedAt!) ?? DateTime.now())
                            : '—';

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                ref.refereeEmail ?? 'Pending Registration',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isConverted
                                      ? const Color(0xFF10B981).withAlpha(30)
                                      : const Color(0xFFF59E0B).withAlpha(30),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isConverted ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  ref.status.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: isConverted ? const Color(0xFF34D399) : const Color(0xFFFBBF24),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(createdDate, style: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFFCBD5E1)))),
                            DataCell(Text(convertedDate, style: GoogleFonts.robotoMono(fontSize: 11, color: const Color(0xFFCBD5E1)))),
                            DataCell(
                              Text(
                                ref.creditEarned > 0 ? '+\$${ref.creditEarned.toStringAsFixed(2)}' : '\$0.00',
                                style: GoogleFonts.robotoMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: ref.creditEarned > 0 ? const Color(0xFF34D399) : const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 12, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 8.5, color: const Color(0xFF64748B)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
