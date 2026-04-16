import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class OmnibusGlyphsService {
  // singleton pattern
  static final OmnibusGlyphsService _instance =
      OmnibusGlyphsService._internal();
  factory OmnibusGlyphsService() {
    return _instance;
  }
  OmnibusGlyphsService._internal() {
    _refinedListBehaviorSubject.add([]);
    _searchController.addListener(_updateRefinedList);
  }

  void dispose() {
    _searchController.removeListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    String searchTerm = _searchController.text.toLowerCase();
    List<(String, Object)> refined = _allIcons.where((icon) {
      return _matchesSearch(icon, searchTerm);
    }).toList();
    _refinedListBehaviorSubject.add(refined);
  }

  bool _matchesSearch((String, Object) icon, String searchTerm) {
    return icon.$1.toLowerCase().contains(searchTerm);
  }

  final List<(String, Object)> _allIcons = [];

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, Object)> _refinedList;
  List<(String, Object)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, Object)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded([]);
  Stream<List<(String, Object)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
