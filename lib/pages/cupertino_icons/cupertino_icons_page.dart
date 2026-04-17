import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/pages/cupertino_icons/cupertino_icons_service.dart';
import 'package:icon_icon/services/icon_font_service.dart';

class CupertinoIconsPage extends StatefulWidget {
  const CupertinoIconsPage({super.key});

  @override
  State<CupertinoIconsPage> createState() => _CupertinoIconsPageState();
}

class _CupertinoIconsPageState extends State<CupertinoIconsPage> {
  bool _fontLoaded = false;

  @override
  void initState() {
    super.initState();
    IconFontService.loadCupertinoIcons().then((_) {
      if (mounted) setState(() => _fontLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: cupertinoIconsColor,
        leadingIcon: Icon(
          _fontLoaded ? CupertinoIcons.snow : Icons.ac_unit,
          size: 28,
        ),
        foregroundColor: cupertinoIconsColorContrast,
        paddingLeft: 0,
        titleText: "Cupertino Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: CupertinoIconsService().searchController,
      ),
      body: _fontLoaded
          ? StreamBuilder(
              stream: CupertinoIconsService().refinedListStream,
              builder: (context, asyncSnapshot) {
                List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
                return ResponsiveIcons(iconsToShow: iconsToShow);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
