import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PricingBillingToggle extends StatelessWidget {
  final String selectedOption;
  final ValueChanged<String> onOptionChanged;

  static const List<String> options = ['Free', 'Monthly', 'Yearly'];

  const PricingBillingToggle({
    super.key,
    required this.selectedOption,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 56,
        constraints: const BoxConstraints(maxWidth: 380),
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(1000),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double availableWidth = constraints.maxWidth;
            final double tabWidth = availableWidth / options.length;
            final int selectedIndex = options.indexOf(selectedOption).clamp(0, options.length - 1);

            return Stack(
              children: [
                // Smooth animated sliding white pill for active selection
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  left: selectedIndex * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // Row of clickable tab options
                Row(
                  children: options.map((option) {
                    final bool isSelected = option == selectedOption;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onOptionChanged(option),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFF000000)
                                  : const Color(0xFFFFFFFF),
                              letterSpacing: 0.15,
                            ),
                            child: Text(
                              option,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
