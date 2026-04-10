import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';
import 'package:icon_icon/main.dart';
import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

List<Text> instructions = [
  Text("Tap to Copy Icon Name"),
  Text("Double Tap to Copy Code Point"),
];
List<Text> emojiInstructions = [
  Text("Tap to Copy Emoji"),
  Text("Double Tap to Copy Code Point"),
];

class ResponsiveIcons extends StatelessWidget {
  final log = Logger('MyAwesomeLogger');
  final List<(String, Object)> iconsToShow;

  ResponsiveIcons({super.key, required this.iconsToShow});

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
                                          style: GoogleFonts.notoColorEmoji(
                                            fontSize: 30,
                                          ),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
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
    return switch (o) {
      Emoji() => o.emoji,
      List<List<dynamic>>() => "strokeRounded$s",
      _ => s,
    };
  }

  void copySubtitle(BuildContext context, String s, Object o) {
    HapticFeedback.heavyImpact();
    String? str = listSubtitle((s, o));

    if (str != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }
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
              String mainCopy = mainCopyText(iconData.$2, iconData.$1);
              return ToolTipListCard(
                title: listTitle(iconData),
                subTitle: subTitle,
                leading: listTileLeading(iconData.$2),
                onTap: () => copyEmojiOrName(context, iconData.$1, iconData.$2),
                onDoubleTap: () =>
                    copySubtitle(context, iconData.$1, iconData.$2),
                onLongPress: () => showInfoModal(context, iconData.$2),
                mainCopy: mainCopy,
                iconData: iconData,
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
              String mainCopy = mainCopyText(iconData.$2, iconData.$1);
              String? subTitle = listSubtitle(iconData);
              return ToolTipGridCard(
                title: listTitle(iconData),
                subTitle: subTitle ?? "",
                leading: listTileLeading(iconData.$2),
                onTap: () => copyEmojiOrName(context, iconData.$1, iconData.$2),
                onDoubleTap: () =>
                    copySubtitle(context, iconData.$1, iconData.$2),
                onLongPress: () => showInfoModal(context, iconData.$2),
                mainCopy: mainCopy,
                iconData: iconData,
              );
            },
          );
  }
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
    // case IconDataRounded():
    //   return (iconData.$2 as IconData).codePoint.toString();
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
    case Emoji():
      if (iconData.emoji == "🙂‍↔️" || iconData.emoji == "🙂‍↕️") {
        // Hacky fix for specific emoji
      }
  }
  switch (iconData) {
    // case IconDataRounded():
    //   return Icon(iconData, size: 48);
    case IconData():
      return Icon(iconData, size: 48);
    case List<List<dynamic>>():
      return HugeIcon(icon: iconData);
    case Emoji():
      return Text(
        iconData.emoji,
        // style: TextStyle(fontSize: 30),
        style: GoogleFonts.notoColorEmoji(fontSize: 30),
      );
    case AnimatedIconData():
      return AnimatedIcon(icon: iconData, progress: animation, size: 48);
    case StatelessWidget():
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          PlatformDispatcher.instance.platformBrightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          BlendMode.srcIn,
        ), // Apply a red color filter to the icon
        child: SizedBox(height: 48, width: 48, child: iconData),
      );
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

class ToolTipListCard extends StatelessWidget {
  final String mainCopy;
  final String title;
  final String? subTitle;
  final Widget leading;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final (String, Object) iconData;

  const ToolTipListCard({
    super.key,
    required this.mainCopy,
    required this.title,
    this.subTitle,
    required this.leading,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: subTitle == null
          ? "Tap to copy $mainCopy\nLong Press for skin tones (if available)"
          : "Tap to copy $mainCopy\nDouble Tap to copy $subTitle\nLong Press for skin tones (if available)",
      child: InkWell(
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        onDoubleTap: () => onDoubleTap(),
        child: ListTile(
          leading: listTileLeading(iconData.$2),
          title: Text(listTitle(iconData)),
          subtitle: subTitle == null ? null : Text(subTitle!),
        ),
      ),
    );
  }
}

class ToolTipGridCard extends StatelessWidget {
  final String mainCopy;
  final String title;
  final String? subTitle;
  final Widget leading;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final (String, Object) iconData;

  const ToolTipGridCard({
    super.key,
    required this.mainCopy,
    required this.title,
    this.subTitle,
    required this.leading,
    required this.onTap,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: subTitle == null
          ? "Tap to copy $mainCopy"
          : "Tap to copy $mainCopy\nDouble Tap to copy $subTitle",
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onTap(),
          onLongPress: () => onLongPress(),
          onDoubleTap: () => onDoubleTap(),
          onSecondaryTap: () => onTap(),
          child: GridTile(
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                listTitle((iconData.$1, iconData.$2)),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: category(iconData.$2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
