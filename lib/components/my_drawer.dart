import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/custom_drawer_list_tile.dart';
import 'package:icon_icon/main.dart';
import 'package:icon_icon/pages/animated_icons/animated_icons_page.dart';
import 'package:icon_icon/pages/credits/credits_page.dart';
import 'package:icon_icon/pages/cupertino_icons/cupertino_icons_page.dart';
import 'package:icon_icon/pages/emoji/emoji_screen.dart';
import 'package:icon_icon/pages/fluentui_icons/fluentui_icons_page.dart';
import 'package:icon_icon/pages/huge_icons_lookup/huge_icons_lookup_page.dart';
import 'package:icon_icon/pages/iconoir_icons/iconoir_page.dart';
import 'package:icon_icon/pages/material_icons/material_icons_page.dart';
import 'package:icon_icon/pages/material_symbols/material_symbols_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

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
