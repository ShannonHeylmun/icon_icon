import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/fluentui_icons/fluentui_icon_list.dart';

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
    _searchController.addListener(_refineListBySearch);
  }

  void dispose() {
    _searchController.removeListener(_refineListBySearch);
  }

  void _refineListBySearch() {
    String searchTerm = _searchController.text.toLowerCase();
    _refinedList = getAllIcons().where((element) {
      return element.$1.contains(searchTerm) ||
          element.$2.codePoint.toString().contains(searchTerm);
    }).toList();

    _refinedListBehaviorSubject.add(_refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, IconData)> _refinedList = fluentuiIconByName;
  List<(String, IconData)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded([]);
  Stream<List<(String, IconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;

  final BehaviorSubject<FluentIconSymbolStyle> symbolStyleBehaviorSubject =
      BehaviorSubject.seeded(FluentIconSymbolStyle.regular);

  void updateSymbolStyle(FluentIconSymbolStyle symbolStyle) {
    symbolStyleBehaviorSubject.add(symbolStyle);
    _refineListBySearch();
  }

  List<(String, IconData)> getAllIcons() {
    List<(String, IconData)> icons = fluentuiIconByName;
    // refine by `FluentIconSymbolStyle`
    icons = icons.where((i) {
      return (i.$2.fontFamily!.toLowerCase().contains(
        symbolStyleBehaviorSubject.value.name.toLowerCase(),
      ));
    }).toList();
    _refinedListBehaviorSubject.add(icons);
    return icons;
  }
}
