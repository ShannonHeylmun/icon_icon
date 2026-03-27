import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

List<(String, IconData)> getAllIcons() {
  List<String> names = MdiIcons.getNames();
  List<(String, IconData)> iconList = [];
  for (var name in names) {
    iconList.add((name, MdiIcons.fromString(name) ?? MdiIcons.imageBroken));
  }
  return iconList;
}
