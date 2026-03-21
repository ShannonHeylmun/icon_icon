import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/main.dart';

class CustomDrawerListTile extends ListTile {
  CustomDrawerListTile({
    super.key,
    leadingWidget,
    super.tileColor,
    textColor,
    iconColor,
    super.title,
    required VoidCallback onTapCallback,
  }) : super(
         onTap: () {
           onTapCallback();
           drawerKey.currentState?.closeDrawer();
         },
         leading: ShaderMask(
           shaderCallback: (Rect bounds) {
             return RadialGradient(
               center: Alignment.topLeft,
               radius: 1.0,
               colors: <Color>[
                 iconColor ?? Colors.grey.shade900,
                 iconColor ?? Colors.grey.shade900,
               ],
               tileMode: TileMode.mirror,
             ).createShader(bounds);
           },
           child: leadingWidget,
         ),
         textColor: textColor ?? Colors.grey.shade900,
         iconColor: iconColor ?? Colors.grey.shade900,
       );
}
