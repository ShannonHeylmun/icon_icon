import 'package:flutter/services.dart';

class IconFontService {
  static final Map<String, Future<void>> _futures = {};

  static Future<void> _load(String family, String assetPath) {
    return _futures.putIfAbsent(family, () async {
      final loader = FontLoader(family);
      loader.addFont(rootBundle.load(assetPath));
      await loader.load();
    });
  }

  static Future<void> loadMaterialDesignIcons() => _load(
    'Material Design Icons',
    'packages/material_design_icons_flutter/fonts/materialdesignicons-webfont.ttf',
  );

  static Future<void> loadMaterialSymbols() => Future.wait([
    _load(
      'MaterialSymbolsOutlined',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsOutlined.ttf',
    ),
    _load(
      'MaterialSymbolsRounded',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsRounded.ttf',
    ),
    _load(
      'MaterialSymbolsSharp',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsSharp.ttf',
    ),
  ]);

  static Future<void> loadFluentIcons() => Future.wait([
    _load(
      'FluentSystemIcons-Regular',
      'packages/fluentui_system_icons/fonts/FluentSystemIcons-Regular.ttf',
    ),
    _load(
      'FluentSystemIcons-Filled',
      'packages/fluentui_system_icons/fonts/FluentSystemIcons-Filled.ttf',
    ),
  ]);

  static Future<void> loadCupertinoIcons() => _load(
    'CupertinoIcons',
    'packages/cupertino_icons/assets/CupertinoIcons.ttf',
  );

  static Future<void> loadAll() => Future.wait([
    loadMaterialDesignIcons(),
    loadMaterialSymbols(),
    loadFluentIcons(),
    loadCupertinoIcons(),
  ]);
}
