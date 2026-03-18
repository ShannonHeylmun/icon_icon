import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_showcase/emoji/emoji_service.dart';
import 'package:unicode_emojis/unicode_emojis.dart';

class EmojiScreen extends StatelessWidget {
  const EmojiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              UnicodeEmojis.allEmojis.first.emoji,
              style: TextStyle(fontSize: 36),
            ),
          ),
          onTap: () => Scaffold.of(context).openDrawer(),
        ),
        leadingWidth: 42,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
          // Add padding around the search bar
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // Use a Material design search bar
          child: TextField(
            controller: EmojiService().searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              // Add a clear button to the search bar
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () => EmojiService().searchController.clear(),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: EmojiService().refinedListStream,
        builder: (context, AsyncSnapshot<List<Object>> asyncSnapshot) {
          List<Object> iconsToShow = asyncSnapshot.data ?? [];
          return ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: iconsToShow[index] is Emoji
                    ? Text(
                        (iconsToShow[index] as Emoji).emoji,
                        style: TextStyle(fontSize: 32),
                      )
                    : null,
                title: Text((iconsToShow[index] as Emoji).name),
                dense: true,
                subtitle: Text((iconsToShow[index] as Emoji).unified),
                onTap: () async {
                  await FlutterClipboard.copy(
                    (iconsToShow[index] as Emoji).emoji,
                  );
                },
                onLongPress: () async {
                  await FlutterClipboard.copy(
                    "U+${(iconsToShow[index] as Emoji).unified}",
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
