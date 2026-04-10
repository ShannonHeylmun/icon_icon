import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:icon_icon/components/my_drawer.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/pages/emoji/emoji_screen.dart';
import 'package:icon_icon/theme_bloc.dart';

import 'package:iconoir_flutter/regular/snow_flake.dart';
import 'package:logging/logging.dart';

import 'package:rxdart/rxdart.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey(debugLabel: "DrawerKey");
late AnimationController controller;
late Animation<double> animation;
BehaviorSubject<ThemeMode> brightnessStreamController =
    BehaviorSubject<ThemeMode>.seeded(ThemeMode.system);

ThemeMode getBrightness() {
  return brightnessStreamController.stream.value;
}

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
  runApp(
    BlocProvider(
      create: (context) => ThemeBloc()..add(SetInitialTheme()),
      child: const MyApp(),
    ),
  );
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
    return BlocBuilder<ThemeBloc, bool>(
      builder: (context, themeState) {
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
            textTheme: GoogleFonts.notoSansTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          themeMode: themeState ? ThemeMode.dark : ThemeMode.light,
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
      },
    );
  }
}
