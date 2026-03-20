import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/fluentui_icons/fluentui_icon_list.dart';

import 'package:rxdart/subjects.dart';

enum FluentIconSymbolStyle { filled, regular, light }

class FluentIconsService {
  // singleton pattern
  static final FluentIconsService _instance = FluentIconsService._internal();
  factory FluentIconsService() {
    return _instance;
  }
  FluentIconsService._internal() {
    getAllIcons();
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    _refinedList = getAllIcons();
    // _refinedList.removeWhere((s, i) {
    //   return !(s.toLowerCase().contains(searchTerm.toLowerCase()) ||
    //       i
    //           .toString()
    //           .replaceAll("IconData(", "")
    //           .replaceAll("+0", "+")
    //           .replaceAll(")", "")
    //           .toLowerCase()
    //           .contains(searchTerm.toLowerCase()));
    // });
    _refinedListBehaviorSubject.add(_refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, IconData)> _refinedList;
  List<(String, IconData)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded(fluentuiIconByName);
  Stream<List<(String, IconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;

  final BehaviorSubject<FluentIconSymbolStyle> symbolStyleBehaviorSubject =
      BehaviorSubject.seeded(FluentIconSymbolStyle.regular);

  void updateSymbolStyle(FluentIconSymbolStyle symbolStyle) {
    symbolStyleBehaviorSubject.add(symbolStyle);
    _updateRefinedList();
  }

  List<(String, IconData)> getAllIcons() {
    List<(String, IconData)> icons = fluentuiIconByName;
    print(symbolStyleBehaviorSubject.value.name);
    // icons.removeWhere((s, i) {
    //   return i.fontFamily == null ||
    //       !i.fontFamily!.toLowerCase().contains(
    //         symbolStyleBehaviorSubject.value.name,
    //       );
    // });
    _refinedListBehaviorSubject.add(icons);
    return icons;
  }
}
