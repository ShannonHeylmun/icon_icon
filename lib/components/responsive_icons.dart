import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResponsiveIcons extends StatelessWidget {
  final List<(String, IconData)> iconsToShow;

  const ResponsiveIcons({super.key, required this.iconsToShow});

  Future<void> onTap(BuildContext context, index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: MediaQuery.sizeOf(context).width < 600
              ? [
                  Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Long Press to Copy Emoji/Icon Name"),
                      Text("Double Tap to Copy Code Point"),
                    ],
                  ),
                ]
              : [
                  Text("Long Press to Copy Emoji/Icon Name"),
                  Text("Double Tap to Copy Code Point"),
                ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide < 600
        ? ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => onTap(context, index),
                onLongPress: () async {
                  await Clipboard.setData(
                    ClipboardData(text: iconsToShow[index].$1),
                  );
                },
                onDoubleTap: () async {
                  HapticFeedback.heavyImpact();
                  await Clipboard.setData(
                    ClipboardData(
                      text: iconsToShow[index].$2.codePoint.toString(),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(iconsToShow[index].$2, size: 48),
                  title: Text(iconsToShow[index].$1),
                  subtitle: Text(iconsToShow[index].$2.codePoint.toString()),
                ),
              );
            },
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
            ),
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () => onTap(context, index),
                  onLongPress: () async {
                    await Clipboard.setData(
                      ClipboardData(text: iconsToShow[index].$1),
                    );
                  },
                  onDoubleTap: () async {
                    HapticFeedback.heavyImpact();
                    await Clipboard.setData(
                      ClipboardData(
                        text: iconsToShow[index].$2.codePoint.toString(),
                      ),
                    );
                  },
                  child: GridTile(
                    header: Text(
                      iconsToShow[index].$1,
                      textAlign: TextAlign.center,
                    ),
                    footer: Text(
                      iconsToShow[index].$2.codePoint
                          .toString()
                          // .toRadixString(16)
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(iconsToShow[index].$2, size: 48)],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
