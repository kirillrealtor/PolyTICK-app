import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. TERMS OF SERVICE SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ambient Gradient Background Glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0D3B82F6), // Blue 5%
                      Colors.transparent,
                      Color(0x0DC60C30), // Red 5%
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Icon Badge
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.balance_rounded,
                          size: 32,
                          color: Color(0xFF60A5FA),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Terms of ',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF60A5FA),
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Service',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFC60C30),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Last Updated: April 27, 2026',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Main Card Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Agreement to Terms
                            _buildSectionHeader(
                              icon: Icons.description_outlined,
                              title: '1. Agreement to Terms',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'By accessing or using PolyTICK ("the Service"), you agree to be bound by these Terms of Service ("Terms"). If you disagree with any part of these terms, you may not access the Service. These Terms apply to all visitors, users, and others who access or use the Service.',
                            ),

                            const SizedBox(height: 32),

                            // 2. Use of Service
                            _buildSectionHeader(
                              icon: Icons.person_outline_rounded,
                              title: '2. Use of Service',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'PolyTICK provides access to publicly available information about political trading activities across 8 analytical layers. You may use the Service for lawful purposes only and in accordance with these Terms.',
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Prohibited Activities:',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildBullet(
                                    'Using automated systems (bots, scrapers) to extract data without permission.',
                                  ),
                                  _buildBullet(
                                    'Attempting to interfere with the proper working of the Service.',
                                  ),
                                  _buildBullet(
                                    'Bypassing any measures we may use to prevent or restrict access.',
                                  ),
                                  _buildBullet(
                                    'Using the Service for any unauthorized commercial purposes.',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 3. Intellectual Property
                            _buildSectionHeader(
                              icon: Icons.verified_user_outlined,
                              title: '3. Intellectual Property',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'The Service and its original content, features, and functionality are and will remain the exclusive property of PolyTICK. Our trademarks and trade dress may not be used in connection with any product or service without the prior written consent of PolyTICK.',
                            ),

                            const SizedBox(height: 32),

                            // 4. Subscription and Payments
                            _buildPlainSectionHeader(
                              '4. Subscription and Payments',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'Some parts of the Service are billed on a subscription basis. You will be billed in advance on a recurring and periodic basis. At the end of each Billing Cycle, your Subscription will automatically renew under the exact same conditions unless you cancel it or PolyTICK cancels it.',
                            ),

                            const SizedBox(height: 32),

                            // 5. Termination
                            _buildPlainSectionHeader('5. Termination'),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.',
                            ),

                            const SizedBox(height: 32),

                            // 6. Governing Law
                            _buildPlainSectionHeader('6. Governing Law'),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'These Terms shall be governed and construed in accordance with the laws of the United States, without regard to its conflict of law provisions. Our failure to enforce any right or provision of these Terms will not be considered a waiver of those rights.',
                            ),

                            const SizedBox(height: 32),

                            // 7. Contact Information
                            _buildPlainSectionHeader('7. Contact Information'),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.6,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'If you have any questions about these Terms, please contact us at: ',
                                  ),
                                  TextSpan(
                                    text: 'polytick7@gmail.com',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF60A5FA),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Back to Home Button
                      _buildBackHomeButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. PRIVACY POLICY SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ambient Gradient Background Glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0D3B82F6), // Blue 5%
                      Colors.transparent,
                      Color(0x0DC60C30), // Red 5%
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Icon Badge
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 32,
                          color: Color(0xFF60A5FA),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Privacy ',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF60A5FA),
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Policy',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFC60C30),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Last Updated: August 17, 2026',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Google Play Data Safety Summary Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: Color(0xFF60A5FA),
                              size: 24,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Google Play Data Safety Commitment',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'PolyTICK does NOT sell your personal data. All data transmission is encrypted via TLS 1.3. We collect minimal identifiers required to provide trade intelligence and deliver user-requested alerts.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFFCBD5E1),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Main Card Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Information We Collect
                            _buildSectionHeader(
                              icon: Icons.visibility_outlined,
                              title: '1. Information We Collect',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'PolyTICK collects minimal personal information strictly required to operate the platform, authenticate users, process subscriptions, and distribute real-time stock alerts:',
                            ),
                            const SizedBox(height: 12),
                            _buildRichBullet(
                              'Account Identifiers: ',
                              'Email address (for passwordless magic-link sign-in, account security, and subscription status) and optional name.',
                            ),
                            _buildRichBullet(
                              'Financial & Subscription Data: ',
                              'Subscription status, tier, and Stripe customer tokens. PolyTICK never stores or accesses raw credit card numbers or CVVs.',
                            ),
                            _buildRichBullet(
                              'Push Notification Tokens: ',
                              'Firebase Cloud Messaging (FCM) registration tokens used to send real-time congressional trade alerts.',
                            ),
                            _buildRichBullet(
                              'Technical & Device Data: ',
                              'IP address, operating system, app version, network connectivity status, and crash diagnostic logs.',
                            ),

                            const SizedBox(height: 32),

                            // 2. How We Use Information
                            _buildSectionHeader(
                              icon: Icons.storage_outlined,
                              title: '2. How We Use Information',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'We use the collected information for the following specific purposes:',
                            ),
                            const SizedBox(height: 12),
                            _buildBullet('To provide, operate, and maintain the PolyTICK platform and 8 analytical layers.'),
                            _buildBullet('To authenticate user sessions securely with cryptographic tokens.'),
                            _buildBullet('To manage subscriptions, free trial periods, and billing cycles.'),
                            _buildBullet('To deliver real-time push alerts for tracked politician stock transactions.'),
                            _buildBullet('To protect against automated abuse, fraud, and bot attacks.'),
                            _buildBullet('To provide responsive customer and technical support.'),

                            const SizedBox(height: 32),

                            // 3. Third-Party Services & SDKs
                            _buildSectionHeader(
                              icon: Icons.hub_outlined,
                              title: '3. Third-Party Services & SDKs',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'We disclose the following third-party sub-processors integrated into the PolyTICK application:',
                            ),
                            const SizedBox(height: 12),
                            _buildRichBullet('Google Firebase (FCM): ', 'Push notification dispatch and delivery telemetry.'),
                            _buildRichBullet('Stripe, Inc.: ', 'PCI-DSS Level 1 compliant subscription payment processing.'),
                            _buildRichBullet('Google Identity / OAuth: ', 'Secure single sign-on authentication service.'),
                            _buildRichBullet('Google reCAPTCHA v3: ', 'Bot detection and abuse prevention.'),
                            _buildRichBullet('Google Analytics 4: ', 'Aggregated user interaction and performance telemetry.'),
                            _buildRichBullet('Cloudflare & Railway: ', 'Encrypted edge caching, DDoS protection, and secure backend hosting.'),

                            const SizedBox(height: 32),

                            // 4. Mobile Device Permissions
                            _buildSectionHeader(
                              icon: Icons.phone_android_outlined,
                              title: '4. Mobile Device Permissions',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'The PolyTICK mobile app requests the following system permissions:',
                            ),
                            const SizedBox(height: 12),
                            _buildRichBullet('INTERNET: ', 'Allows the app to fetch live politician trade filings over HTTPS.'),
                            _buildRichBullet('ACCESS_NETWORK_STATE: ', 'Detects network status to handle offline and online states smoothly.'),
                            _buildRichBullet('POST_NOTIFICATIONS: ', 'Delivers breaking trade notifications (opt-in; can be disabled anytime in device settings).'),
                            _buildRichBullet('VIBRATE: ', 'Provides haptic feedback for high-conviction trade alerts.'),

                            const SizedBox(height: 32),

                            // 5. Zero-Sale Guarantee
                            _buildSectionHeader(
                              icon: Icons.lock_outline_rounded,
                              title: '5. Data Sharing & Zero-Sale Guarantee',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'PolyTICK NEVER sells, rents, leases, or trades your personal information or usage history to third-party data brokers, ad networks, or commercial entities.',
                            ),

                            const SizedBox(height: 32),

                            // 6. Account Deletion & Data Erasure
                            _buildSectionHeader(
                              icon: Icons.delete_outline_rounded,
                              title: '6. Account Deletion & Data Erasure',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'In full compliance with Google Play Store Policies, you have the right to request permanent deletion of your account and personal data at any time.',
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC60C30).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFC60C30).withValues(alpha: 0.25),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'How to Request Account Deletion:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildBullet(
                                    'Email polytick7@gmail.com with subject "Account Deletion Request".',
                                  ),
                                  _buildBullet(
                                    'Or visit our public web deletion page at https://www.polytick.us/delete-account.',
                                  ),
                                  _buildBullet(
                                    'All personal identifiers, watchlists, push tokens, and active sessions will be permanently purged within 30 days.',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // 7. Data Security & Retention
                            _buildPlainSectionHeader('7. Data Security & Retention'),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'We enforce TLS 1.3 encryption in transit, on-device encrypted token storage (flutter_secure_storage / KeyStore / Keychain), and automatic log rotation. Account data is retained as long as your account remains active.',
                            ),

                            const SizedBox(height: 32),

                            // 8. Contact Information
                            _buildPlainSectionHeader('8. Contact Information'),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.6,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'For any privacy inquiries or deletion requests, please contact us at: ',
                                  ),
                                  TextSpan(
                                    text: 'polytick7@gmail.com',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF60A5FA),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Back to Home Button
                      _buildBackHomeButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. COOKIE POLICY SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class CookiesScreen extends StatelessWidget {
  const CookiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ambient Gradient Background Glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x0D3B82F6), // Blue 5%
                      Colors.transparent,
                      Color(0x0DC60C30), // Red 5%
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Icon Badge
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.cookie_outlined,
                          size: 32,
                          color: Color(0xFF60A5FA),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Cookie ',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF60A5FA),
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'Policy',
                              style: GoogleFonts.poppins(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFC60C30),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Last Updated: April 27, 2026',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Main Card Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. What Are Cookies?
                            _buildSectionHeader(
                              icon: Icons.info_outline_rounded,
                              title: '1. What Are Cookies?',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'Cookies are small text files that are stored on your device when you visit a website. They are widely used to make websites work or work more efficiently, as well as to provide information to the owners of the site.',
                            ),

                            const SizedBox(height: 32),

                            // 2. How We Use Cookies
                            _buildSectionHeader(
                              icon: Icons.settings_outlined,
                              title: '2. How We Use Cookies',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'We use cookies for the following purposes:',
                            ),
                            const SizedBox(height: 16),

                            // 4-Card Grid for Cookies
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isMobile = constraints.maxWidth < 600;
                                if (isMobile) {
                                  return Column(
                                    children: [
                                      _buildCookieTypeCard(
                                        'Essential Cookies',
                                        'Necessary for the website to function correctly, such as authentication and security.',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildCookieTypeCard(
                                        'Analytics Cookies',
                                        'Help us understand how visitors interact with our site by collecting anonymous information.',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildCookieTypeCard(
                                        'Preference Cookies',
                                        'Allow the site to remember choices you make (like your username or language).',
                                      ),
                                      const SizedBox(height: 12),
                                      _buildCookieTypeCard(
                                        'Marketing Cookies',
                                        'Used to track visitors across websites to display relevant and engaging ads.',
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _buildCookieTypeCard(
                                            'Essential Cookies',
                                            'Necessary for the website to function correctly, such as authentication and security.',
                                          ),
                                          const SizedBox(height: 12),
                                          _buildCookieTypeCard(
                                            'Preference Cookies',
                                            'Allow the site to remember choices you make (like your username or language).',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          _buildCookieTypeCard(
                                            'Analytics Cookies',
                                            'Help us understand how visitors interact with our site by collecting anonymous information.',
                                          ),
                                          const SizedBox(height: 12),
                                          _buildCookieTypeCard(
                                            'Marketing Cookies',
                                            'Used to track visitors across websites to display relevant and engaging ads.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            // 3. Managing Cookies
                            _buildSectionHeader(
                              icon: Icons.verified_user_outlined,
                              title: '3. Managing Cookies',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'Most web browsers allow you to control cookies through their settings preferences. However, if you limit the ability of websites to set cookies, you may worsen your overall user experience, as it will no longer be personalized to you. It may also stop you from saving customized settings like login information.',
                            ),

                            const SizedBox(height: 32),

                            // 4. Third-Party Cookies
                            _buildPlainSectionHeader(
                              '4. Third-Party Cookies',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'In addition to our own cookies, we may also use various third-party cookies to report usage statistics of the Service, deliver advertisements on and through the Service, and so on.',
                            ),

                            const SizedBox(height: 32),

                            // 5. More Information
                            _buildPlainSectionHeader('5. More Information'),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.6,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'For more information about our use of cookies, please contact us at: ',
                                  ),
                                  TextSpan(
                                    text: 'polytick7@gmail.com',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF60A5FA),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Back to Home Button
                      _buildBackHomeButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookieTypeCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: const Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. DISCLAIMER SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  Future<void> _launchExternalUrl(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Ambient Red Glow
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x1AC60C30), // Red 10%
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Icon Badge
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFC60C30).withValues(alpha: 0.1),
                          border: Border.all(
                            color: const Color(
                              0xFFC60C30,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          size: 32,
                          color: Color(0xFFC60C30),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'Disclaimer',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFC60C30),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'Last Updated: August 19, 2026',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Main Card Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── 1. NON-GOVERNMENT ENTITY & NON-AFFILIATION NOTICE ──
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_balance_outlined,
                                        color: Color(0xFF60A5FA),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '1. Non-Government Entity Notice',
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'IMPORTANT NON-AFFILIATION DISCLAIMER:',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                      color: const Color(0xFF60A5FA),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color(0xFFE2E8F0),
                                        height: 1.6,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text:
                                              'PolyTICK is a privately owned and independent market intelligence platform operated by ZenAIautomation.com. PolyTICK is ',
                                        ),
                                        TextSpan(
                                          text:
                                              'NOT affiliated with, endorsed by, authorized by, sponsored by, or in any way officially connected to the United States Government, the U.S. Congress, the U.S. Senate, the U.S. House of Representatives, or any federal, state, or municipal government agency or official entity.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' PolyTICK does NOT represent any government entity and does NOT provide or facilitate government services.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Public Government Data Sources (.gov):',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  _buildBodyText(
                                    'All congressional trading disclosures presented within PolyTICK are derived solely from public federal records mandated under the Stop Trading on Congressional Knowledge Act of 2012 (STOCK Act). Official government repositories include:',
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _buildExternalGovButton(
                                        label: 'House Disclosures (clerk.house.gov)',
                                        url: 'https://disclosures-clerk.house.gov',
                                      ),
                                      _buildExternalGovButton(
                                        label: 'Senate Disclosures (efdsearch.senate.gov)',
                                        url: 'https://efdsearch.senate.gov',
                                      ),
                                      _buildExternalGovButton(
                                        label: 'Congress.gov (Legislative Information)',
                                        url: 'https://www.congress.gov',
                                      ),
                                      _buildExternalGovButton(
                                        label: 'SEC EDGAR (sec.gov)',
                                        url: 'https://www.sec.gov/edgar',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Highlighted Red Section: No Financial Advice
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFC60C30,
                                ).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC60C30,
                                  ).withValues(alpha: 0.25),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFEF4444),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '2. No Financial Advice',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'CRUCIAL NOTICE:',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 14.5,
                                        color: const Color(0xFFE2E8F0),
                                        height: 1.6,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text:
                                              'PolyTICK is NOT a financial advisor, broker, or tax professional. The information provided on this platform is for ',
                                        ),
                                        TextSpan(
                                          text:
                                              'informational and educational purposes only',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              ' and should not be construed as investment, financial, legal, or tax advice.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildBodyText(
                                    'Trading stocks, options, and other financial instruments involves significant risk and the potential for total loss of capital. Past performance is not indicative of future results. You should consult with a qualified financial professional before making any investment decisions.',
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Data Accuracy & Limitations
                            _buildSectionHeader(
                              icon: Icons.shield_outlined,
                              title: '3. Data Accuracy & Limitations',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'While we strive to provide accurate and up-to-date information through our 8-Layer Intelligence Engine, PolyTICK does not guarantee the accuracy, completeness, or timeliness of the data displayed. Our data is aggregated from various publicly available government sources (such as STOCK Act filings and SEC records) which may contain errors, omissions, or reporting delays by filers.',
                            ),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'The "Overlay Signals" and "AI Insights" are generated by proprietary algorithms and should be used as one of many tools in your research process, not as a sole basis for any trade.',
                            ),

                            const SizedBox(height: 32),

                            // Limitation of Liability
                            _buildPlainSectionHeader('4. Limitation of Liability'),
                            const SizedBox(height: 12),
                            _buildBodyText(
                              'In no event shall PolyTICK, its founders, employees, or partners be liable for any financial losses or damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on PolyTICK\'s website or application.',
                            ),

                            const SizedBox(height: 28),

                            // Footer Note
                            Container(
                              padding: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              child: Text(
                                'By using PolyTICK, you acknowledge that you have read, understood, and agreed to this disclaimer. If you do not agree with these terms, you are prohibited from using the service.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: const Color(0xFF64748B),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Back to Home Button
                      _buildBackHomeButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExternalGovButton({required String label, required String url}) {
    return GestureDetector(
      onTap: () => _launchExternalUrl(url),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF3B82F6).withAlpha(100),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.open_in_new_rounded,
                size: 13,
                color: Color(0xFF60A5FA),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. DATA SOURCES SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class DataSourcesScreen extends StatelessWidget {
  const DataSourcesScreen({super.key});

  Future<void> _launchExternalUrl(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Icon Badge
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_rounded,
                      size: 32,
                      color: Color(0xFF60A5FA),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Official Government ',
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF60A5FA),
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Data Sources',
                          style: GoogleFonts.poppins(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Full transparency on public records, federal reporting laws, and data provenance.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // ── Non-Affiliation Disclaimer Card ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF60A5FA),
                          size: 24,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Non-Government Entity Disclaimer',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'PolyTICK is an independent data analysis platform developed by ZenAIautomation.com. PolyTICK does NOT represent, hold affiliation with, or operate on behalf of the U.S. Government, U.S. Congress, or any government agency. All data is gathered exclusively from publicly accessible federal records mandated by the 2012 STOCK Act.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── List of Official Government Sources ──
                  _buildGovSourceDetailCard(
                    title: 'U.S. House of Representatives Financial Disclosures',
                    domain: 'disclosures-clerk.house.gov',
                    url: 'https://disclosures-clerk.house.gov',
                    agency: 'Office of the Clerk of the U.S. House of Representatives',
                    description:
                        'Mandatory Periodic Transaction Reports (PTRs) and annual financial statements filed by Members of the House of Representatives under the Stop Trading on Congressional Knowledge Act of 2012 (STOCK Act).',
                  ),
                  const SizedBox(height: 18),

                  _buildGovSourceDetailCard(
                    title: 'U.S. Senate Electronic Financial Disclosures (eFD)',
                    domain: 'efdsearch.senate.gov',
                    url: 'https://efdsearch.senate.gov',
                    agency: 'Senate Select Committee on Ethics / Office of Public Records',
                    description:
                        'Official electronic filing portal containing Periodic Transaction Reports, blind trust agreements, and annual disclosure statements filed by sitting U.S. Senators and candidates.',
                  ),
                  const SizedBox(height: 18),

                  _buildGovSourceDetailCard(
                    title: 'United States Congress Official Legislative Database',
                    domain: 'congress.gov',
                    url: 'https://www.congress.gov',
                    agency: 'Library of Congress',
                    description:
                        'Official legislative records including committee memberships, subcommittee assignments, hearing schedules, transcripts, roll-call votes, and bill sponsorship data.',
                  ),
                  const SizedBox(height: 18),

                  _buildGovSourceDetailCard(
                    title: 'U.S. Securities and Exchange Commission (SEC EDGAR)',
                    domain: 'sec.gov/edgar',
                    url: 'https://www.sec.gov/edgar',
                    agency: 'U.S. Securities and Exchange Commission',
                    description:
                        'Official Electronic Data Gathering, Analysis, and Retrieval system containing corporate insider filings (Form 3, 4, 5) and institutional investment manager quarterly holdings (Form 13F).',
                  ),
                  const SizedBox(height: 18),

                  _buildGovSourceDetailCard(
                    title: 'U.S. Office of Government Ethics (OGE)',
                    domain: 'oge.gov',
                    url: 'https://www.oge.gov',
                    agency: 'U.S. Office of Government Ethics',
                    description:
                        'Federal public financial disclosure guidance (OGE Form 278e / OGE Form 278-T) establishing standards for executive and legislative branch ethics compliance.',
                  ),

                  const SizedBox(height: 40),

                  // ── Additional Intelligence Layers ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Supplementary Market Intelligence Sources',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildBullet('ARK Invest Daily Disclosures: Public daily trade notices published by ARK Investment Management LLC.'),
                        _buildBullet('Wall Street Consensus: Aggregated public price targets and analyst ratings from major investment banks and research desks.'),
                        _buildBullet('The Motley Fool: Public investment advisory picks cross-referenced for long-term fundamental conviction.'),
                        _buildBullet('AI NLP Processing: Proprietary natural language analysis applied to publicly broadcast congressional hearings and official testimonies.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildBackHomeButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGovSourceDetailCard({
    required String title,
    required String domain,
    required String url,
    required String agency,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF131722),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  size: 20,
                  color: Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      agency,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: const Color(0xFFCBD5E1),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => _launchExternalUrl(url),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 14,
                        color: Color(0xFF60A5FA),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Visit $domain',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPER WIDGETS & BUILDERS
// ─────────────────────────────────────────────────────────────────────────────
Widget _buildSectionHeader({required IconData icon, required String title}) {
  return Row(
    children: [
      Icon(icon, size: 22, color: const Color(0xFF60A5FA)),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}

Widget _buildPlainSectionHeader(String title) {
  return Text(
    title,
    style: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}

Widget _buildBodyText(String text) {
  return Text(
    text,
    style: GoogleFonts.inter(
      fontSize: 15,
      color: const Color(0xFFCBD5E1),
      height: 1.65,
    ),
  );
}

Widget _buildBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 10),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Color(0xFF60A5FA),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFFCBD5E1),
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildRichBullet(String boldPrefix, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, right: 10),
          width: 5,
          height: 5,
          decoration: const BoxDecoration(
            color: Color(0xFF60A5FA),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14.5,
                color: const Color(0xFFCBD5E1),
                height: 1.55,
              ),
              children: [
                TextSpan(
                  text: boldPrefix,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBackHomeButton(BuildContext context) {
  return GestureDetector(
    onTap: () => context.go('/'),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Back to Home',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
