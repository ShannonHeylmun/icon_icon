import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/helper_huge_icons.dart';
import 'package:rxdart/subjects.dart';

class IconsService {
  // singleton pattern
  static final IconsService _instance = IconsService._internal();
  factory IconsService() {
    return _instance;
  }
  IconsService._internal() {
    _refinedListBehaviorSubject.add(hugeHelperList);
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    _refinedList = hugeHelperList
        .where(
          (icon) => "strokeRounded${icon.$1}".toLowerCase().contains(
            searchTerm.toLowerCase(),
          ),
        )
        .toList();
    _refinedListBehaviorSubject.add(_refinedList);
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, List<List<dynamic>>)> _refinedList;
  List<(String, List<List<dynamic>>)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, List<List<dynamic>>)>>
  _refinedListBehaviorSubject = BehaviorSubject.seeded(hugeHelperList);
  Stream<List<(String, List<List<dynamic>>)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
