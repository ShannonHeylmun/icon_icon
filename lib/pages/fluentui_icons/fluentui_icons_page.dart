import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/pages/fluentui_icons/fluentui_icons_service.dart';
import 'package:icon_icon/services/icon_font_service.dart';

class FluentIconsPage extends StatefulWidget {
  const FluentIconsPage({super.key});

  @override
  State<FluentIconsPage> createState() => _FluentIconsPageState();
}

class _FluentIconsPageState extends State<FluentIconsPage> {
  bool _fontLoaded = false;

  @override
  void initState() {
    super.initState();
    IconFontService.loadFluentIcons().then((_) {
      if (mounted) setState(() => _fontLoaded = true);
    });
  }

  Future<void> _switchStyle() async {
    switch (await showDialog<FluentIconSymbolStyle>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select family'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, FluentIconSymbolStyle.regular),
              child: Text(
                'Regular',
                style: TextStyle(
                  fontWeight:
                      FluentIconsService().symbolStyleBehaviorSubject.value ==
                          FluentIconSymbolStyle.regular
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(context, FluentIconSymbolStyle.filled),
              child: Text(
                'Filled',
                style: TextStyle(
                  fontWeight:
                      FluentIconsService().symbolStyleBehaviorSubject.value ==
                          FluentIconSymbolStyle.filled
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    )) {
      case FluentIconSymbolStyle.filled:
        FluentIconsService().updateSymbolStyle(FluentIconSymbolStyle.filled);
        break;
      case FluentIconSymbolStyle.regular:
        FluentIconsService().updateSymbolStyle(FluentIconSymbolStyle.regular);
        break;
      case FluentIconSymbolStyle.light:
        FluentIconsService().updateSymbolStyle(FluentIconSymbolStyle.light);
        break;
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: fluentuiIconsColor,
        foregroundColor: fluentuiIconsColorContrast,
        leadingIcon: Icon(
          _fontLoaded
              ? FluentIcons.weather_snowflake_24_regular
              : Icons.ac_unit,
          size: 36,
        ),
        paddingLeft: 0,
        supplementaryActions: [
          IconButton(
            onPressed: _switchStyle,
            icon: Icon(
              _fontLoaded ? FluentIcons.filter_12_filled : Icons.filter_list,
            ),
          ),
        ],
        titleText: "FluentUI Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: FluentIconsService().searchController,
      ),
      body: _fontLoaded
          ? StreamBuilder(
              stream: FluentIconsService().refinedListStream,
              builder: (context, asyncSnapshot) {
                List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
                return ResponsiveIcons(iconsToShow: iconsToShow);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
