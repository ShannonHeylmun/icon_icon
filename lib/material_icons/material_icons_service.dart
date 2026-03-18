import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/main.dart' hide Icons;
import 'package:hugeicons_showcase/material_icons/material_helper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reflectable/mirrors.dart';

import 'package:rxdart/subjects.dart';

List<(String, IconData?)> getAllIcons() {
  List<String> names = MdiIcons.getNames();
  List<(String, IconData?)> icons = [];
  names.forEach((name) => icons.add((name, MdiIcons.fromString(name))));
  return icons;
}

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
  late List<(String, IconData?)> _refinedList;
  List<(String, IconData?)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, IconData?)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded(getAllIcons());
  Stream<List<(String, IconData?)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
