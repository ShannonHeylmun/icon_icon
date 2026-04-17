import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/pages/cupertino_icons/cupertino_icon_list.dart';

import 'package:rxdart/subjects.dart';

List<(String, IconData)> getAllIcons() {
  return cupertinoIconByName;
}

class CupertinoIconsService {
  // singleton pattern
  static final CupertinoIconsService _instance =
      CupertinoIconsService._internal();
  factory CupertinoIconsService() {
    return _instance;
  }
  CupertinoIconsService._internal() {
    Future(() => _refinedListBehaviorSubject.add(getAllIcons()));
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    _refinedList = getAllIcons()
        .where(
          (icon) =>
              icon.toString().toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList();
    _refinedListBehaviorSubject.add(_refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, IconData)> _refinedList;
  List<(String, IconData)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded([]);
  Stream<List<(String, IconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
