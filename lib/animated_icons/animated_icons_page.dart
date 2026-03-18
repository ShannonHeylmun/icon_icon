import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/animated_icons/animated_icons_service.dart';
import 'package:hugeicons_showcase/material_icons/material_icons_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      appBar: AppBar(
        backgroundColor: Color(0xff9f86ff),
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(MdiIcons.materialDesign, size: 36),
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
        leadingWidth: 42,
        title: TextField(
          controller: AnimatedIconsService().searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            // Add a clear button to the search bar
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Color.fromRGBO(31, 31, 31, 1)),
              onPressed: () => AnimatedIconsService().searchController.clear(),
            ),
          ),
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
                  await FlutterClipboard.copy("${iconsToShow[index].$1}");
                },
                onLongPress: () async {
                  await FlutterClipboard.copy("${iconsToShow[index].$2}");
                },
              );
            },
          );
        },
      ),
    );
  }
}
