import 'package:clipboard/clipboard.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/components/bottom_search_card.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/components/responsive_icons.dart';
import 'package:hugeicons_showcase/fluentui_icons/fluentui_icons_service.dart';
import 'package:hugeicons_showcase/main.dart';

class FluentIconsPage extends StatelessWidget {
  const FluentIconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> switchStyle() async {
      switch (await showDialog<FluentIconSymbolStyle>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select family'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FluentIconSymbolStyle.regular);
                },
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
              // SimpleDialogOption(
              //   onPressed: () {
              //     Navigator.pop(context, FluentIconSymbolStyle.light);
              //   },
              //   child: Text(
              //     'Light',
              //     style: TextStyle(
              //       fontWeight:
              //           FluentIconsService().symbolStyleBehaviorSubject.value ==
              //               FluentIconSymbolStyle.light
              //           ? FontWeight.bold
              //           : FontWeight.normal,
              //     ),
              //   ),
              // ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, FluentIconSymbolStyle.filled);
                },
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

    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: fluentuiIconsColor,
        leadingIcon: Icon(FluentIcons.weather_snowflake_24_regular, size: 36),
        paddingLeft: 0,
        actions: [
          IconButton(
            onPressed: switchStyle,
            icon: Icon(FluentIcons.filter_12_filled),
          ),
        ],
        titleText: "FluentUI Icons",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: FluentIconsService().searchController,
      ),
      body: StreamBuilder(
        stream: FluentIconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];

          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
