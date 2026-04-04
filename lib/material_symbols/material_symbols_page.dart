import 'package:flutter/material.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/main.dart';
import 'package:icon_icon/material_symbols/material_symbols_service.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class MaterialSymbolsPage extends StatelessWidget {
  const MaterialSymbolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: This should probably be a global function of some sort, since it's pretty commonly necessary
    Future<void> selectStyle() async {
      // Ask User for symbolStyle and return from dialog
      SymbolStyle? symbolStyle = await showDialog<SymbolStyle?>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select family'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, SymbolStyle.outlined);
                },
                child: Text(
                  'Outlined',
                  style: TextStyle(
                    fontWeight:
                        MaterialSymbolsService()
                                .symbolStyleBehaviorSubject
                                .value ==
                            SymbolStyle.outlined
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, SymbolStyle.rounded);
                },
                child: Text(
                  'Rounded',
                  style: TextStyle(
                    fontWeight:
                        MaterialSymbolsService()
                                .symbolStyleBehaviorSubject
                                .value ==
                            SymbolStyle.rounded
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, SymbolStyle.sharp);
                },
                child: Text(
                  'Sharp',
                  style: TextStyle(
                    fontWeight:
                        MaterialSymbolsService()
                                .symbolStyleBehaviorSubject
                                .value ==
                            SymbolStyle.sharp
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        },
      );
      if (symbolStyle != null) {
        MaterialSymbolsService().updateSymbolStyle(symbolStyle);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: materialSymbolsColor,
        foregroundColor: materialSymbolsColorContrast,
        leadingIcon: Icon(Symbols.mode_cool, size: 36),
        paddingLeft: 0,
        actions: [
          IconButton(onPressed: selectStyle, icon: Icon(Symbols.filter_list)),
        ],
        titleText: "Material Symbols",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: MaterialSymbolsService().searchController,
      ),
      body: StreamBuilder(
        stream: MaterialSymbolsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
          return ResponsiveIcons(iconsToShow: iconsToShow);
        },
      ),
    );
  }
}
