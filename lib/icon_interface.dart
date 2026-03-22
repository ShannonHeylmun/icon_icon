import 'package:flutter/material.dart';

class IconInterface {
  final Widget glyph;
  final String mainText;
  final String secondaryText;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPressCallback;
  IconInterface({
    required this.glyph,
    required this.mainText,
    required this.secondaryText,
    required this.onDoubleTap,
    required this.onLongPressCallback,
  });
}
