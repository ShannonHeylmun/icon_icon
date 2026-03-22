import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

List<Text> instructions = [
  Text("Long Press to Copy Emoji/Icon Name"),
  Text("Double Tap to Copy Code Point"),
];

class ResponsiveIcons extends StatelessWidget {
  final List<(String, Object)> iconsToShow;

  const ResponsiveIcons({super.key, required this.iconsToShow});

  Future<void> onTap(BuildContext context, Object object) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: object.runtimeType == Emoji
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (object as Emoji).skinVariations != null
                        ? Wrap(
                            spacing: 20,
                            children: object.skinVariations!.map((variation) {
                              return InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    variation.emoji,
                                    style: TextStyle(fontSize: 32),
                                  ),
                                ),
                                onDoubleTap: () =>
                                    onDoubleTap(object.name, variation),
                                onLongPress: () =>
                                    onLongPress(object.name, variation),
                              );
                            }).toList(),
                          )
                        : SizedBox.shrink(),
                    ...instructions,
                  ],
                )
              : Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: MediaQuery.sizeOf(context).width < 600
                      ? [
                          Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: instructions,
                          ),
                        ]
                      : instructions,
                ),
        );
      },
    );
  }

  Future<void> onLongPress(String s, Object o) async {
    await Clipboard.setData(
      ClipboardData(text: o.runtimeType == Emoji ? (o as Emoji).emoji : s),
    );
  }

  Future<void> onDoubleTap(String s, Object o) async {
    HapticFeedback.heavyImpact();
    await Clipboard.setData(ClipboardData(text: listSubtitle((s, o))));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide < 600
        ? ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              (String, Object) iconData = iconsToShow[index];

              return InkWell(
                onTap: () => onTap(context, iconData.$2),
                onLongPress: () => onLongPress(iconData.$1, iconData.$2),
                onDoubleTap: () => onDoubleTap(iconData.$1, iconData.$2),
                child: ListTile(
                  leading: listTileLeading(iconData.$2),
                  title: Text(iconData.$1),
                  subtitle: Text(listSubtitle(iconData)),
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
              (String, Object) iconData = iconsToShow[index];
              return Card(
                child: InkWell(
                  onTap: () => onTap(context, iconData.$2),
                  onLongPress: () => onLongPress(iconData.$1, iconData.$2),
                  onDoubleTap: () => onDoubleTap(iconData.$1, iconData.$2),
                  child: GridTile(
                    header: Text(iconData.$1, textAlign: TextAlign.center),
                    footer: Text(
                      listSubtitle(iconData),
                      textAlign: TextAlign.center,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [listTileLeading(iconData.$2)],
                    ),
                  ),
                ),
              );
            },
          );
  }

  String listTitle((String, Object) iconData) {
    return iconData.$1;
  }

  String listSubtitle((String, Object) iconData) {
    print(iconData.$2.runtimeType);
    String typeString = iconData.$2.runtimeType.toString();

    return switch (typeString) {
      "IconDataRounded" => (iconData.$2 as IconData).codePoint.toString(),
      "IconData" => (iconData.$2 as IconData).codePoint.toString(),
      "List<List<dynamic>>" => "HugeIcons.strokeRounded${iconData.$1}",
      "_MdiIconData" => "${(iconData.$2 as IconData).codePoint}",
      "Emoji" => (iconData.$2 as Emoji).unified,
      _ => "Error",
    };
  }

  Widget listTileLeading(Object iconData) {
    String typeString = iconData.runtimeType.toString();
    return switch (typeString) {
      "IconDataRounded" => Icon(iconData as IconData, size: 48),
      "IconData" => Icon(iconData as IconData, size: 48),
      "List<List<dynamic>>" => HugeIcon(icon: iconData as List<List<dynamic>>),
      "_MdiIconData" => Icon(iconData as IconData),
      "Emoji" => Text(
        (iconData as Emoji).emoji,
        style: TextStyle(fontSize: 30),
      ),
      _ => Icon(Icons.error),
    };
  }
}
