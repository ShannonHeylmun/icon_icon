import 'package:flutter/material.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';

import 'package:icon_icon/cupertino_icons/cupertino_icons_service.dart';
import 'package:icon_icon/main.dart';

class CupertinoIconsPage extends StatelessWidget {
  const CupertinoIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: cupertinoIconsColor,
        leadingIcon: Icon(cupertinoIconSnow, size: 28),
        foregroundColor: cupertinoIconsColorContrast,
        paddingLeft: 0,
        titleText: "Cupertino Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: CupertinoIconsService().searchController,
      ),
      body: StreamBuilder(
        stream: CupertinoIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];

          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
