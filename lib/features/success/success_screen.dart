import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/core/api/api_client.dart';
import 'package:polytick_app/config/api_config.dart';

class SuccessScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const SuccessScreen({
    super.key,
    this.sessionId,
  });

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen> {
  String _status = 'processing'; // 'processing' | 'success' | 'error'
  String _message = 'Verifying your subscription status with Stripe...';
  int _pollAttempts = 0;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _startAccessCheck();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startAccessCheck() {
    _checkAccess();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkAccess();
    });
  }

  Future<void> _checkAccess() async {
    try {
      final response = await ApiClient.instance.get(ApiConfig.checkAccessSecure);
      final data = response.data as Map<String, dynamic>?;

      if (data?['status'] == 'active') {
        _pollTimer?.cancel();
        if (mounted) {
          setState(() {
            _status = 'success';
            _message = 'Your premium access is now fully active! Redirecting to dashboard...';
          });

          await ref.read(authProvider.notifier).refreshSubscription();

          Future.delayed(const Duration(milliseconds: 2500), () {
            if (mounted) {
              context.go('/dashboard/congress-trades');
            }
          });
        }
      } else {
        _pollAttempts++;
        if (_pollAttempts >= 20) {
          _pollTimer?.cancel();
          if (mounted) {
            setState(() {
              _status = 'error';
              _message = "We couldn't verify your subscription immediately. Don't worry — your payment was processed successfully. It may take a moment to sync. Please try again or head to the dashboard to check.";
            });
          }
        }
      }
    } catch (e) {
      _pollAttempts++;
      if (_pollAttempts >= 20) {
        _pollTimer?.cancel();
        if (mounted) {
          setState(() {
            _status = 'error';
            _message = "We encountered an issue verifying your payment status. If your payment was completed, your account will be active shortly.";
          });
        }
      }
    }
  }

  void _handleManualRetry() {
    setState(() {
      _pollAttempts = 0;
      _status = 'processing';
      _message = 'Re-verifying your premium access status...';
    });
    _startAccessCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          // Background subtle ambient glow
          Center(
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_status == 'processing') _buildProcessingState(),
                      if (_status == 'success') _buildSuccessState(),
                      if (_status == 'error') _buildErrorState(),
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

  Widget _buildProcessingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 52,
          height: 52,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xFF818CF8),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'CONFIRMING PAYMENT',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _message,
          style: GoogleFonts.poppins(
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sync_rounded,
              size: 16,
              color: Color(0xFF818CF8),
            ),
            const SizedBox(width: 6),
            Text(
              'STRIPE WEBHOOK SYNCING',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF818CF8),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 42,
              color: Color(0xFF10B981),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'UPGRADE COMPLETE',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF10B981),
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _message,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE5E7EB),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        // Progress Indicator
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          clipBehavior: Clip.antiAlias,
          child: const LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.4),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.hourglass_empty_rounded,
              size: 36,
              color: Color(0xFFEF4444),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'VERIFICATION DELAYED',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFEF4444),
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          _message,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD1D5DB),
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleManualRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'RE-CHECK ACCESS',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            OutlinedButton(
              onPressed: () => context.go('/dashboard/congress-trades'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF374151)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'GO TO DASHBOARD',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
