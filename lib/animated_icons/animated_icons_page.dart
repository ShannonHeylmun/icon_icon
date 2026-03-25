import 'package:flutter/material.dart';
import 'package:icon_icon/animated_icons/animated_icons_service.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/main.dart';

late Animation<double> animation;

class AnimatedIconsPage extends StatefulWidget {
  const AnimatedIconsPage({super.key});

  @override
  State<AnimatedIconsPage> createState() => _AnimatedIconsPageState();
}

class _AnimatedIconsPageState extends State<AnimatedIconsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward()
          ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: animatedIconsColor,
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
          return ResponsiveIcons(
            iconsToShow: iconsToShow,
            animation: animation,
          );
        },
      ),
    );
  }
}
