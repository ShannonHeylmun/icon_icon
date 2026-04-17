import 'package:flutter/services.dart';

class IconFontService {
  static bool _mdiLoaded = false;
  static Future<void>? _mdiLoadFuture;

  static Future<void> loadMaterialDesignIcons() {
    if (_mdiLoaded) return Future.value();
    _mdiLoadFuture ??= _doLoad();
    return _mdiLoadFuture!;
  }

  static Future<void> _doLoad() async {
    final loader = FontLoader('Material Design Icons');
    loader.addFont(
      rootBundle.load(
        'packages/material_design_icons_flutter/fonts/materialdesignicons-webfont.ttf',
      ),
    );
    await loader.load();
    _mdiLoaded = true;
  }
}
