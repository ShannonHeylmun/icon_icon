import 'package:flutter/services.dart';

/// Loads icon fonts on demand so they are excluded from the initial page load.
///
/// Family names must match the package-namespaced form Flutter uses internally
/// (`packages/<pkg>/<family>`), which is how the icon widgets look them up.
/// Asset paths must match the entries in FontManifest.json exactly.
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
    'packages/material_design_icons_flutter/Material Design Icons',
    'packages/material_design_icons_flutter/lib/fonts/materialdesignicons-webfont.ttf',
  );

  static Future<void> loadMaterialSymbols() => Future.wait([
    _load(
      'packages/material_symbols_icons/MaterialSymbolsOutlined',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsOutlined.ttf',
    ),
    _load(
      'packages/material_symbols_icons/MaterialSymbolsRounded',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsRounded.ttf',
    ),
    _load(
      'packages/material_symbols_icons/MaterialSymbolsSharp',
      'packages/material_symbols_icons/lib/fonts/MaterialSymbolsSharp.ttf',
    ),
  ]);

  static Future<void> loadFluentIcons() => Future.wait([
    _load(
      'packages/fluentui_system_icons/FluentSystemIcons-Regular',
      'packages/fluentui_system_icons/fonts/FluentSystemIcons-Regular.ttf',
    ),
    _load(
      'packages/fluentui_system_icons/FluentSystemIcons-Filled',
      'packages/fluentui_system_icons/fonts/FluentSystemIcons-Filled.ttf',
    ),
  ]);

  static Future<void> loadCupertinoIcons() => _load(
    'packages/cupertino_icons/CupertinoIcons',
    'packages/cupertino_icons/assets/CupertinoIcons.ttf',
  );

  static Future<void> loadAll() => Future.wait([
    loadMaterialDesignIcons(),
    loadMaterialSymbols(),
    loadFluentIcons(),
    loadCupertinoIcons(),
  ]);
}
