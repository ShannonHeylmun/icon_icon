import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/pages/emoji/emoji_service.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

GlobalKey<ScaffoldState> snackbarKey = GlobalKey<ScaffoldState>();
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
        foregroundColor: emojiColorContrast,
        leadingIcon: Text(
          "❄️",
          style: GoogleFonts.notoEmoji(color: emojiColorContrast, fontSize: 30),
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
          return Scaffold(
            key: snackbarKey,
            body: ResponsiveIcons(iconsToShow: iconsToShow),
          );
        },
      ),
    );
  }
}
