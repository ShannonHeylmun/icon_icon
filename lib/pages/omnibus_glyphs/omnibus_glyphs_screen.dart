import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/pages/omnibus_glyphs/omnibus_glyphs_service.dart';

class OmnibusGlyphsScreen extends StatelessWidget {
  const OmnibusGlyphsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: omnibusGlyphsColor,
        foregroundColor: omnibusGlyphsColorContrast,
        leadingIcon: Stack(
          children: [
            Positioned(
              top: 8,
              child: Text(
                "❄️",
                style: GoogleFonts.notoEmoji(
                  color: omnibusGlyphsColorContrast,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
        titleText: "Search All",
      ),
      body: const Center(
        child: Text('Omnibus Glyphs Search Screen Coming Soon!'),
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: OmnibusGlyphsService().searchController,
      ),
    );
  }
}
