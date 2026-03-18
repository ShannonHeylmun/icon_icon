import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/icons_service.dart';
import 'package:hugeicons_showcase/main.dart' hide Icons;

class HugeIconsLookupPage extends StatelessWidget {
  const HugeIconsLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: HugeIcon(icon: HugeIcons.strokeRoundedHugeicons),
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
        leadingWidth: 42,
        backgroundColor: seedColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
          // Add padding around the search bar
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // Use a Material design search bar
          child: TextField(
            controller: IconsService().searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              // Add a clear button to the search bar
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () => IconsService().searchController.clear(),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: IconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, List<List<dynamic>>)> iconsToShow =
              asyncSnapshot.data ?? [];
          return ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: HugeIcon(
                  icon: iconsToShow[index].$2,
                  size: 48,
                  secondaryColor: Theme.of(context).primaryColor,
                ),
                title: Text(iconsToShow[index].$1),
                onTap: () async {
                  await FlutterClipboard.copy(
                    "HugeIcons.strokeRounded${iconsToShow[index].$1}",
                  );
                },
                onLongPress: () async {
                  await FlutterClipboard.copy(
                    "HugeIcon(icon: HugeIcons.strokeRounded${iconsToShow[index].$1})",
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
