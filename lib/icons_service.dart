import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/helper_huge_icons.dart';

class IconsService {
  // singleton pattern
  static final IconsService _instance = IconsService._internal();
  factory IconsService() {
    return _instance;
  }
  IconsService._internal() {
    _searchController.addListener(() {
      String searchTerm = _searchController.text.toLowerCase();
      _refinedList = hugeHelperList
          .where(
            (icon) => icon.$1.toLowerCase().contains(searchTerm.toLowerCase()),
          )
          .toList();
      _refinedListController.add(_refinedList);
    });
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, List<List<dynamic>>)> _refinedList;
  List<(String, List<List<dynamic>>)> get refinedList => _refinedList;

  StreamController<List<(String, List<List<dynamic>>)>> _refinedListController =
      StreamController<List<(String, List<List<dynamic>>)>>();
  Stream<List<(String, List<List<dynamic>>)>> get refinedListStream =>
      _refinedListController.stream;
}
