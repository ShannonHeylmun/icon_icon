import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/pages/animated_icons/animated_helper.dart';

import 'package:rxdart/subjects.dart';

List<(String, AnimatedIconData)> getAllIcons() {
  return iconsList;
}

class AnimatedIconsService {
  // singleton pattern
  static final AnimatedIconsService _instance =
      AnimatedIconsService._internal();
  factory AnimatedIconsService() {
    return _instance;
  }
  AnimatedIconsService._internal() {
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
  late List<(String, AnimatedIconData)> _refinedList;
  List<(String, AnimatedIconData)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, AnimatedIconData)>>
  _refinedListBehaviorSubject = BehaviorSubject.seeded(getAllIcons());
  Stream<List<(String, AnimatedIconData)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
