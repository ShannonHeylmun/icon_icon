import "package:unicode_emojis/unicode_emojis.dart";

List<Emoji> emojiList = UnicodeEmojis.allEmojis;

List<(String, Emoji)> emojisList = emojiList
    .map((toElement) => (toElement.name, toElement))
    .toList();
