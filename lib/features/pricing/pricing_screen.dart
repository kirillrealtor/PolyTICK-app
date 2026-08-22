import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/core/auth/token_storage.dart';
import 'package:polytick_app/core/services/payment_service.dart';
import 'package:polytick_app/features/pricing/widgets/coaching_pricing_card.dart';
import 'package:polytick_app/features/pricing/widgets/free_gift_bonus_card.dart';
import 'package:polytick_app/features/pricing/widgets/free_gift_dialog.dart';
import 'package:polytick_app/features/pricing/widgets/invite_reward_card.dart';
import 'package:polytick_app/features/pricing/widgets/monthly_pricing_card.dart';
import 'package:polytick_app/features/pricing/widgets/pricing_billing_toggle.dart';
import 'package:polytick_app/features/pricing/widgets/pricing_faq_section.dart';
import 'package:polytick_app/features/pricing/widgets/referral_discount_banner.dart';
import 'package:polytick_app/features/pricing/widgets/special_offer_card.dart';
import 'package:polytick_app/features/pricing/widgets/yearly_pricing_card.dart';
import 'package:polytick_app/shared/widgets/app_scaffold.dart';

class PricingScreen extends ConsumerStatefulWidget {
  final String? initialPlan;
  final String? initialRef;

  const PricingScreen({
    super.key,
    this.initialPlan,
    this.initialRef,
  });

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  String _selectedBilling = 'Monthly';
  bool _loadingMonthly = false;
  bool _loadingYearly = false;
  bool _loadingCoaching = false;
  bool _loadingTrial = false;
  String? _referralCode;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initReferralAndAutoPlan();
  }

  Future<void> _initReferralAndAutoPlan() async {
    final tokenStorage = TokenStorage();
    if (widget.initialRef != null && widget.initialRef!.isNotEmpty) {
      await tokenStorage.setReferralCode(widget.initialRef!);
      if (mounted) setState(() => _referralCode = widget.initialRef);
    } else {
      final storedRef = await tokenStorage.getReferralCode();
      if (mounted) setState(() => _referralCode = storedRef);
    }

    // Auto-checkout if user arrived with ?plan=
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (!authState.loading && authState.currentUser != null && widget.initialPlan != null) {
        if (widget.initialPlan == 'monthly') {
          _handleMonthlyCheckout();
        } else if (widget.initialPlan == 'yearly') {
          _handleYearlyCheckout();
        } else if (widget.initialPlan == 'coaching') {
          _handleCoachingCheckout();
        }
      }
    });
  }

  Future<void> _handleStartTrialClick() async {
    final authState = ref.read(authProvider);
    final user = authState.currentUser;

    if (user == null) {
      await TokenStorage().setIntendedPlan('free');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in or create an account to start your free trial.'),
            backgroundColor: Color(0xFF1E293B),
          ),
        );
        context.go('/login');
      }
      return;
    }

    if (authState.subscription?.status == 'active') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You already have an active plan!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      context.go('/dashboard/congress-trades');
      return;
    }

    setState(() {
      _loadingTrial = true;
      _error = null;
    });

    try {
      await PaymentService.instance.startFreeTrial(user.email);
      await ref.read(authProvider.notifier).refreshSubscription();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('14-Day Free Trial Activated!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        context.go('/dashboard/congress-trades');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error ?? 'Failed to activate free trial'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingTrial = false);
    }
  }

  Future<void> _handleMonthlyCheckout() async {
    final authState = ref.read(authProvider);
    final user = authState.currentUser;

    if (user == null) {
      await TokenStorage().setIntendedPlan('monthly');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in or create an account to subscribe.'),
            backgroundColor: Color(0xFF1E293B),
          ),
        );
        context.go('/login');
      }
      return;
    }

    setState(() {
      _loadingMonthly = true;
      _error = null;
    });

    try {
      final session = await PaymentService.instance.createMonthlyCheckout(
        email: user.email,
        name: user.fullName,
        referralCode: _referralCode,
      );

      final checkoutUrl = session['checkout_url'] as String?;
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        await PaymentService.instance.launchCheckoutUrl(checkoutUrl);
      } else {
        throw Exception('No checkout URL returned by payment gateway.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout Error: $_error'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMonthly = false);
    }
  }

  Future<void> _handleYearlyCheckout() async {
    final authState = ref.read(authProvider);
    final user = authState.currentUser;

    if (user == null) {
      await TokenStorage().setIntendedPlan('yearly');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in or create an account to subscribe.'),
            backgroundColor: Color(0xFF1E293B),
          ),
        );
        context.go('/login');
      }
      return;
    }

    setState(() {
      _loadingYearly = true;
      _error = null;
    });

    try {
      final session = await PaymentService.instance.createYearlyCheckout(
        email: user.email,
        name: user.fullName,
        referralCode: _referralCode,
      );

      final checkoutUrl = session['checkout_url'] as String?;
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        await PaymentService.instance.launchCheckoutUrl(checkoutUrl);
      } else {
        throw Exception('No checkout URL returned by payment gateway.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout Error: $_error'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingYearly = false);
    }
  }

  Future<void> _handleCoachingCheckout() async {
    final authState = ref.read(authProvider);
    final user = authState.currentUser;

    if (user == null) {
      await TokenStorage().setIntendedPlan('coaching');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in or create an account to join coaching.'),
            backgroundColor: Color(0xFF1E293B),
          ),
        );
        context.go('/login');
      }
      return;
    }

    setState(() {
      _loadingCoaching = true;
      _error = null;
    });

    try {
      final session = await PaymentService.instance.createCoachingCheckout(
        email: user.email,
        name: user.fullName,
        referralCode: _referralCode,
      );

      final checkoutUrl = session['checkout_url'] as String?;
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        await PaymentService.instance.launchCheckoutUrl(checkoutUrl);
      } else {
        throw Exception('No checkout URL returned by payment gateway.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout Error: $_error'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingCoaching = false);
    }
  }

  void _handleClaimFreeGift() {
    final authState = ref.read(authProvider);
    FreeGiftDialog.show(context, user: authState.currentUser);
  }

  Future<void> _handleClearReferral() async {
    await TokenStorage().clearReferralCode();
    if (mounted) {
      setState(() => _referralCode = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final subscription = authState.subscription;

    final bool isMonthlyCurrent = subscription?.isMonthly == true;
    final bool isYearlyCurrent = subscription?.isYearly == true;
    final bool isCoachingCurrent = subscription?.isCoaching == true;

    return AppScaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Headline 1: One Subscription. (Gradient Text) ──
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFACACAC),
                  Color(0xFF000000),
                ],
              ).createShader(bounds),
              child: Text(
                'One Subscription.',
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  height: 0.95,
                  letterSpacing: -0.34,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ── 3. Headline 2: Endless Market Intelligence. (Italic) ──
            Text(
              'Endless Market Intelligence.',
              style: GoogleFonts.poppins(
                fontSize: 27,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF000000),
                height: 0.95,
                letterSpacing: -0.27,
              ),
            ),

            const SizedBox(height: 18),

            // ── 4. Subtitle ──
            Text(
              'Everything institutional traders pay\nhundreds for — starting free.',
              style: GoogleFonts.poppins(
                fontSize: 15.5,
                fontWeight: FontWeight.w300,
                color: const Color(0xFF000000),
                height: 1.25,
                letterSpacing: 0.15,
              ),
            ),

            const SizedBox(height: 20),

            // ── Referral Discount Banner (if active incoming referral code detected) ──
            if (_referralCode != null && _referralCode!.isNotEmpty)
              Center(
                child: ReferralDiscountBanner(
                  user: user,
                  referralData: authState.referralData,
                  isLoading: authState.loading,
                  onClear: _handleClearReferral,
                ),
              ),

            const SizedBox(height: 8),

            // ── 5. The Free, Monthly, and Yearly Toggle Button ──
            PricingBillingToggle(
              selectedOption: _selectedBilling,
              onOptionChanged: (option) {
                setState(() {
                  _selectedBilling = option;
                });
              },
            ),

            // ── 6. Invite Friends. Get Rewarded. (Gift Box Section) ──
            InviteRewardCard(user: user),

            const SizedBox(height: 8),

            // ── 7. Pricing Cards Section ──
            Center(
              child: Column(
                children: [
                  // ── YEARLY SELECTION: Shows ONLY the Yearly Plan Card ──
                  if (_selectedBilling == 'Yearly')
                    YearlyPricingCard(
                      isLoading: _loadingYearly,
                      isCurrentPlan: isYearlyCurrent,
                      onTap: _handleYearlyCheckout,
                    ),

                  // ── FREE SELECTION: Shows Special Offer (14-Day Free Trial) & Free Gift ──
                  if (_selectedBilling == 'Free') ...[
                    SpecialOfferCard(
                      isLoading: _loadingTrial,
                      isSubscribed: subscription?.status == 'active',
                      isLoggedIn: user != null,
                      onTap: _handleStartTrialClick,
                    ),
                    const SizedBox(height: 24),
                    FreeGiftBonusCard(
                      onTap: _handleClaimFreeGift,
                    ),
                  ],

                  // ── MONTHLY SELECTION: Shows Free Gift, Monthly, and Coaching ──
                  if (_selectedBilling == 'Monthly') ...[
                    FreeGiftBonusCard(
                      onTap: _handleClaimFreeGift,
                    ),
                    const SizedBox(height: 24),
                    MonthlyPricingCard(
                      isLoading: _loadingMonthly,
                      isCurrentPlan: isMonthlyCurrent,
                      onTap: _handleMonthlyCheckout,
                    ),
                    const SizedBox(height: 24),
                    CoachingPricingCard(
                      isLoading: _loadingCoaching,
                      isCurrentPlan: isCoachingCurrent,
                      onTap: _handleCoachingCheckout,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Contract / Cancellation Note ──
            Center(
              child: Text(
                'No contracts, cancel anytime. No hidden fees.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 600),
                margin: const EdgeInsets.symmetric(horizontal: 'auto' == 'auto' ? 0 : 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F0909),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  _error!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFFFCA5A5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ── 8. DETAILS: Pricing Questions. (FAQ Accordion Section) ──
            const Center(
              child: PricingFaqSection(),
            ),
          ],
        ),
      ),
    );
  }
}
