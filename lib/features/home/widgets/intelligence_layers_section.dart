import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class IntelligenceLayersSection extends StatelessWidget {
  const IntelligenceLayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 36.0,
        bottom: 48.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Title ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.15,
                ),
                children: [
                  const TextSpan(text: 'The 8 Intelligence '),
                  TextSpan(
                    text: 'Layers.',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Header Subtitle ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Everyone watches one data source. We built the machine that reads all of them at once — so a single trade stops being a headline and starts being a signal.',
              style: GoogleFonts.poppins(
                fontSize: 13.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Full-Width 8 Layers SVG Graphic ──
          SizedBox(
            width: double.infinity,
            child: SvgPicture.asset(
              'assets/images/8-layers-polytickimage.svg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              placeholderBuilder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(40.0),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
