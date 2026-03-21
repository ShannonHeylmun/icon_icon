import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/animated_icons/animated_icons_page.dart';
import 'package:hugeicons_showcase/components/custom_drawer_list_tile.dart';
import 'package:hugeicons_showcase/credits/credits_page.dart';
import 'package:hugeicons_showcase/fluentui_icons/fluentui_icons_page.dart';
import 'package:hugeicons_showcase/material_symbols/material_symbols_page.dart';
import 'package:hugeicons_showcase/emoji/emoji_screen.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/huge_icons_lookup_page.dart';
import 'package:hugeicons_showcase/material_icons/material_icons_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

const Color seedColor = Color.fromRGBO(158, 225, 99, 1);
const Color emojiColor = Color.fromRGBO(255, 220, 93, .4);
const Color animatedIconsColor = Color.fromRGBO(4, 104, 215, .2);
const Color materialIconsColor = Color.fromARGB(255, 230, 113, 67);
const Color materialSymbolsColor = Color(0xff9f86ff);
const Color fluentuiIconsColor = Color.fromARGB(255, 62, 233, 156);

const Color creditsColor = Colors.black;

Color seedColorContrast = contrastColor(seedColor);
Color emojiColorContrast = contrastColor(emojiColor);
Color animatedIconsColorContrast = contrastColor(animatedIconsColor);
Color materialIconsColorContrast = contrastColor(materialIconsColor);
Color materialSymbolsColorContrast = contrastColor(materialSymbolsColor);
Color fluentuiIconsColorContrast = contrastColor(fluentuiIconsColor);
Color creditsColorContrast = contrastColor(creditsColor);

Widget hugeIcon = HugeIcon(icon: HugeIcons.strokeRoundedSnow);

Widget creditsIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedLaurelWreath01,
  color: creditsColorContrast,
);
void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Color contrastColor(Color color) {
  int d = 0;

  // Counting the perceptive luminance - human eye favors green color...
  double luminance =
      (pow((color.r * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.2126 +
          pow((color.g * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.7152 +
          pow((color.b * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.0722) *
      color.a;

  if (luminance > 0.004) {
    d = 0; // bright colors - black font
  } else {
    d = 255; // dark colors - white font
  }

  return Color.fromRGBO(d, d, d, 1);
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final BehaviorSubject<Widget> _selectedPage = BehaviorSubject.seeded(
    HugeIconsLookupPage(),
  );

  void updateSelectedPage(Widget page) {
    _selectedPage.add(page);
  }

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1400),
          )
          ..forward()
          ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Glyph Lookup',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: seedColor),
        textTheme: GoogleFonts.notoSansTextTheme(ThemeData().textTheme),
      ),
      home: Scaffold(
        key: drawerKey,
        body: StreamBuilder(
          builder: (context, AsyncSnapshot<Widget> snapshot) =>
              snapshot.hasData ? snapshot.data! : SizedBox.shrink(),
          stream: _selectedPage.stream,
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CustomDrawerListTile(
                  leadingWidget: creditsIcon,
                  tileColor: creditsColor,
                  textColor: creditsColorContrast,
                  title: "Credits",
                  onTapCallback: () => updateSelectedPage(CreditsPage()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: animatedIconsColor,
                  textColor: animatedIconsColorContrast,
                  leadingWidget: RotatedBox(
                    quarterTurns: 2,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      size: 24.0,
                      progress: animation,
                    ),
                  ),
                  title: "Animated Icons",
                  onTapCallback: () => updateSelectedPage(AnimatedIconsPage()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: emojiColor,
                  textColor: emojiColorContrast,
                  leadingWidget: Text(
                    UnicodeEmojis.search("snowflake").first.emoji,
                    style: TextStyle(fontSize: 18),
                  ),
                  title: "Unicode Emoji",
                  onTapCallback: () => updateSelectedPage(EmojiScreen()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: seedColor,
                  textColor: seedColorContrast,
                  leadingWidget: hugeIcon,
                  title: "Huge Icons",
                  onTapCallback: () =>
                      updateSelectedPage(HugeIconsLookupPage()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: materialIconsColor,
                  textColor: materialIconsColorContrast,
                  leadingWidget: Icon(MdiIcons.snowflake, size: 24),
                  title: "Material Design Icons",
                  onTapCallback: () => updateSelectedPage(MaterialIconsPage()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: materialSymbolsColor,
                  textColor: materialSymbolsColorContrast,
                  leadingWidget: Icon(Symbols.mode_cool),
                  title: "Material Symbols",
                  onTapCallback: () =>
                      updateSelectedPage(MaterialSymbolsPage()),
                  context: context,
                ),
                CustomDrawerListTile(
                  tileColor: fluentuiIconsColor,
                  textColor: fluentuiIconsColorContrast,
                  leadingWidget: Icon(FluentIcons.weather_snowflake_24_filled),
                  title: "Fluent Icons",
                  onTapCallback: () => updateSelectedPage(FluentIconsPage()),
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
