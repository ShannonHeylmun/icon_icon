import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/components/responsive_icons.dart';
import 'package:hugeicons_showcase/emoji/emoji_service.dart';
import 'package:hugeicons_showcase/main.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

GlobalKey emojiVariantsKey = GlobalKey(debugLabel: "emojiVariantsKey");

class EmojiScreen extends StatelessWidget {
  const EmojiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: emojiVariantsKey,
      appBar: CustomAppBar(
        context,
        backgroundColor: emojiColor,
        leadingIcon: Stack(
          children: [
            Positioned(
              top: 8,
              child: Text(
                UnicodeEmojis.search("snowflake").first.emoji,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
        titleText: "Unicode Emoji",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: EmojiService().searchController,
      ),
      body: StreamBuilder(
        stream: EmojiService().refinedListStream,
        builder: (context, AsyncSnapshot<List<(String, Emoji)>> asyncSnapshot) {
          List<(String, Emoji)> iconsToShow = asyncSnapshot.data ?? [];
          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
