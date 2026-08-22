import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:polytick_app/core/auth/auth_provider.dart';
import 'package:polytick_app/core/services/payment_service.dart';

class CoachingSuccessScreen extends ConsumerStatefulWidget {
  final String? sessionId;

  const CoachingSuccessScreen({
    super.key,
    this.sessionId,
  });

  @override
  ConsumerState<CoachingSuccessScreen> createState() =>
      _CoachingSuccessScreenState();
}

class _CoachingSuccessScreenState extends ConsumerState<CoachingSuccessScreen> {
  final ScrollController _dateScrollController = ScrollController();

  String? _checkoutEmail;
  String? _checkoutName;
  bool _loadingConfig = true;
  bool _loadingBooked = true;
  bool _submittingBooking = false;
  bool _showBookedOverlay = false;
  String? _error;

  List<DateTime> _availableDates = [];
  DateTime? _selectedDate;
  String? _selectedTimeSlot; // e.g. "10:00"
  List<Map<String, dynamic>> _bookedSlots = [];

  static const List<_TimeSlotData> _timeSlots = [
    _TimeSlotData(value: "09:00", label: "9:00 AM"),
    _TimeSlotData(value: "10:00", label: "10:00 AM"),
    _TimeSlotData(value: "11:00", label: "11:00 AM"),
    _TimeSlotData(value: "12:00", label: "12:00 PM"),
    _TimeSlotData(value: "13:00", label: "1:00 PM"),
    _TimeSlotData(value: "14:00", label: "2:00 PM"),
    _TimeSlotData(value: "15:00", label: "3:00 PM"),
    _TimeSlotData(value: "16:00", label: "4:00 PM"),
  ];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    _generateWorkdays();

    // 1. Fetch Session Email
    if (widget.sessionId != null && widget.sessionId!.isNotEmpty) {
      try {
        final sessionData = await PaymentService.instance.getCheckoutEmail(widget.sessionId!);
        if (sessionData != null) {
          _checkoutEmail = sessionData['email'] as String?;
          _checkoutName = sessionData['name'] as String?;
        }
      } catch (e) {
        debugPrint('Fetch checkout session data failed: $e');
      } finally {
        if (mounted) setState(() => _loadingConfig = false);
      }
    } else {
      if (mounted) setState(() => _loadingConfig = false);
    }

