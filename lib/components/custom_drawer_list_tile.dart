import 'package:flutter/material.dart';
import 'package:icon_icon/main.dart';

class CustomDrawerListTile extends ListTile {
  CustomDrawerListTile({
    super.key,
    leadingWidget,
    super.tileColor = const Color.fromARGB(255, 171, 9, 9),
    @override textColor,
    @override iconColor,
    @override title,
    titleCopyText,
    required VoidCallback onTapCallback,
    required BuildContext context,
  }) : super(
         onTap: () {
           onTapCallback();
           drawerKey.currentState?.closeDrawer();
         },
         leading: ShaderMask(
           shaderCallback: (Rect bounds) {
             return RadialGradient(
               center: AlignmentGeometry.topCenter,
               radius: 10,
               colors: <Color>[textColor, textColor],
               tileMode: TileMode.repeated,
             ).createShader(bounds);
           },
           child: leadingWidget,
         ),
         title: Text(
           title,
           style: Theme.of(context).textTheme.titleLarge!.copyWith(
             color: textColor,
             fontWeight: FontWeight.bold,
             shadows: [
               Shadow(
                 offset: Offset(1.0, 1.0),
                 blurRadius: 3.0,
                 color: Color.fromARGB(255, 136, 136, 100),
               ),
             ],
           ),
         ),
       );
}
