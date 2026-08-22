import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoliticianAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const PoliticianAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 38,
  });

  static String getPoliticianSlug(String name) {
    if (name.isEmpty) return "";
    return name
        .replaceAll(RegExp(r'^(Hon\.|Dr\.)\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+\((House|Senate)\)$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+(II|III|IV|Jr\.|Jr|Sr\.|Sr)\b', caseSensitive: false), '')
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'(^-|-$)'), '');
  }

  static String getInitials(String name) {
    if (name.isEmpty) return "";
    final clean = name
        .replaceAll(RegExp(r'^(Hon\.|Dr\.)\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+\((House|Senate)\)$', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+(II|III|IV|Jr\.|Jr|Sr\.|Sr)\b', caseSensitive: false), '')
        .trim();
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return clean.isNotEmpty ? clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase() : 'P';
  }

  static const List<List<Color>> _gradients = [
    [Color(0xFF2563EB), Color(0xFF06B6D4)], // blue to cyan
    [Color(0xFF9333EA), Color(0xFFEC4899)], // purple to pink
    [Color(0xFF059669), Color(0xFF14B8A6)], // emerald to teal
    [Color(0xFFEA580C), Color(0xFFF59E0B)], // orange to amber
    [Color(0xFF4F46E5), Color(0xFF7C3AED)], // indigo to violet
    [Color(0xFFE11D48), Color(0xFFF43F5E)], // rose to pink
    [Color(0xFF7C3AED), Color(0xFFD946EF)], // violet to fuchsia
  ];

  static List<Color> _getGradient(String name) {
    if (name.isEmpty) return _gradients[0];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final index = hash.abs() % _gradients.length;
    return _gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final slug = getPoliticianSlug(name);
    final initials = getInitials(name);
    final gradient = _getGradient(name);

    Widget fallbackWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withAlpha(25),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.poppins(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );

    // 1. Try external image URL if available
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withAlpha(25), width: 1),
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildLocalImage(slug, fallbackWidget),
          ),
        ),
      );
    }

    // 2. Try local bundled politician portrait webp
    return _buildLocalImage(slug, fallbackWidget);
  }

  Widget _buildLocalImage(String slug, Widget fallback) {
    if (slug.isEmpty) return fallback;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(25), width: 1),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/politicians/$slug.webp',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        ),
      ),
    );
  }
}
