import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/components/custom_app_bar.dart';
import 'package:hugeicons_showcase/components/responsive_icons.dart';
import 'package:hugeicons_showcase/material_symbols/material_symbols_service.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class MaterialSymbolsPage extends StatelessWidget {
  const MaterialSymbolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> selectStyle() async {
      switch (await showDialog<SymbolStyle>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select style'),
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
      )) {
        case SymbolStyle.outlined:
          MaterialSymbolsService().updateSymbolStyle(SymbolStyle.outlined);
          break;
        case SymbolStyle.rounded:
          MaterialSymbolsService().updateSymbolStyle(SymbolStyle.rounded);
          break;
        case SymbolStyle.sharp:
          MaterialSymbolsService().updateSymbolStyle(SymbolStyle.sharp);
          break;
        case null:
          break;
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        context,
        color: Color(0xff9f86ff),
        searchController: MaterialSymbolsService().searchController,
        leadingIcon: Icon(CupertinoIcons.app_badge_fill, size: 36),
        paddingLeft: 0,
        actions: [
          IconButton(onPressed: selectStyle, icon: Icon(Symbols.filter_list)),
        ],
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
