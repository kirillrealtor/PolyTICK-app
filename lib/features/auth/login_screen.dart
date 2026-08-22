import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polytick_app/config/constants.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _otpFocusNode = FocusNode();

  bool _loading = false;
  bool _magicLinkSent = false;
  String? _error;
  String? _deviceId;
  bool _showOtpInput = false;
  bool _crossDeviceDetected = false;
  String? _otpError;
  bool _submittingOtp = false;

  int _resendCooldown = 0;
  Timer? _resendTimer;
  Timer? _pollTimer;
  int _sendCount = 0;

  @override
  void dispose() {
    _resendTimer?.cancel();
    _pollTimer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _emailFocusNode.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCooldown = AppConstants.resendCooldownSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() => _resendCooldown = 0);
      } else {
        setState(() => _resendCooldown--);
      }
    });
  }

  void _startPolling(String? explicitDeviceId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(milliseconds: AppConstants.magicLinkPollIntervalMs),
      (_) async {
        try {
          final authService = ref.read(authServiceProvider);
          final res = await authService.pollMagicCode(deviceId: explicitDeviceId ?? _deviceId);
          final status = res['status'] as String?;
          final token = res['token'] as String?;

          if (status == 'success' && token != null) {
            _pollTimer?.cancel();
            if (mounted) {
              await ref.read(authProvider.notifier).onAuthSuccess(token);
              if (mounted) {
                context.go('/dashboard/congress-trades');
              }
            }
          } else if (status == 'display_code') {
            // The link was opened on a different browser/device.
            // Automatically prompt the user on THIS device to enter the code shown there!
            if (mounted && !_showOtpInput) {
              setState(() {
                _showOtpInput = true;
                _crossDeviceDetected = true;
              });
            }
          }
        } catch (_) {
          // Ignore network errors during polling
        }
      },
    );
  }

  Future<void> _handleSendMagicLink() async {
    final email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty) {
      setState(() => _error = 'Please enter your email address.');
      return;
    }

    // ── Dedicated Google Play Reviewer / Demo Fast-Track Bypass ──
    if (email == 'google-review@polytick.us' ||
        email == 'reviewer@polytick.us' ||
        email == 'demo@polytick.us') {
      setState(() {
        _magicLinkSent = true;
        _showOtpInput = true;
        _deviceId = 'google-review-device';
        _error = null;
        _loading = false;
      });
      return;
    }

    if (_sendCount >= AppConstants.maxSendAttempts) {
      setState(() => _error = 'Too many requests — please wait a few minutes before trying again.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final deviceId = await authService.sendMagicLink(email: email);

      if (mounted) {
        setState(() {
          _magicLinkSent = true;
          _deviceId = deviceId;
          _sendCount++;
          _showOtpInput = false;
          _crossDeviceDetected = false;
          _otpError = null;
        });
        _startResendTimer();
        _startPolling(deviceId);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Could not send verification email. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleOtpSubmit([String? codeToSubmit]) async {
    final code = (codeToSubmit ?? _otpController.text).trim().replaceAll(' ', '');
    if (code.length != 6) {
      setState(() => _otpError = 'Please enter the 6-digit code.');
      return;
    }

    final email = _emailController.text.trim().toLowerCase();

    // ── Dedicated Google Play Reviewer / Demo Code Check ──
    if ((email == 'google-review@polytick.us' ||
            email == 'reviewer@polytick.us' ||
            email == 'demo@polytick.us') &&
        (code == '777888' || code == '123456')) {
      _pollTimer?.cancel();
      await ref.read(authProvider.notifier).loginAsReviewer();
      if (mounted) {
        context.go('/dashboard/congress-trades');
      }
      return;
    }

    setState(() {
      _submittingOtp = true;
      _otpError = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final token = await authService.confirmMagicCode(
        code: code,
        deviceId: _deviceId,
      );

      if (token != null && mounted) {
        _pollTimer?.cancel();
        await ref.read(authProvider.notifier).onAuthSuccess(token);
        if (mounted) {
          context.go('/dashboard/congress-trades');
        }
      } else {
        if (mounted) {
          setState(() => _otpError = 'That code is incorrect — please check and try again.');
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _otpError = 'That code is incorrect or expired. Try again.');
      }
    } finally {
      if (mounted) setState(() => _submittingOtp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showFooter: false,
      showBackButton: true,
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: _magicLinkSent ? _buildWaitingState() : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Brand Title with Poly in Blue & TICK in Red
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
            children: [
              const TextSpan(text: 'Sign in to '),
              TextSpan(
                text: 'Poly',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF51A2FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'TICK',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFC60C30),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppConstants.appTagline,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // Error Banner
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Text(
              _error!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFFDC2626),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Email Form Input Field (Tap anywhere on the box to type)
        GestureDetector(
          onTap: () => _emailFocusNode.requestFocus(),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
                border: InputBorder.none,
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (_) => _handleSendMagicLink(),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Continue with Email CTA Button
        ElevatedButton(
          onPressed: _loading ? null : _handleSendMagicLink,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  'Continue with email',
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),

        const SizedBox(height: 24),
        Text(
          'By continuing, you agree to our Terms of Service and Privacy Policy.',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWaitingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mail Icon Badge
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEFF6FF),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Icon(
            _showOtpInput ? Icons.key_rounded : Icons.email_outlined,
            size: 28,
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          _showOtpInput ? 'Enter Verification Code' : 'Check your email',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        if (!_showOtpInput) ...[
          Text(
            'To continue, click the link sent to',
            style: GoogleFonts.poppins(fontSize: 13.5, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 2),
          Text(
            _emailController.text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // Polling Waiting Animation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Waiting for you to click the link...',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ] else ...[
          // Explanation message when cross-device link click is detected or user tapped manual entry
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _crossDeviceDetected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _crossDeviceDetected ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              _crossDeviceDetected
                  ? 'We detected you opened the link on another device. Enter the 6-digit code shown on that screen below:'
                  : 'Enter the 6-digit verification code shown on your other device or email:',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: _crossDeviceDetected ? const Color(0xFF1E40AF) : const Color(0xFF64748B),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // ── OTP 6-Digit Spaced Input Box (Tap anywhere on the box to type) ──
          GestureDetector(
            onTap: () => _otpFocusNode.requestFocus(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _otpError != null ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _otpController,
                focusNode: _otpFocusNode,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 8,
                  color: const Color(0xFF0F172A),
                ),
                decoration: const InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(
                    color: Color(0xFF94A3B8),
                    letterSpacing: 8,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  isDense: false,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (val) {
                  if (val.trim().length == 6) {
                    _handleOtpSubmit(val);
                  }
                },
              ),
            ),
          ),
          if (_otpError != null) ...[
            const SizedBox(height: 8),
            Text(
              _otpError!,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: const Color(0xFFDC2626),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),

          // Submit OTP CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submittingOtp ? null : () => _handleOtpSubmit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _submittingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      'Verify & Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        const Divider(color: Color(0xFFF1F5F9)),
        const SizedBox(height: 8),

        // ── Action Links ──
        if (!_showOtpInput)
          TextButton(
            onPressed: () => setState(() => _showOtpInput = true),
            child: Text(
              'Enter verification code',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF51A2FF),
              ),
            ),
          )
        else
          TextButton(
            onPressed: () => setState(() {
              _showOtpInput = false;
              _crossDeviceDetected = false;
              _otpError = null;
            }),
            child: Text(
              'Back to waiting for link',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF51A2FF),
              ),
            ),
          ),

        TextButton(
          onPressed: _resendCooldown > 0 ? null : _handleSendMagicLink,
          child: Text(
            _resendCooldown > 0 ? 'Resend email in ${_resendCooldown}s' : 'Resend email',
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: _resendCooldown > 0 ? const Color(0xFF94A3B8) : const Color(0xFF2563EB),
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            setState(() {
              _magicLinkSent = false;
              _showOtpInput = false;
              _crossDeviceDetected = false;
              _error = null;
              _otpError = null;
            });
          },
          child: Text(
            'Use a different email',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }
}
