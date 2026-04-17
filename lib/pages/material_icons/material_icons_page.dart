import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/pages/material_icons/material_icons_service.dart';
import 'package:icon_icon/services/icon_font_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MaterialIconsPage extends StatefulWidget {
  const MaterialIconsPage({super.key});

  @override
  State<MaterialIconsPage> createState() => _MaterialIconsPageState();
}

class _MaterialIconsPageState extends State<MaterialIconsPage> {
  bool _fontLoaded = false;

  @override
  void initState() {
    super.initState();
    IconFontService.loadMaterialDesignIcons().then((_) {
      if (mounted) setState(() => _fontLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: materialIconsColor,
        foregroundColor: materialIconsColorContrast,
        titleText: "Material Icons",
        leadingIcon: Icon(
          _fontLoaded ? MdiIcons.snowflake : Icons.grid_view,
          size: 36,
        ),
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: MaterialIconsService().searchController,
      ),
      body: _fontLoaded
          ? StreamBuilder(
              stream: MaterialIconsService().refinedListStream,
              builder: (context, asyncSnapshot) {
                List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
                return ResponsiveIcons(iconsToShow: iconsToShow);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
