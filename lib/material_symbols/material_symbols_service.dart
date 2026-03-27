import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/material_symbols/material_symbols_list.dart';
import 'package:material_symbols_icons/get.dart';

import 'package:rxdart/subjects.dart';

class MaterialSymbolsService {
  // singleton pattern
  static final MaterialSymbolsService _instance =
      MaterialSymbolsService._internal();
  factory MaterialSymbolsService() {
    return _instance;
  }
  MaterialSymbolsService._internal() {
    _refinedListBehaviorSubject.add(getAllIcons());
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    List<(String, IconData)> refinedList = getAllIcons(
      style: symbolStyleBehaviorSubject.value,
    );
    refinedList = getAllIcons().where((element) {
      return element.$1.contains(searchTerm) ||
          element.$2.codePoint.toString().contains(searchTerm);
    }).toList();
    _refinedListBehaviorSubject.add(refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late Map<String, IconData> _refinedList;
  Map<String, IconData> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded([]);
  Stream<List<(String, IconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;

  final BehaviorSubject<SymbolStyle> symbolStyleBehaviorSubject =
      BehaviorSubject.seeded(SymbolStyle.rounded);

  void updateSymbolStyle(SymbolStyle symbolStyle) {
    symbolStyleBehaviorSubject.add(symbolStyle);
    _refinedListBehaviorSubject.add(
      _refinedListBehaviorSubject.value
          .map(
            (e) =>
                (e.$1, SymbolsGet.get(e.$1, symbolStyleBehaviorSubject.value)),
          )
          .toList(),
    );
  }
}
