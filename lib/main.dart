import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/huge_icons_lookup/huge_icons_lookup_page.dart';

const Color seedColor = Color.fromRGBO(158, 225, 99, 1);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HugeIcons Lookup',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: seedColor)),
      home: const HugeIconsLookupPage(),
    );
  }
}
