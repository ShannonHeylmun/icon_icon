import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hugeicons_showcase/main.dart';

Color contrastColor(Color color) {
  // Counting the perceptive luminance - human eye favors green color...
  double luminance =
      (pow((color.r * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.2126 +
          pow((color.g * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.7152 +
          pow((color.b * 255.0).round().clamp(0, 255) / 255, 2.2) * 0.0722) *
      color.a;
  if (luminance > 0.015) {
    return creditsColor;
  } else {
    return Colors.white.withAlpha(240);
  }
}
