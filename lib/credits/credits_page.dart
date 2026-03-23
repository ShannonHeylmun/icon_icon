import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/main.dart';

class Credit {
  final String name;
  final String copyText;
  const Credit({required this.name, required this.copyText});
}

List<Credit> packages = [
  Credit(copyText: "https://flutter.dev/", name: 'flutter'),
  Credit(
    copyText: "https://pub.dev/packages/unicode_emojis",
    name: 'unicode_emojis',
  ),
  Credit(copyText: "https://pub.dev/packages/hugeicons", name: 'hugeicons'),

  Credit(
    copyText: "https://pub.dev/packages/material_design_icons_flutter",
    name: 'material_design_icons_flutter',
  ),
  Credit(
    copyText: "https://pub.dev/packages/material_symbols_icons",
    name: 'material_symbols_icons',
  ),
  Credit(
    copyText: "https://pub.dev/packages/fluentui_system_icons",
    name: 'fluentui_system_icons',
  ),
  Credit(
    copyText: "https://pub.dev/packages/iconoir_flutter",
    name: "iconoir_flutter",
  ),
];

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: creditsColor,
        foregroundColor: Colors.white,
        leadingIcon: creditsIcon,
        titleText: "Credits",
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              "Flutter Packages",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SliverList.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) => ListTile(
              title: Center(child: Text(packages[index].name)),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                HapticFeedback.heavyImpact();
                Clipboard.setData(
                  ClipboardData(text: packages[index].copyText),
                );
              },
              onLongPress: () => Clipboard.setData(
                ClipboardData(text: packages[index].copyText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreditsCard extends StatelessWidget {
  final Credit credit;
  const CreditsCard({super.key, required this.credit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Center(child: Text(credit.name)),
        onLongPress: () => Clipboard.setData(ClipboardData(text: "ToDo")),
      ),
    );
  }
}
