import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/emoji/emoji_screen.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/huge_icons_lookup_page.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

const Color seedColor = Color.fromRGBO(158, 225, 99, 1);
void main() {
  runApp(const MyApp());
}

final GlobalKey<ScaffoldState> _key = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BehaviorSubject<Widget> _selectedPage = BehaviorSubject.seeded(
    HugeIconsLookupPage(),
  );
  // Widget _selectedPage = HugeIconsLookupPage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glyph Lookup',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: seedColor)),
      home: Scaffold(
        key: _key,
        body: StreamBuilder(
          builder: (context, AsyncSnapshot<Widget> snapshot) =>
              snapshot.hasData ? snapshot.data! : SizedBox.shrink(),
          stream: _selectedPage.stream,
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: SafeArea(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: HugeIcon(icon: HugeIcons.strokeRoundedHugeicons),
                  title: Text("Huge Icons"),
                  onTap: () {
                    _selectedPage.add(HugeIconsLookupPage());
                    _key.currentState!.closeDrawer();
                  },
                ),
                ListTile(
                  leading: HugeIcon(icon: HugeIcons.strokeRoundedSmile),
                  title: Text("Unicode Emoji"),
                  onTap: () {
                    _selectedPage.add(EmojiScreen());
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
