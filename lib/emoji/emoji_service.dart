import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/emoji/emoji_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

class EmojiService {
  // singleton pattern
  static final EmojiService _instance = EmojiService._internal();
  factory EmojiService() {
    return _instance;
  }
  EmojiService._internal() {
    _searchController.addListener(() {
      String searchTerm = _searchController.text.toLowerCase();
      _refinedList = emojiList
          .where(
            (emoji) =>
                emoji.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
                emoji.emoji == searchTerm ||
                emoji.unified.contains(searchTerm),
          )
          .toList();
      _refinedListBehaviorSubject.add(_refinedList);
    });
  }

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<Emoji> _refinedList;
  List<Emoji> get refinedList => _refinedList;

  final BehaviorSubject<List<Emoji>> _refinedListBehaviorSubject =
      BehaviorSubject.seeded(emojiList);

  Stream<List<Emoji>> get refinedListStream =>
      _refinedListBehaviorSubject.stream;
}
