import 'package:flutter/material.dart';
import 'package:icon_icon/main.dart';

void setBrightness(ThemeMode themeMode) {
  brightnessStreamController.add(themeMode);
}

void toggleBrightness() {
  if (brightnessStreamController.stream.value == ThemeMode.light) {
    setBrightness(ThemeMode.dark);
  } else {
    setBrightness(ThemeMode.light);
  }
}

class CustomAppBar extends AppBar {
  final TextEditingController? searchController;

  final Widget leadingIcon;
  final BuildContext context;
  final double? paddingLeft;
  final String titleText;
  final List<Widget>? supplementaryActions;

  CustomAppBar(
    this.context, {
    required this.leadingIcon,
    this.supplementaryActions,
    super.backgroundColor,
    super.foregroundColor,
    super.key,
    this.paddingLeft,
    this.searchController,
    required this.titleText,
  }) : super(
         centerTitle: true,
         leadingWidth: 56,
         leading: IconButton(
           icon: Center(child: leadingIcon),
           onPressed: () => Scaffold.of(context).openDrawer(),
         ),
         titleSpacing: 0,
         title: Text(
           titleText,
           style: Theme.of(context).textTheme.titleLarge!.copyWith(
             color: foregroundColor,
             fontWeight: FontWeight.bold,
             fontFamily: 'sans',
           ),
         ),
         actions: [
           //  Icon(Icons.dark_mode),
           //  Switch(
           //    value: brightnessStreamController.stream.value == ThemeMode.light,
           //    onChanged: toggleBrightness(),
           //  ),
           //  Icon(Icons.light_mode),
           if (supplementaryActions != null) ...supplementaryActions,
         ],
       );
}
