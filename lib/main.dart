import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/animated_icons/animated_icons_page.dart';
import 'package:hugeicons_showcase/fluentui_icons/fluentui_icons_page.dart';
import 'package:hugeicons_showcase/material_symbols/material_symbols_page.dart';
import 'package:hugeicons_showcase/emoji/emoji_screen.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/huge_icons_lookup_page.dart';
import 'package:hugeicons_showcase/material_icons/material_icons_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

import 'package:flutter/material.dart';

const Color seedColor = Color.fromRGBO(158, 225, 99, 1);

main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> _key = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final BehaviorSubject<Widget> _selectedPage = BehaviorSubject.seeded(
    HugeIconsLookupPage(),
  );

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
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
        key: _key,
        body: StreamBuilder(
          builder: (context, AsyncSnapshot<Widget> snapshot) =>
              snapshot.hasData ? snapshot.data! : SizedBox.shrink(),
          stream: _selectedPage.stream,
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: RotatedBox(
                    quarterTurns: 2,
                    child: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      size: 24.0,
                      progress: animation,
                    ),
                  ),
                  title: Text("Animated Icons"),
                  onTap: () {
                    _selectedPage.add(AnimatedIconsPage());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Text(
                    UnicodeEmojis.search("snowflake")!.first.emoji,
                    style: TextStyle(fontSize: 22),
                  ),
                  title: Text("Unicode Emoji"),
                  onTap: () {
                    _selectedPage.add(EmojiScreen());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: HugeIcon(icon: HugeIcons.strokeRoundedSnow),
                  title: Text("Huge Icons"),
                  onTap: () {
                    _selectedPage.add(HugeIconsLookupPage());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(MdiIcons.snowflake, size: 24),
                  title: Text("Material Design Icons"),
                  onTap: () {
                    _selectedPage.add(MaterialIconsPage());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Symbols.mode_cool),
                  title: Text("Material Symbols"),
                  onTap: () {
                    _selectedPage.add(MaterialSymbolsPage());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(FluentIcons.weather_snowflake_24_filled),
                  title: Text("Fluent Icons"),
                  onTap: () {
                    _selectedPage.add(FluentIconsPage());
                    _key.currentState!.closeDrawer();
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
