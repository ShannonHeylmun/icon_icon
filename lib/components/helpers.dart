import 'package:flutter/material.dart';
import 'package:icon_icon/colors.dart';

Color contrastColor(Color color) {
  // Counting the perceptive luminance - human eye favors green color...
  double luminance = color.computeLuminance();
  if (luminance > 0.3) {
    return creditsColor;
  } else {
    return Colors.white.withAlpha(240);
  }
}
