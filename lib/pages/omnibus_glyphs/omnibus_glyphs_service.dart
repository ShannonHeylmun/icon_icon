import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icon_icon/pages/animated_icons/animated_helper.dart';
import 'package:icon_icon/pages/cupertino_icons/cupertino_icon_list.dart';
import 'package:icon_icon/pages/emoji/emoji_helper.dart';
import 'package:icon_icon/pages/fluentui_icons/fluentui_icon_list.dart';
import 'package:icon_icon/pages/huge_icons_lookup/helper_huge_icons.dart';
import 'package:icon_icon/pages/iconoir_icons/iconoir_icon_list.dart';
import 'package:icon_icon/pages/material_icons/material_icons_list.dart'
    as material_icons_list;
import 'package:icon_icon/pages/material_symbols/material_symbols_list.dart'
    as material_symbols_list;
import 'package:rxdart/subjects.dart';

class OmnibusGlyphsService {
  // singleton pattern
  static final OmnibusGlyphsService _instance =
      OmnibusGlyphsService._internal();
  factory OmnibusGlyphsService() {
    return _instance;
  }
  OmnibusGlyphsService._internal() {
    _allIcons.addAll(iconsList.map<(String, Object)>((e) => (e.$1, e.$2)));
    _allIcons.addAll(
      cupertinoIconByName.map<(String, Object)>((e) => (e.$1, e.$2)),
    );
    _allIcons.addAll(emojisList.map<(String, Object)>((e) => (e.$1, e.$2)));
    _allIcons.addAll(
      fluentuiIconByName.map<(String, Object)>((e) => (e.$1, e.$2)),
    );
    _allIcons.addAll(hugeHelperList.map<(String, Object)>((e) => (e.$1, e.$2)));
    _allIcons.addAll(iconoirIcons.map<(String, Object)>((e) => (e.$1, e.$2)));
    _allIcons.addAll(
      material_icons_list.getAllIcons().map<(String, Object)>(
        (e) => (e.$1, e.$2),
      ),
    );
    _allIcons.addAll(
      material_symbols_list.getAllIcons().map<(String, Object)>(
        (e) => (e.$1, e.$2),
      ),
    );
    _refinedListBehaviorSubject.add(_allIcons);
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
