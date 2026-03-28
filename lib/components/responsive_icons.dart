import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

List<Text> instructions = [
  Text("Long Press to Copy Icon Name"),
  Text("Double Tap to Copy Code Point"),
];
List<Text> emojiInstructions = [
  Text("Long Press to Copy Emoji"),
  Text("Double Tap to Copy Code Point"),
];

class ResponsiveIcons extends StatelessWidget {
  final log = Logger('MyAwesomeLogger');
  final List<(String, Object)> iconsToShow;
  final Animation<double>? animation;

  ResponsiveIcons({super.key, required this.iconsToShow, this.animation});

  Future<void> onTap(BuildContext context, Object object) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
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
                                  onSecondaryTap: () =>
                                      onLongPress(object.name, variation),
                                );
                              }).toList(),
                            )
                          : SizedBox.shrink(),
                      ...emojiInstructions,
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
          ),
        );
      },
    );
  }

  void onLongPress(String s, Object o) {
    log.info("Long Press");
    String copyText = switch (o) {
      Emoji() => o.emoji,
      List<List<dynamic>>() => "strokeRounded$s",
      _ => s,
    };
    try {
      log.info("Attempting to copy $copyText");
      Clipboard.setData(ClipboardData(text: copyText));
      log.info("copied $copyText");
    } catch (e) {
      log.shout(e);
    }
  }

  void onDoubleTap(String s, Object o) {
    HapticFeedback.heavyImpact();
    String? str = listSubtitle((s, o));

    log.info("Double Tap to copy $str");
    if (str != null) {
      try {
        Clipboard.setData(ClipboardData(text: str));
        log.info("copied $str");
      } catch (e) {
        log.shout(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.sizeOf(context).shortestSide < 600
        ? ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              (String, Object) iconData = iconsToShow[index];
              String? subTitle = listSubtitle(iconData);
              return InkWell(
                onTap: () => onTap(context, iconData.$2),
                onLongPress: () => onLongPress(iconData.$1, iconData.$2),
                onSecondaryTap: () => onLongPress(iconData.$1, iconData.$2),
                onDoubleTap: () => onDoubleTap(iconData.$1, iconData.$2),
                child: ListTile(
                  leading: listTileLeading(iconData.$2),
                  title: PreventOrphanText(listTitle(iconData)),
                  subtitle: subTitle == null ? null : Text(subTitle),
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
              String? footerText = listSubtitle(iconData);
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () => onTap(context, iconData.$2),
                  onLongPress: () => onLongPress(iconData.$1, iconData.$2),
                  onDoubleTap: () => onDoubleTap(iconData.$1, iconData.$2),
                  onSecondaryTap: () => onLongPress(iconData.$1, iconData.$2),
                  child: GridTile(
                    header: PreventOrphanText(
                      iconData.$1,
                      textAlign: TextAlign.center,
                    ),
                    footer: footerText == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectableText(
                              footerText,
                              textAlign: TextAlign.center,
                            ),
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
    switch (iconData.$2) {
      case List<List<dynamic>>():
        return "strokeRounded${iconData.$1}";
      case _:
        return iconData.$1;
    }
  }

  String? listSubtitle((String, Object) iconData) {
    switch (iconData.$2) {
      case IconDataRounded():
        return (iconData.$2 as IconData).codePoint.toString();
      case IconData():
        return (iconData.$2 as IconData).codePoint.toString();
      case List<List<dynamic>>():
        return "HugeIcons.strokeRounded${iconData.$1}";
      case Emoji():
        return (iconData.$2 as Emoji).unified;
      case AnimatedIconData():
        return null;
      case StatelessWidget():
        return null;
      case _:
        return "Error";
    }
  }

  Widget listTileLeading(Object iconData) {
    switch (iconData) {
      case IconDataRounded():
        return Icon(iconData, size: 48);
      case IconData():
        return Icon(iconData, size: 48);
      case List<List<dynamic>>():
        return HugeIcon(icon: iconData);
      case Emoji():
        return SelectableText(iconData.emoji, style: TextStyle(fontSize: 30));
      case AnimatedIconData():
        return AnimatedIcon(icon: iconData, progress: animation!, size: 48);
      case StatelessWidget():
        return iconData;
      case _:
        return Icon(Icons.error);
    }
  }
}