    // 2. Fetch Booked Slots
    try {
      final slots = await PaymentService.instance.getBookedSlots();
      if (mounted) {
        setState(() {
          _bookedSlots = slots;
          _loadingBooked = false;
        });
      }
    } catch (e) {
      debugPrint('Fetch booked slots failed: $e');
      if (mounted) setState(() => _loadingBooked = false);
    }
  }

  void _generateWorkdays() {
    final List<DateTime> dates = [];
    DateTime current = DateTime.now();

    DateTime dateToCheck = current;
    while (dates.length < 14) {
      dateToCheck = dateToCheck.add(const Duration(days: 1));
      // Exclude Saturday (6) and Sunday (7)
      if (dateToCheck.weekday != DateTime.saturday &&
          dateToCheck.weekday != DateTime.sunday) {
        dates.add(DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day));
      }
    }

    setState(() {
      _availableDates = dates;
      if (dates.isNotEmpty) {
        _selectedDate = dates.first;
      }
    });
  }

  String _formatDateKey(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  bool _isSlotBooked(DateTime date, String timeValue) {
    final dateKey = _formatDateKey(date);
    return _bookedSlots.any((b) =>
        b['booking_date'] == dateKey && b['booking_time'] == timeValue);
  }

  Future<void> _handleBookSession() async {
    if (_selectedDate == null || _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date and time slot.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() {
      _submittingBooking = true;
      _error = null;
    });

    try {
      final dateKey = _formatDateKey(_selectedDate);
      final res = await PaymentService.instance.bookCoachingSession(
        bookingDate: dateKey,
        bookingTime: _selectedTimeSlot!,
        sessionId: widget.sessionId,
      );

      if (res['status'] == 'success' || res['message'] != null) {
        // Activate subscription in background if user logged in
        final user = ref.read(authProvider).currentUser;
        if (user != null && widget.sessionId != null) {
          ref.read(authProvider.notifier).activateSubscription(
                user.email,
                widget.sessionId!,
              );
        }

        if (mounted) {
          setState(() {
            _showBookedOverlay = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceAll('Exception: ', ''));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error ?? 'Failed to book session'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submittingBooking = false);
    }
  }

  void _doFinalNavigate() {
    context.go('/dashboard/congress-trades');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final displayEmail = user?.email ?? _checkoutEmail ?? 'Account';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background ambient blue glow
          Center(
            child: Container(
              width: 700,
              height: 700,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF2563EB).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: (_loadingConfig || _loadingBooked)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Retrieving available slots...',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: _showBookedOverlay
                            ? _buildConfirmedOverlay()
                            : _buildSchedulerForm(displayEmail),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmedOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                blurRadius: 36,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 48,
              color: Color(0xFF60A5FA),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Session Confirmed!',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          "You are all set for your 1-on-1 Strategy Session. We've sent a calendar invite to your inbox.",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFE5E7EB),
            height: 1.45,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Please be on time, as your session will start exactly at your selected slot. Until then, you can explore your dashboard.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _doFinalNavigate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              elevation: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Explore Your Dashboard',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSchedulerForm(String displayEmail) {
    return Column(
      children: [
        // Top Icon & Header
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.check_rounded,
              size: 36,
              color: Color(0xFF60A5FA),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Payment Successful!',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Welcome to Elite 1-on-1 Coaching! Let's get you set up.",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFE5E7EB),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Please complete your booking below to finish setting up your account.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // Booking Card Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D11),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Title
              Center(
                child: Column(
                  children: [
                    Text(
                      'BOOK YOUR FIRST SESSION',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose a date and hourly slot below. All times are hosted in the founder's local timezone: US/Eastern Time (Virginia Timezone).",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9CA3AF),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Booking Account Info Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOOKING ACCOUNT',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          _checkoutName != null && _checkoutName!.isNotEmpty
                              ? '$_checkoutName ($displayEmail)'
                              : displayEmail,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '1-on-1 Included',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF60A5FA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 1. Select Date Header
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '1. SELECT DATE',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Horizontal Date Picker
              SizedBox(
                height: 84,
                child: ListView.separated(
                  controller: _dateScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableDates.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final date = _availableDates[index];
                    final bool isSelected = _selectedDate != null &&
                        _formatDateKey(_selectedDate) == _formatDateKey(date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _selectedTimeSlot = null;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 76,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB).withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : Colors.white.withValues(alpha: 0.08),
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date).toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              date.day.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            Text(
                              DateFormat('MMM').format(date).toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 2. Select Time Header
              if (_selectedDate != null) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '2. SELECT TIME (US/EASTERN TIME)',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Time Slots Grid
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _timeSlots.map((slot) {
                    final isBooked = _isSlotBooked(_selectedDate!, slot.value);
                    final isSelected = _selectedTimeSlot == slot.value;

                    return GestureDetector(
                      onTap: isBooked
                          ? null
                          : () {
                              setState(() => _selectedTimeSlot = slot.value);
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isBooked
                              ? Colors.white.withValues(alpha: 0.02)
                              : isSelected
                                  ? const Color(0xFF2563EB)
                                  : Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isBooked
                                ? Colors.transparent
                                : isSelected
                                    ? const Color(0xFF3B82F6)
                                    : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          isBooked ? '${slot.label} (Booked)' : slot.label,
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isBooked
                                ? const Color(0xFF4B5563)
                                : isSelected
                                    ? Colors.white
                                    : const Color(0xFFD1D5DB),
                            decoration: isBooked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Booking Button Action
              if (_selectedDate != null && _selectedTimeSlot != null) ...[
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submittingBooking ? null : _handleBookSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: _submittingBooking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_rounded, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Confirm Booking for ${DateFormat('MMM d').format(_selectedDate!)} at ${_timeSlots.firstWhere((s) => s.value == _selectedTimeSlot).label}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Skip to Dashboard
        TextButton(
          onPressed: _doFinalNavigate,
          child: Text(
            'Skip to Dashboard →',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeSlotData {
  final String value;
  final String label;

  const _TimeSlotData({
    required this.value,
    required this.label,
  });
}
