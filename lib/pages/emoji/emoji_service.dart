import 'package:flutter/material.dart';
import 'package:icon_icon/pages/emoji/emoji_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

class EmojiService {
  // singleton pattern
  static final EmojiService _instance = EmojiService._internal();
  factory EmojiService() {
    return _instance;
  }
  EmojiService._internal() {
    Future(() => _refinedListBehaviorSubject.add(emojisList));
    _searchController.addListener(_updateRefinedList);
  }

  bool _matchesName(String name, String searchTerm) =>
      name.toLowerCase().contains(searchTerm);

  bool _matchesEmoji(Emoji emoji, String searchTerm) =>
      emoji.emoji == searchTerm;

  bool _matchesTextOrTexts(Emoji emoji, String searchTerm) {
    return emoji.text?.contains(searchTerm) ??
        emoji.text?.contains(searchTerm.toLowerCase()) ??
        emoji.texts?.any((a) => a.contains(searchTerm)) ??
        emoji.texts?.any((a) => a.contains(searchTerm)) ??
        false;
  }

  bool _matchesUnified(Emoji emoji, String searchTerm) =>
      emoji.unified.toLowerCase().contains(searchTerm);

  bool _matchesShortName(Emoji emoji, String searchTerm) =>
      emoji.shortName.toLowerCase().contains(searchTerm);

  bool _matchesCategory(Emoji emoji, String searchTerm) =>
      emoji.category.name.toLowerCase().contains(searchTerm) ||
      emoji.category.description.toLowerCase().contains(searchTerm);

  bool _matchesSkinVariation(Emoji emoji, String searchTerm) =>
      emoji.skinVariations?.any(
        (v) =>
            v.emoji == searchTerm ||
            v.unified.toLowerCase().contains(searchTerm),
      ) ??
      false;

  bool _emojiMatchesSearch((String, Emoji) item) {
    final searchTerm = _searchController.text.toLowerCase();
    final (name, emoji) = item;
    return _matchesName(name, searchTerm) ||
        _matchesEmoji(emoji, searchTerm) ||
        _matchesUnified(emoji, searchTerm) ||
        _matchesShortName(emoji, searchTerm) ||
        _matchesSkinVariation(emoji, searchTerm) ||
        _matchesCategory(emoji, searchTerm) ||
        _matchesTextOrTexts(emoji, _searchController.text);
  }

  void _updateRefinedList() {
    _refinedList = getAllEmoji()
        .where((item) => _emojiMatchesSearch(item))
        .toList();
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
      BehaviorSubject.seeded([]);

  Stream<List<(String, Emoji)>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
