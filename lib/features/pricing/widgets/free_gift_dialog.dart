import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/core/models/user_model.dart';
import 'package:polytick_app/core/services/payment_service.dart';

class FreeGiftDialog extends StatelessWidget {
  final UserModel? user;

  const FreeGiftDialog({
    super.key,
    required this.user,
  });

  static void show(BuildContext context, {UserModel? user}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => FreeGiftDialog(user: user),
    );
  }

  static const List<_GiftItemData> _gifts = [
    _GiftItemData(
      number: "1",
      title: "100's Financial Literacy Songs",
      url: "https://www.youtube.com/channel/UC54jDRFnnul3hxQEIol6gIw",
      icon: Icons.music_note_rounded,
      accentColor: Color(0xFFEF4444),
    ),
    _GiftItemData(
      number: "2",
      title: "Get This Amazon Book for Free",
      url: "https://www.amazon.com/Millionaire-Trader-Secrets-Derivatives-Financial/dp/B0FRZ6SS81/ref=sr_1_3?crid=3CIFELGVBN2E8&dib=eyJ2IjoiMSJ9.ytbKJ170THy7YNXTWCSEJR_aq3qEq5YZv7NM3jXGUJ-uvpJw225rImKC-s4ILBWXS7k-rqyIHa1Xtz34ROyeIo80rsnlJFL4jrN3pXL0JalpxpkE5nqULmZeyXoD99LaJoSjWAB04sPlLnSYsbuL0Hydswucp8KOxmkgXCJyZkeNAGcpvnc-cZuHBhyY5l-wxdI6uEVTY3QlMPeICTZlNVfCx6ySBrctkgQ7QNI550A.jVoZTGfcaY1eDlAAVlGbCS9FSWVduJTqkmRIZ1L1Ql0&dib_tag=se&keywords=kirill+gorbounov&qid=1773527889&s=digital-text&sprefix=kirill+gorboun%2Cdigital-text%2C194&sr=1-3-catcorr",
      icon: Icons.menu_book_rounded,
      accentColor: Color(0xFFF59E0B),
    ),
    _GiftItemData(
      number: "3",
      title: "Millionaire Mindset Affirmations",
      url: "https://drive.google.com/file/d/1aIgYhzQdNMNteV28ICaxSrLW8wwmgrtn/view?usp=sharing",
      icon: Icons.psychology_rounded,
      accentColor: Color(0xFF14B8A6),
    ),
    _GiftItemData(
      number: "4",
      title: "Life Philosophy Book",
      url: "https://docs.google.com/document/d/1HC4DH7Nn8giXGYvAHDU-OcJO_AgCl0OS/edit?usp=sharing&ouid=104638826621853212503&rtpof=true&sd=true",
      icon: Icons.auto_stories_rounded,
      accentColor: Color(0xFFA855F7),
    ),
    _GiftItemData(
      number: "5",
      title: "The Millionaire Trader: Secrets of Stocks, Options, and Derivatives",
      url: "https://docs.google.com/document/d/1vZvCBXQCONCbMaD0mBnTSRB3iw__XPJjHYZQpvNGFzk/edit?usp=sharing",
      icon: Icons.description_rounded,
      accentColor: Color(0xFF3B82F6),
    ),
    _GiftItemData(
      number: "6",
      title: "How to Get 10,000% Win in Equities/Stocks/Derivatives",
      url: "https://docs.google.com/document/d/1hNiHSj1SuvocXSndwZjTnobdLmVJlKeUgPu4WkkTTac/edit?usp=sharing",
      icon: Icons.trending_up_rounded,
      accentColor: Color(0xFF10B981),
    ),
    _GiftItemData(
      number: "7",
      title: "Millionaire Real Estate Investor How to for Dummies: Secrets of Real Estate",
      url: "https://docs.google.com/document/d/15rtMOVBw4HRzbeqFCNr8QmvifFVDiiEQNSFDByAclqI/edit?tab=t.0",
      icon: Icons.home_work_rounded,
      accentColor: Color(0xFF0EA5E9),
    ),
    _GiftItemData(
      number: "8",
      title: "Art of Prompting for Book Writing: Master AI and Create Timeless Masterpieces",
      url: "https://docs.google.com/document/d/1f34Y7LqmG82U16SjppQwd5BPaLzT-CLUnfmIZCPDPSc/edit?usp=sharing",
      icon: Icons.edit_note_rounded,
      accentColor: Color(0xFFEC4899),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        decoration: BoxDecoration(
          color: const Color(0xFF111116),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Top Crimson Gradient Line
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 4,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFC60C30)],
                  ),
                ),
              ),
            ),

            // Close Button
            Positioned(
              top: 14,
              right: 14,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: _buildLoggedInContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        const Text(
          '🎁',
          style: TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 12),
        Text(
          'Your Free Gifts',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Complimentary wealth & literacy resources — free for everyone',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // List of gift resource links
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: _gifts.map((gift) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        PaymentService.instance.launchExternalLink(gift.url);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFC60C30),
                              ),
                              child: Center(
                                child: Text(
                                  gift.number,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: gift.accentColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                gift.icon,
                                size: 18,
                                color: gift.accentColor,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                gift.title,
                                style: GoogleFonts.inter(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_outward_rounded,
                              size: 16,
                              color: Color(0xFF9CA3AF),
                            ),
                          ],
                        ),
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
}

class _GiftItemData {
  final String number;
  final String title;
  final String url;
  final IconData icon;
  final Color accentColor;

  const _GiftItemData({
    required this.number,
    required this.title,
    required this.url,
    required this.icon,
    required this.accentColor,
  });
}
