import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/animated_icons/animated_icons_page.dart';
import 'package:hugeicons_showcase/components/custom_drawer_list_tile.dart';
import 'package:hugeicons_showcase/credits_page.dart';
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
main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
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

  // baseTheme.copyWith(
  //     textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
  //   )
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
                  leadingWidget: HugeIcon(
                    icon: HugeIcons.strokeRoundedLaurelWreath01,
                  ),
                  tileColor: Colors.black,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  title: Text("Credits"),
                  onTapCallback: () => updateSelectedPage(CreditsPage()),
                ),
                CustomDrawerListTile(
                  tileColor: animatedIconsColor,
                  leadingWidget: RotatedBox(
                    quarterTurns: 2,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      size: 24.0,
                      progress: animation,
                    ),
                  ),
                  title: Text("Animated Icons"),
                  onTapCallback: () {
                    updateSelectedPage(AnimatedIconsPage());
                  },
                ),
                CustomDrawerListTile(
                  tileColor: emojiColor,
                  leadingWidget: Text(
                    UnicodeEmojis.search("snowflake").first.emoji,
                    style: TextStyle(fontSize: 18),
                  ),
                  title: Text("Unicode Emoji"),
                  onTapCallback: () => _selectedPage.add(EmojiScreen()),
                ),
                CustomDrawerListTile(
                  tileColor: seedColor,
                  leadingWidget: HugeIcon(icon: HugeIcons.strokeRoundedSnow),
                  title: Text("Huge Icons"),
                  onTapCallback: () {
                    _selectedPage.add(HugeIconsLookupPage());
                  },
                ),
                CustomDrawerListTile(
                  tileColor: materialIconsColor,
                  leadingWidget: Icon(MdiIcons.snowflake, size: 24),
                  title: Text("Material Design Icons"),
                  onTapCallback: () {
                    _selectedPage.add(MaterialIconsPage());
                  },
                ),
                CustomDrawerListTile(
                  tileColor: materialSymbolsColor,
                  leadingWidget: Icon(Symbols.mode_cool),
                  title: Text("Material Symbols"),
                  onTapCallback: () {
                    _selectedPage.add(MaterialSymbolsPage());
                  },
                ),
                CustomDrawerListTile(
                  tileColor: fluentuiIconsColor,
                  leadingWidget: Icon(FluentIcons.weather_snowflake_24_filled),
                  title: Text("Fluent Icons"),
                  onTapCallback: () {
                    _selectedPage.add(FluentIconsPage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
