import 'package:flutter/material.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/iconoir_icons/iconoir_service.dart';
import 'package:icon_icon/main.dart';

class IconoirPage extends StatelessWidget {
  const IconoirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leadingIcon: iconoirIcon,
        titleText: 'Iconoir',
        backgroundColor: iconoirColor,
        foregroundColor: iconnoirColorContrast,
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: IconoirService().searchController,
      ),
      body: StreamBuilder(
        stream: IconoirService().refinedListStream,
        builder: (context, asyncSnapshot) {
          return ResponsiveIcons(iconsToShow: asyncSnapshot.data ?? []);
        },
      ),
    );
  }
}
