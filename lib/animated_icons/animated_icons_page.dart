import 'package:flutter/material.dart';
import 'package:icon_icon/animated_icons/animated_icons_service.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/main.dart';

class AnimatedIconsPage extends StatefulWidget {
  const AnimatedIconsPage({super.key});

  @override
  State<AnimatedIconsPage> createState() => _AnimatedIconsPageState();
}

class _AnimatedIconsPageState extends State<AnimatedIconsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: animatedIconsColor,
        foregroundColor: animatedIconsColorContrast,
        leadingIcon: Stack(
          children: [
            Positioned(
              top: 8,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                size: 36.0,
                progress: animation,
              ),
            ),
          ],
        ),
        titleText: "Animated Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: AnimatedIconsService().searchController,
      ),
      body: StreamBuilder(
        stream: AnimatedIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, AnimatedIconData)> iconsToShow =
              asyncSnapshot.data ?? [];
          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
