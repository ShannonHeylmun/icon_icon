import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:icon_icon/animated_icons/animated_icons_page.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/custom_drawer_list_tile.dart';
import 'package:icon_icon/components/helpers.dart';
import 'package:icon_icon/credits/credits_page.dart';
import 'package:icon_icon/cupertino_icons/cupertino_icons_page.dart';
import 'package:icon_icon/fluentui_icons/fluentui_icons_page.dart';
import 'package:icon_icon/iconoir_icons/iconoir_page.dart';
import 'package:icon_icon/material_symbols/material_symbols_page.dart';
import 'package:icon_icon/emoji/emoji_screen.dart';
import 'package:icon_icon/huge_icons_lookup/huge_icons_lookup_page.dart';
import 'package:icon_icon/material_icons/material_icons_page.dart';

import 'package:iconoir_flutter/regular/snow_flake.dart';
import 'package:logging/logging.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:rxdart/rxdart.dart';
// import 'package:sentry_logging/sentry_logging.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey(debugLabel: "DrawerKey");
late AnimationController controller;
late Animation<double> animation;

//Icons
Widget hugeIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedSnow,
  size: 24,
  color: seedColorContrast,
);
Widget creditsIcon = HugeIcon(
  icon: HugeIcons.strokeRoundedLaurelWreath01,
  size: 24,
  color: creditsColorContrast,
);
Widget iconoirIcon = SnowFlake(color: iconnoirColorContrast, width: 24);
Widget emojiIcon({double? size}) => Text(
  "❄️",
  style: GoogleFonts.notoEmoji(color: emojiColorContrast, fontSize: size ?? 18),
);

IconData cupertinoIconSnow = CupertinoIcons.snow;

final log = Logger('OverallLogger');
void main() {
  Logger.root.level = Level.INFO; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  // await SentryFlutter.init((options) {
  //   options.dsn = Env.sentryDSN;
  //   // Adds request headers and IP for users, for more info visit:
  //   // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
  //   options.sendDefaultPii = true;
  //   options.enableLogs = true;
  //   // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
  //   // We recommend adjusting this value in production.
  //   options.tracesSampleRate = 1.0;
  //   // The sampling rate for profiling is relative to tracesSampleRate
  //   // Setting to 1.0 will profile 100% of sampled transactions:
  //   options.profilesSampleRate = 1.0;
  //   // Configure Session Replay
  //   options.replay.sessionSampleRate = 0.1;
  //   options.replay.onErrorSampleRate = 1.0;
  //   options.addIntegration(LoggingIntegration(minSentryLogLevel: Level.INFO));
  //   // If you want to enable sending structured logs, set `enableLogs` to `true`
  //   options.enableLogs = true;
  // }, appRunner: () =>
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final BehaviorSubject<Widget> _selectedPage = BehaviorSubject.seeded(
    EmojiScreen(),
  );

  // void updateSelectedPage(Widget page) {
  //   _selectedPage.add(page);
  // }

  @override
  void initState() {
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
      title: 'icon_icon',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: creditsColor),
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: creditsColor,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme),
      ),
      themeMode: ThemeMode.system,
      home: StreamBuilder(
        stream: _selectedPage.stream,
        builder: (context, snapshot) {
          return Scaffold(
            key: drawerKey,
            body: snapshot.hasData ? snapshot.data! : SizedBox.shrink(),
            drawer: MyDrawer(
              onPageSelected: (page) {
                _selectedPage.add(page);
              },
              animation: animation,
            ),
          );
        },
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final Function(Widget) onPageSelected;
  final Animation<double> animation;

  const MyDrawer({
    super.key,
    required this.onPageSelected,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: creditsColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomDrawerListTile(
              leadingWidget: creditsIcon,
              tileColor: creditsColor,
              textColor: creditsColorContrast,
              title: "Credits",
              onTapCallback: () => onPageSelected(CreditsPage()),
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
                  color: animatedIconsColorContrast,
                ),
              ),
              title: "Animated Icons",
              onTapCallback: () => onPageSelected(AnimatedIconsPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: emojiColor,
              textColor: emojiColorContrast,
              leadingWidget: emojiIcon(),
              title: "Unicode Emoji",
              onTapCallback: () => onPageSelected(EmojiScreen()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: seedColor,
              textColor: seedColorContrast,
              leadingWidget: hugeIcon,
              title: "Huge Icons",
              onTapCallback: () => onPageSelected(HugeIconsLookupPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: materialIconsColor,
              textColor: materialIconsColorContrast,
              leadingWidget: Icon(
                MdiIcons.snowflake,
                size: 24,
                color: materialIconsColorContrast,
              ),
              title: "Material Design Icons",
              onTapCallback: () => onPageSelected(MaterialIconsPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: materialSymbolsColor,
              textColor: materialSymbolsColorContrast,
              leadingWidget: Icon(
                Symbols.mode_cool,
                color: materialSymbolsColorContrast,
              ),
              title: "Material Symbols",
              onTapCallback: () => onPageSelected(MaterialSymbolsPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: fluentuiIconsColor,
              textColor: fluentuiIconsColorContrast,
              leadingWidget: Icon(FluentIcons.weather_snowflake_24_filled),
              title: "Fluent Icons",
              onTapCallback: () => onPageSelected(FluentIconsPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: iconoirColor,
              textColor: fluentuiIconsColorContrast,
              leadingWidget: iconoirIcon,
              title: "Iconoir Icons",
              onTapCallback: () => onPageSelected(IconoirPage()),
              context: context,
            ),
            CustomDrawerListTile(
              tileColor: cupertinoIconsColor,
              textColor: cupertinoIconsColorContrast,
              leadingWidget: Icon(
                cupertinoIconSnow,
                size: 24,
                color: cupertinoIconsColorContrast,
              ),
              title: "Cupertino Icons",
              onTapCallback: () => onPageSelected(CupertinoIconsPage()),
              context: context,
            ),
            // CustomDrawerListTile(
            //   tileColor: omnibusGlyphsColor,
            //   textColor: omnibusGlyphsColorContrast,
            //   leadingWidget: Text(
            //     "❄️",
            //     style: GoogleFonts.notoEmoji(
            //       color: omnibusGlyphsColorContrast,
            //       fontSize: 18,
            //     ),
            //   ),
            //   title: "Search All",
            //   onTapCallback: () =>
            //       updateSelectedPage(OmnibusGlyphsScreen()),
            //   context: context,
            // ),
          ],
        ),
      ),
    );
  }
}
