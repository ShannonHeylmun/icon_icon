import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';
import 'package:icon_icon/components/bottom_search_card.dart';
import 'package:icon_icon/components/custom_app_bar.dart';
import 'package:icon_icon/components/responsive_icons.dart';
import 'package:icon_icon/pages/material_symbols/material_symbols_service.dart';
import 'package:icon_icon/services/icon_font_service.dart';
import 'package:material_symbols_icons/get.dart';
import 'package:material_symbols_icons/symbols.dart';

class MaterialSymbolsPage extends StatefulWidget {
  const MaterialSymbolsPage({super.key});

  @override
  State<MaterialSymbolsPage> createState() => _MaterialSymbolsPageState();
}

class _MaterialSymbolsPageState extends State<MaterialSymbolsPage> {
  bool _fontLoaded = false;

  @override
  void initState() {
    super.initState();
    IconFontService.loadMaterialSymbols().then((_) {
      if (mounted) setState(() => _fontLoaded = true);
    });
  }

  Future<void> _selectStyle() async {
    final symbolStyle = await showDialog<SymbolStyle?>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select family'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, SymbolStyle.outlined),
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
              onPressed: () => Navigator.pop(context, SymbolStyle.rounded),
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
              onPressed: () => Navigator.pop(context, SymbolStyle.sharp),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        backgroundColor: materialSymbolsColor,
        foregroundColor: materialSymbolsColorContrast,
        leadingIcon: Icon(
          _fontLoaded ? Symbols.mode_cool : Icons.auto_awesome,
          size: 36,
        ),
        paddingLeft: 0,
        supplementaryActions: [
          IconButton(
            onPressed: _selectStyle,
            icon: Icon(
              _fontLoaded ? Symbols.filter_list : Icons.filter_list,
            ),
          ),
        ],
        titleText: "Material Symbols",
      ),
      bottomNavigationBar: BottomSearchCard(
        controller: MaterialSymbolsService().searchController,
      ),
      body: _fontLoaded
          ? StreamBuilder(
              stream: MaterialSymbolsService().refinedListStream,
              builder: (context, asyncSnapshot) {
                List<(String, IconData)> iconsToShow = asyncSnapshot.data ?? [];
                return ResponsiveIcons(iconsToShow: iconsToShow);
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
