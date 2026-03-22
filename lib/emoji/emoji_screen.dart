import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/emoji/emoji_service.dart';
import 'package:hugeicons_showcase/main.dart';
import 'package:unicode_emojis/unicode_emojis.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';

GlobalKey emojiVariantsKey = GlobalKey(debugLabel: "emojiVariantsKey");

class EmojiScreen extends StatelessWidget {
  const EmojiScreen({super.key});

  Future<void> onTap(BuildContext context, Emoji emoji) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            emoji.skinVariations != null
                ? Wrap(
                    spacing: 20,
                    children: emoji.skinVariations!.map((variation) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            variation.emoji,
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        onDoubleTap: () async {
                          HapticFeedback.heavyImpact();
                          await Clipboard.setData(
                            ClipboardData(text: variation.emoji),
                          );
                        },
                        onLongPress: () async {
                          await Clipboard.setData(
                            ClipboardData(text: variation.unified),
                          );
                        },
                      );
                    }).toList(),
                  )
                : SizedBox.shrink(),
            Text("Double Tap to Copy Emoji"),
            Text("Long Press to Copy Code Point"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: emojiVariantsKey,
      appBar: CustomAppBar(
        context,
        backgroundColor: emojiColor,
        leadingIcon: Text(
          UnicodeEmojis.search("snowflake").first.emoji,
          style: TextStyle(fontSize: 30),
        ),
        titleText: "Unicode Emoji",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: EmojiService().searchController,
      ),
      body: StreamBuilder(
        stream: EmojiService().refinedListStream,
        builder: (context, AsyncSnapshot<List<Emoji>> asyncSnapshot) {
          List<Emoji> iconsToShow = asyncSnapshot.data ?? [];
          return MediaQuery.sizeOf(context).shortestSide < 600
              ? ListView.builder(
                  itemCount: iconsToShow.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => onTap(context, iconsToShow[index]),
                      onLongPress: () async {
                        await Clipboard.setData(
                          ClipboardData(text: (iconsToShow[index]).unified),
                        );
                      },
                      onDoubleTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: iconsToShow[index].emoji),
                        );
                      },
                      child: ListTile(
                        leading: Text(
                          (iconsToShow[index]).emoji,
                          style: TextStyle(fontSize: 32),
                        ),
                        title: Text((iconsToShow[index]).name),
                        dense: true,
                        subtitle: Text((iconsToShow[index]).unified),
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
                        onTap: () => onTap(context, iconsToShow[index]),
                        onLongPress: () async {
                          await Clipboard.setData(
                            ClipboardData(text: iconsToShow[index].unified),
                          );
                        },
                        onDoubleTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: iconsToShow[index].emoji),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                iconsToShow[index].emoji,
                                style: TextStyle(fontSize: 32),
                              ),
                              PreventOrphanText(
                                iconsToShow[index].name,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
