import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/material_icons/material_icons_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MaterialIconsPage extends StatelessWidget {
  const MaterialIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        color: Color(0xff9f86ff),
        searchController: MaterialIconsService().searchController,
        leadingIcon: Icon(MdiIcons.materialDesign, size: 30),
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
                subtitle: Text("${iconsToShow[index].$2}"),
                onTap: () async {
                  await FlutterClipboard.copy(iconsToShow[index].$1);
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
