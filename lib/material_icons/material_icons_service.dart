import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/material_icons/material_icons_list.dart';

import 'package:rxdart/subjects.dart';

class MaterialIconsService {
  // singleton pattern
  static final MaterialIconsService _instance =
      MaterialIconsService._internal();
  factory MaterialIconsService() {
    return _instance;
  }
  MaterialIconsService._internal() {
    _refinedListBehaviorSubject.add(getAllIcons());
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    _refinedList = getAllIcons().where((icon) {
      return icon.$1.toLowerCase().contains(searchTerm) ||
          (icon.$2.codePoint.toString().contains(searchTerm));
    }).toList();
    _refinedListBehaviorSubject.add(_refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, IconData)> _refinedList;
  List<(String, IconData)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded(getAllIcons());
  Stream<List<(String, IconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
