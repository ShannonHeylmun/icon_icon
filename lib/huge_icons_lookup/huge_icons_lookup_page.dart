import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/components/responsive_icons.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/icons_service.dart';
import 'package:hugeicons_showcase/main.dart';

class HugeIconsLookupPage extends StatelessWidget {
  const HugeIconsLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leadingIcon: HugeIcon(icon: HugeIcons.strokeRoundedSnow),
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
