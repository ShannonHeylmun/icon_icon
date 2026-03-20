import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/animated_icons/animated_icons_service.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';

class AnimatedIconsPage extends StatefulWidget {
  const AnimatedIconsPage({super.key});

  @override
  State<AnimatedIconsPage> createState() => _AnimatedIconsPageState();
}

class _AnimatedIconsPageState extends State<AnimatedIconsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    // TODO: implement initState

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
        color: Color(0xff9f86ff),
        searchController: AnimatedIconsService().searchController,
        leadingIcon: AnimatedIcon(
          icon: AnimatedIcons.search_ellipsis,
          size: 36.0,
          progress: animation,
        ),
      ),
      body: StreamBuilder(
        stream: AnimatedIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, AnimatedIconData)> iconsToShow =
              asyncSnapshot.data ?? [];
          return ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: AnimatedIcon(
                  icon: iconsToShow[index].$2,
                  size: 48,
                  progress: animation,
                ),
                title: Text(iconsToShow[index].$1.toString()),
                onTap: () async {
                  await FlutterClipboard.copy(iconsToShow[index].$1);
                },
                onLongPress: () async {
                  await FlutterClipboard.copy(
                    "AnimatedIcon.${iconsToShow[index].$1}",
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
