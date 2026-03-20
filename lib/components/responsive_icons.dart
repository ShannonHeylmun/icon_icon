import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ResponsiveIcons extends StatelessWidget {
  final List<(String, IconData)> iconsToShow;
  final GestureLongPressCallback onLongPress;
  final GestureDoubleTapCallback? onDoubleTap;

  const ResponsiveIcons({
    super.key,
    required this.iconsToShow,
    required this.onLongPress,
    this.onDoubleTap,
  });

  Future<void> onTap(BuildContext context, index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: MediaQuery.sizeOf(context).shortestSide > 400
              ? [
                  Column(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Double Tap to Copy Code Point"),
                      Text("Long Press to Copy Name"),
                    ],
                  ),
                ]
              : [
                  Text("Double Tap to Copy Code Point"),
                  Text("Long Press to Copy Name"),
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
                onLongPress: onLongPress,
                onDoubleTap: onDoubleTap,
                child: ListTile(
                  leading: Icon(iconsToShow[index].$2),
                  title: Text(iconsToShow[index].$1),
                  dense: true,
                  // subtitle: Text(
                  //   iconsToShow.values.toString()[index].runes.toString(),
                  // ),
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
                  onLongPress: onLongPress,
                  onDoubleTap: onDoubleTap,
                  child: GridTile(
                    header: Text(
                      iconsToShow[index].$1,
                      textAlign: TextAlign.center,
                    ),
                    // footer: Text(
                    //   iconsToShow.values
                    //       .toList()[index]
                    //       .codePoint
                    //       .toRadixString(16)
                    //       .toUpperCase(),
                    //   textAlign: TextAlign.center,
                    // ),
                    child: Icon(iconsToShow[index].$2, size: 48),
                  ),
                ),
              );
            },
          );
  }
}
