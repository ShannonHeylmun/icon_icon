import 'package:flutter/material.dart';
import 'package:icon_icon/emoji/emoji_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

class EmojiService {
  // singleton pattern
  static final EmojiService _instance = EmojiService._internal();
  factory EmojiService() {
    return _instance;
  }
  EmojiService._internal() {
    getAllEmoji();
    _searchController.addListener(_updateRefinedList);
  }

  void _updateRefinedList() {
    final searchTerm = _searchController.text.toLowerCase();

    _refinedList = getAllEmoji().where((item) {
      return item.$1.toLowerCase().contains(searchTerm) ||
          item.$2.emoji == searchTerm ||
          (item.$2.text != null &&
              item.$2.text!.toLowerCase().contains(searchTerm)) ||
          (item.$2.skinVariations?.any(
                (skinVariantEmoji) =>
                    skinVariantEmoji.emoji == searchTerm ||
                    skinVariantEmoji.unified.toLowerCase().contains(searchTerm),
              ) ??
              false) ||
          item.$2.unified.toLowerCase().contains(searchTerm) ||
          item.$2.shortName.toLowerCase().contains(searchTerm);
    }).toList();
    _refinedListBehaviorSubject.add(_refinedList);
  }

  List<(String, Emoji)> getAllEmoji() {
    return emojisList;
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<(String, Emoji)> _refinedList;
  List<(String, Emoji)> get refinedList => _refinedList;

  final BehaviorSubject<List<(String, Emoji)>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded(emojisList);

  Stream<List<(String, Emoji)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
