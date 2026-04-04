import 'package:flutter/material.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/main.dart';
import 'package:icon_icon/material_icons/material_icons_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MaterialIconsPage extends StatelessWidget {
  const MaterialIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: materialIconsColor,
        foregroundColor: materialIconsColorContrast,
        titleText: "Material Icons",
        leadingIcon: Icon(MdiIcons.snowflake, size: 36),
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: MaterialIconsService().searchController,
      ),
      body: StreamBuilder(
        stream: MaterialIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
