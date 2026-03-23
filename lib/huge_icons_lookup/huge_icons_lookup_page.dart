import 'package:flutter/material.dart';

import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/huge_icons_lookup/icons_service.dart';
import 'package:icon_icon/main.dart';

class HugeIconsLookupPage extends StatelessWidget {
  const HugeIconsLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leadingIcon: hugeIcon,
        backgroundColor: seedColor,
        titleText: "Huge Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: IconsService().searchController,
      ),
      body: StreamBuilder(
        stream: IconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, List<List<dynamic>>)> iconsToShow =
              asyncSnapshot.data ?? [];
          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
