import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rxdart/subjects.dart';

final List<(String, AnimatedIconData)> iconsList = [
  ('add_event', AnimatedIcons.add_event),
  ('arrow_menu', AnimatedIcons.arrow_menu),
  ('close_menu', AnimatedIcons.close_menu),
  ('ellipsis_search', AnimatedIcons.ellipsis_search),
  ('event_add', AnimatedIcons.event_add),
  ('home_menu', AnimatedIcons.home_menu),
  ('list_view', AnimatedIcons.list_view),
  ('menu_arrow', AnimatedIcons.menu_arrow),
  ('menu_close', AnimatedIcons.menu_close),
  ('menu_home', AnimatedIcons.menu_home),
  ('pause_play', AnimatedIcons.pause_play),
  ('play_pause', AnimatedIcons.play_pause),
  ('search_ellipsis', AnimatedIcons.search_ellipsis),
  ('view_list', AnimatedIcons.view_list),
];
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
