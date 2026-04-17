import 'dart:convert';
import 'dart:io';

/// Removes deferred icon font families from FontManifest.json.
///
/// Usage: dart scripts/defer_icon_fonts.dart [path/to/FontManifest.json]
/// Defaults to docs/assets/FontManifest.json.
///
/// These fonts are excluded from the manifest so the Flutter engine does not
/// download them at startup. Each page loads its fonts on demand via
/// FontLoader (see lib/services/icon_font_service.dart).
///
/// Family names use the package-namespaced form Flutter generates:
/// `packages/<pkg>/<family>` for package-declared fonts.
void main(List<String> args) {
  final manifestPath = args.isNotEmpty
      ? args[0]
      : 'docs/assets/FontManifest.json';

  const deferredFamilies = {
    // Project-level declaration (legacy builds before it was removed)
    'Material Design Icons',
    // Package-level declarations (always present via each package's pubspec)
    'packages/material_design_icons_flutter/Material Design Icons',
    'packages/material_symbols_icons/MaterialSymbolsOutlined',
    'packages/material_symbols_icons/MaterialSymbolsRounded',
    'packages/material_symbols_icons/MaterialSymbolsSharp',
    'packages/fluentui_system_icons/FluentSystemIcons-Regular',
    'packages/fluentui_system_icons/FluentSystemIcons-Filled',
    'packages/cupertino_icons/CupertinoIcons',
  };

  final file = File(manifestPath);
  if (!file.existsSync()) {
    stderr.writeln('FontManifest.json not found at $manifestPath');
    exit(1);
  }

  final manifest = jsonDecode(file.readAsStringSync()) as List<dynamic>;
  final filtered =
      manifest
          .where((e) => !deferredFamilies.contains(e['family'] as String))
          .toList();

  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(filtered));

  final removed = manifest.length - filtered.length;
  stdout.writeln(
    'Removed $removed deferred font families from $manifestPath.',
  );
  stdout.writeln(
    'Remaining: ${filtered.map((e) => e['family']).join(', ')}',
  );
}
