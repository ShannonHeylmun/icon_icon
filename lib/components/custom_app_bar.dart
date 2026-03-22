import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final TextEditingController? searchController;

  final Widget leadingIcon;
  final BuildContext context;
  final double? paddingLeft;
  final String titleText;

  CustomAppBar(
    this.context, {
    required this.leadingIcon,
    super.actions,
    super.backgroundColor,
    super.foregroundColor,
    super.key,
    this.paddingLeft,
    this.searchController,
    required this.titleText,
  }) : super(
         centerTitle: true,
         leadingWidth: 56,
         leading: GestureDetector(
           child: Padding(
             padding: EdgeInsetsGeometry.only(left: paddingLeft ?? 16),
             child: leadingIcon,
           ),
           onTap: () => Scaffold.of(context).openDrawer(),
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
       );
}
