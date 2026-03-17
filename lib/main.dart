import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:clipboard/clipboard.dart';
import 'package:hugeicons_showcase/icons_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'HugeIcons Lookup'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Container(
          // Add padding around the search bar
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          // Use a Material design search bar
          child: TextField(
            controller: IconsService().searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              // Add a clear button to the search bar
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () => IconsService().searchController.clear(),
              ),
              // Add a search icon or button to the search bar
              prefixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  // Perform the search here
                },
              ),
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(20.0),
              // ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: IconsService().refinedListStream,
        builder: (context, asyncSnapshot) {
          List<(String, List<List<dynamic>>)> iconsToShow =
              asyncSnapshot.data ?? [];
          return ListView.builder(
            itemCount: iconsToShow.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: HugeIcon(icon: iconsToShow[index].$2, size: 48),
                title: Text(iconsToShow[index].$1),
                onLongPress: () async {
                  await FlutterClipboard.copy(
                    "HugeIconsStrokeRounded.strokeRounded${iconsToShow[index].$1}",
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
