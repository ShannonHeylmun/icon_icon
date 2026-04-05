import 'package:flutter/material.dart';
import 'package:icon_icon/components/helpers.dart';
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
    Widget? trailing,
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
                 blurRadius: 2.0,
                 color: contrastColor(textColor),
               ),
             ],
           ),
         ),
         trailing: trailing,
       );
}
