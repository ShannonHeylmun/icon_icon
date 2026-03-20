import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/icons_service.dart';
import 'package:hugeicons_showcase/main.dart';

class HugeIconsLookupPage extends StatelessWidget {
  const HugeIconsLookupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leadingIcon: HugeIcon(icon: HugeIcons.strokeRoundedSnow),
        color: seedColor,
        titleText: "Huge Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: IconsService().searchController,
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
                subtitle: Text(
                  "HugeIcons.strokeRounded${iconsToShow[index].$1}",
                ),
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
