import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/iconoir_icons/iconoir_icon_list.dart';
import 'package:rxdart/subjects.dart';

import 'package:material_symbols_icons/get.dart';

class IconoirService {
  // singleton pattern
  static final IconoirService _instance = IconoirService._internal();
  factory IconoirService() {
    return _instance;
  }
  IconoirService._internal() {
    getAllIcons();
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    List<(String, StatelessWidget)> refinedList = getAllIcons();
    refinedList = getAllIcons().where((element) {
      return element.$1.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
    _refinedListBehaviorSubject.add(refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late Map<String, StatelessWidget> _refinedList;
  Map<String, StatelessWidget> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, StatelessWidget)>>
  _refinedListBehaviorSubject = BehaviorSubject.seeded([]);
  Stream<List<(String, StatelessWidget)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;

  final BehaviorSubject<SymbolStyle> symbolStyleBehaviorSubject =
      BehaviorSubject.seeded(SymbolStyle.rounded);

  List<(String, StatelessWidget)> getAllIcons() {
    List<(String, StatelessWidget)> icons = iconoirIcons;
    _refinedListBehaviorSubject.add(icons);
    return icons;
  }
}
