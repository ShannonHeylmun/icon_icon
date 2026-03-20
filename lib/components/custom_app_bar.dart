import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  final TextEditingController searchController;
  final Color? color;
  final Widget leadingIcon;
  final BuildContext context;
  final double? paddingLeft;

  CustomAppBar(
    this.context, {
    super.key,
    this.color,
    this.paddingLeft,
    super.actions,
    required this.searchController,
    required this.leadingIcon,
  }) : super(
         backgroundColor: color,
         leadingWidth: 56,
         leading: GestureDetector(
           child: Padding(
             padding: EdgeInsetsGeometry.only(left: paddingLeft ?? 16),
             child: leadingIcon,
           ),
           onTap: () => Scaffold.of(context).openDrawer(),
         ),
         titleSpacing: 0,
         title: Padding(
           padding: const EdgeInsets.only(bottom: 8.0),
           child: TextField(
             style: TextStyle(
               fontSize: 18,
               color: Color.fromRGBO(31, 31, 31, 1),
             ),
             controller: searchController,
             decoration: InputDecoration(
               hintText: 'Search...',
               // Add a clear button to the search bar
               suffixIcon: IconButton(
                 icon: Icon(Icons.clear, color: Color.fromRGBO(31, 31, 31, 1)),
                 onPressed: () => searchController.clear(),
               ),
             ),
           ),
         ),
       );
}
