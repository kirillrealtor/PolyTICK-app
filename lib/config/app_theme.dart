import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PolyTICK Design System & Theme
/// Aligned with the Figma stylesheet and brand guidelines.
class AppTheme {
  // ── Brand Colors (Figma palette) ──
  static const Color polyBlue = Color(0xFF51A2FF);       // Primary accent blue
  static const Color tickRed = Color(0xFFC60C30);        // Primary accent red / crimson
  static const Color activeBlue = Color(0xFF51A2FF);      // Accent Blue
  static const Color accentRed = Color(0xFFC60C30);       // Accent Red
  static const Color successGreen = Color(0xFF00E676);    // Live badge & verified
  static const Color warningOrange = Color(0xFFFEB40D);   // Yellow/Amber (#FEB40D)
  static const Color warningAmber = Color(0xFFFEB40D);    // Alias
  static const Color dangerRed = Color(0xFFEF4444);       // Errors
  static const Color errorRed = Color(0xFFEF4444);        // Alias

  // ── Surface & Background Colors ──
  static const Color bgDarkest = Color(0xFF1E1E1E);      // Main dark background / Footer
  static const Color bgDark = Color(0xFF1E1E1E);         // Dark cards / U-shape
  static const Color bgMedium = Color(0xFF4D4C4C);       // FAQ accordion bars
  static const Color bgLight = Color(0xFFF8FAFC);        // Light background
  static const Color bgCream = Color(0xFFF8FAFC);        // Light cream background
  static const Color cardDark = Color(0xFF1E1E1E);       // Card dark
  static const Color cardWhite = Colors.white;           // White card surface
  static const Color footerDark = Color(0xFF1E1E1E);     // Footer background

  // ── Text Colors ──
  static const Color textPrimary = Color(0xFF000000);    // Headings
  static const Color textSecondary = Color(0xFF1E293B);  // Subheadings
  static const Color textMuted = Color(0xFF64748B);      // Captions
  static const Color textLight = Color(0xFFFFFFFF);      // White text on dark
  static const Color textWhite = Color(0xFFFFFFFF);      // Alias for white text

  // ── Auth Specific ──
  static const Color authBg = Color(0xFFF8FAFC);
  static const Color authCardBg = Colors.white;
  static const Color authBorder = Color(0xFFE2E8F0);
  static const Color authButtonBg = Color(0xFF1E1E1E);
  static const Color authButtonDisabled = Color(0xFF94A3B8);
  static const Color errorBannerBg = Color(0xFFFEF2F2);
  static const Color errorBannerBorder = Color(0xFFFECACA);
  static const Color errorBannerText = Color(0xFFDC2626);
  static const Color warmBannerBg = Color(0xFFFFFBEB);
  static const Color warmBannerBorder = Color(0xFFFDE68A);
  static const Color warmBannerText = Color(0xFF92400E);

  // ── Typography Helpers ──
  static TextStyle poppins({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = textPrimary,
    FontStyle? fontStyle,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle inter({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = textPrimary,
    FontStyle? fontStyle,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle allura({
    double fontSize = 32,
    Color color = textPrimary,
  }) {
    return GoogleFonts.allura(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle hedvigSerif({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color color = textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDarkest,
      primaryColor: activeBlue,
      colorScheme: const ColorScheme.dark(
        primary: activeBlue,
        secondary: accentRed,
        surface: cardDark,
        error: dangerRed,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withAlpha(26)),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: activeBlue,
      colorScheme: const ColorScheme.light(
        primary: activeBlue,
        secondary: accentRed,
        surface: Colors.white,
        error: dangerRed,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
