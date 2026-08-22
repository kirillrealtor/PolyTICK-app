import 'package:flutter/material.dart';

/// Style utilities — exact 1:1 Dart port of `styleUtils.js`.
class StyleUtils {
  StyleUtils._();

  /// Parse size string (e.g. "500K–1M", "$1,001 - $15,000", "< 1K", etc.)
  /// and return classified category: micro, small, medium, large, xl, huge, mega, giga, ultra.
  static String getSizeCategory(String? sizeStr) {
    if (sizeStr == null || sizeStr.isEmpty || sizeStr == '—' || sizeStr == '-') {
      return 'unknown';
    }

    String clean = sizeStr
        .toLowerCase()
        .replaceAll(RegExp(r'[\u2013\u2014]'), '-')
        .replaceAll(',', '')
        .trim();
    final parts = clean.split(RegExp(r'[\s-]+'));

    double parsePart(String part) {
      final numStr = part.replaceAll(RegExp(r'[^0-9.]'), '');
      double val = double.tryParse(numStr) ?? 0;
      if (val == 0) return 0;
      if (part.contains('m')) {
        val *= 1000000;
      } else if (part.contains('k')) {
        val *= 1000;
      }
      return val;
    }

    double maxVal = 0;
    for (final part in parts) {
      final val = parsePart(part);
      if (val > maxVal) {
        maxVal = val;
      }
    }

    if (maxVal <= 0) return 'unknown';
    if (maxVal <= 15000) return 'micro';
    if (maxVal <= 50000) return 'small';
    if (maxVal <= 100000) return 'medium';
    if (maxVal <= 250000) return 'large';
    if (maxVal <= 500000) return 'xl';
    if (maxVal <= 1000000) return 'huge';
    if (maxVal <= 5000000) return 'mega';
    if (maxVal <= 25000000) return 'giga';
    return 'ultra';
  }

  /// Check if a trade amount range upper bound is >= $50,000 (for notifications)
  static bool isTradeAbove50k(String? amountRange) {
    if (amountRange == null) return false;
    final cat = getSizeCategory(amountRange);
    return cat != 'unknown' && cat != 'micro'; // small is 15k-50k, but let's check parse
  }

  /// Returns Badge styling (background, text color, border) for size category.
  static ({Color bg, Color text, Color border, bool isBold}) getSizeBadgeStyle(
    String? sizeStr, {
    bool isDark = true,
  }) {
    final category = getSizeCategory(sizeStr);

    if (category == 'unknown') {
      return (
        bg: isDark ? Colors.white.withAlpha(13) : const Color(0xFFF8FAFC),
        text: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        border: isDark ? Colors.white.withAlpha(13) : const Color(0xFFE2E8F0),
        isBold: false,
      );
    }

    if (isDark) {
      switch (category) {
        case 'micro':
          return (
            bg: const Color(0x1A64748B),
            text: const Color(0xFF94A3B8),
            border: const Color(0x3364748B),
            isBold: false,
          );
        case 'small':
          return (
            bg: const Color(0x33064E3B),
            text: const Color(0xFF34D399),
            border: const Color(0x4D065F46),
            isBold: false,
          );
        case 'medium':
          return (
            bg: const Color(0x1A22C55E),
            text: const Color(0xFF4ADE80),
            border: const Color(0x3322C55E),
            isBold: false,
          );
        case 'large':
          return (
            bg: const Color(0x1AF59E0B),
            text: const Color(0xFFFCD34D),
            border: const Color(0x33F59E0B),
            isBold: false,
          );
        case 'xl':
          return (
            bg: const Color(0x1AF97316),
            text: const Color(0xFFFB923C),
            border: const Color(0x33F97316),
            isBold: false,
          );
        case 'huge':
          return (
            bg: const Color(0x1AF43F5E),
            text: const Color(0xFFFDA4AF),
            border: const Color(0x33F43F5E),
            isBold: false,
          );
        case 'mega':
          return (
            bg: const Color(0x26EF4444),
            text: const Color(0xFFF87171),
            border: const Color(0x4DEF4444),
            isBold: true,
          );
        case 'giga':
          return (
            bg: const Color(0x26D946EF),
            text: const Color(0xFFF0ABFC),
            border: const Color(0x4DD946EF),
            isBold: true,
          );
        case 'ultra':
          return (
            bg: const Color(0x338B5CF6),
            text: const Color(0xFFC4B5FD),
            border: const Color(0x668B5CF6),
            isBold: true,
          );
        default:
          return (
            bg: Colors.white.withAlpha(13),
            text: const Color(0xFF94A3B8),
            border: Colors.white.withAlpha(13),
            isBold: false,
          );
      }
    } else {
      switch (category) {
        case 'micro':
          return (
            bg: const Color(0xFFF8FAFC),
            text: const Color(0xFF475569),
            border: const Color(0xFFCBD5E1),
            isBold: false,
          );
        case 'small':
          return (
            bg: const Color(0xFFF4F4F5),
            text: const Color(0xFF065F46),
            border: const Color(0xFFA7F3D0),
            isBold: false,
          );
        case 'medium':
          return (
            bg: const Color(0xFFECFDF5),
            text: const Color(0xFF065F46),
            border: const Color(0xFF10B981),
            isBold: false,
          );
        case 'large':
          return (
            bg: const Color(0xFFFFFBEB),
            text: const Color(0xFF92400E),
            border: const Color(0xFFF59E0B),
            isBold: false,
          );
        case 'xl':
          return (
            bg: const Color(0xFFFFEDD5),
            text: const Color(0xFF9A3412),
            border: const Color(0xFFF97316),
            isBold: false,
          );
        case 'huge':
          return (
            bg: const Color(0xFFFFF1F2),
            text: const Color(0xFF9F1239),
            border: const Color(0xFFF43F5E),
            isBold: false,
          );
        case 'mega':
          return (
            bg: const Color(0xFFFEF2F2),
            text: const Color(0xFF991B1B),
            border: const Color(0xFFEF4444),
            isBold: true,
          );
        case 'giga':
          return (
            bg: const Color(0xFFFDF4FF),
            text: const Color(0xFF86198F),
            border: const Color(0xFFD946EF),
            isBold: true,
          );
        case 'ultra':
          return (
            bg: const Color(0xFFA78BFA),
            text: const Color(0xFF4C1D95),
            border: const Color(0xFF8B5CF6),
            isBold: true,
          );
        default:
          return (
            bg: const Color(0xFFF8FAFC),
            text: const Color(0xFF64748B),
            border: const Color(0xFFE2E8F0),
            isBold: false,
          );
      }
    }
  }

  /// Format option text representation cleanly.
  static String getOptionBadgeText(
      String? optionType, String? optionStrike, String? optionExpiry) {
    final parts = <String>[];
    if (optionType != null && optionType.isNotEmpty) parts.add(optionType);
    if (optionStrike != null && optionStrike.isNotEmpty) {
      final strikeClean = optionStrike.toLowerCase().contains('strike')
          ? optionStrike
          : 'strike $optionStrike';
      parts.add(strikeClean);
    }
    if (optionExpiry != null && optionExpiry.isNotEmpty) {
      parts.add('($optionExpiry)');
    }
    return parts.isEmpty ? 'Option' : parts.join(' ');
  }
}
