import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/material_icons/material_icons_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MaterialIconsPage extends StatelessWidget {
  const MaterialIconsPage({super.key});

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
          controller: MaterialIconsService().searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            // Add a clear button to the search bar
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Color.fromRGBO(31, 31, 31, 1)),
              onPressed: () => MaterialIconsService().searchController.clear(),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: MaterialIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, IconData?)> iconsToShow = asyncSnapshot.data ?? [];
          return ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(iconsToShow[index].$2, size: 48),
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
