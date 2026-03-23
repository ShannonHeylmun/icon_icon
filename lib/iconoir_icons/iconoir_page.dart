import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/components/responsive_icons.dart';
import 'package:hugeicons_showcase/iconoir_icons/iconoir_service.dart';
import 'package:hugeicons_showcase/main.dart';

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
