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

  Future<void> showInfoModal(BuildContext context, Object object) {
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
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: 400,
                                maxHeight: (object).skinVariations!.length <= 5
                                    ? 100
                                    : 400,
                              ),
                              child: GridView.builder(
                                itemCount: object.skinVariations!.length,
                                itemBuilder: (c, i) {
                                  Emoji variation = object.skinVariations![i];
                                  return InkWell(
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8.0),
                                      child: Center(
                                        child: Text(
                                          variation.emoji,
                                          style: TextStyle(fontSize: 32),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    onDoubleTap: () => copySubtitle(
                                      context,
                                      object.name,
                                      variation,
                                    ),
                                    onTap: () => copyEmojiOrName(
                                      context,
                                      object.name,
                                      variation,
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                    ),
                              ),
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
                              spacing: 20,
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

  void copyEmojiOrName(BuildContext context, String s, Object o) {
    String copyText = mainCopyText(o, s);
    try {
      log.info("Attempting to copy $copyText");
      Clipboard.setData(ClipboardData(text: copyText)).then((val) {
        final snackBar = SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Copied $copyText to your clipboard'),
          persist: false,
          showCloseIcon: true,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } catch (e) {
      log.shout(e);
    }
  }

  String mainCopyText(Object o, String s) {
    if (o.runtimeType == Emoji) {
      log.info("Emoji short names: ${(o as Emoji).shortNames.toString()}");
      log.info("Emoji subcategory: ${(o).subcategory}");
      log.info("Emoji texts: ${(o).texts.toString()}");
    }
    return switch (o) {
      Emoji() => o.emoji,
      List<List<dynamic>>() => "strokeRounded$s",
      _ => s,
    };
  }

  void copySubtitle(BuildContext context, String s, Object o) {
    HapticFeedback.heavyImpact();
    String? str = listSubtitle((s, o));

    log.info("Double Tap to copy $str");
    if (str != null) {
      try {
        Clipboard.setData(ClipboardData(text: str)).then((val) {
          final snackBar = SnackBar(
            duration: const Duration(seconds: 2),
            content: Text('Copied $str to your clipboard'),
            persist: false,
            showCloseIcon: true,
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
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
                onTap: () => copyEmojiOrName(context, iconData.$1, iconData.$2),
                onLongPress: () => showInfoModal(context, iconData.$2),
                onDoubleTap: () =>
                    copySubtitle(context, iconData.$1, iconData.$2),
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
              maxCrossAxisExtent: 256,
            ),
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              (String, Object) iconData = iconsToShow[index];
              return Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () =>
                      copyEmojiOrName(context, iconData.$1, iconData.$2),
                  onLongPress: () => showInfoModal(context, iconData.$2),
                  onDoubleTap: () =>
                      copySubtitle(context, iconData.$1, iconData.$2),
                  onSecondaryTap: () =>
                      copyEmojiOrName(context, iconData.$1, iconData.$2),
                  child: GridTile(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PreventOrphanText(
                            iconData.$1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          children: [
                            listTileLeading(iconData.$2),
                            listSubtitle(iconData) == null
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      listSubtitle(iconData)!,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: category(iconData.$2),
                        ),
                      ],
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
        return Text(iconData.emoji, style: TextStyle(fontSize: 30));
      case AnimatedIconData():
        return AnimatedIcon(icon: iconData, progress: animation!, size: 48);
      case StatelessWidget():
        return iconData;
      case _:
        return Icon(Icons.error);
    }
  }

  Widget category(Object $2) {
    switch ($2) {
      case Emoji():
        return Text($2.category.description, textAlign: TextAlign.center);
      case _:
        return SizedBox.shrink();
    }
  }
}
