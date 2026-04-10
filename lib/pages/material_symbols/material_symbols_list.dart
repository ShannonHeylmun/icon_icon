import 'package:flutter/material.dart';
import 'package:material_symbols_icons/get.dart';

List<(String, IconData)> getAllIcons({
  SymbolStyle style = SymbolStyle.rounded,
}) {
  List<String> names = SymbolsGet.values.toList();
  List<(String, IconData)> icons = [];
  for (var name in names) {
    icons.add((name, SymbolsGet.get(name, style)));
  }
  return icons;
}
