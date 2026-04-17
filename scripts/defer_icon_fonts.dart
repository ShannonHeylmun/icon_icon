import 'dart:convert';
import 'dart:io';

/// Removes deferred icon font families from build/web/FontManifest.json.
///
/// These fonts are excluded from the manifest so the Flutter engine does not
/// download them at startup. Instead, each page loads its fonts on demand via
/// FontLoader (see lib/services/icon_font_service.dart).
void main() {
  const manifestPath = 'build/web/FontManifest.json';
  const deferredFamilies = {
    'Material Design Icons',
    'MaterialSymbolsOutlined',
    'MaterialSymbolsRounded',
    'MaterialSymbolsSharp',
    'FluentSystemIcons-Regular',
    'FluentSystemIcons-Filled',
    'CupertinoIcons',
  };

  final file = File(manifestPath);
  if (!file.existsSync()) {
    stderr.writeln('FontManifest.json not found at $manifestPath');
    stderr.writeln('Run flutter build web first.');
    exit(1);
  }

  final manifest = jsonDecode(file.readAsStringSync()) as List<dynamic>;
  final filtered =
      manifest
          .where((e) => !deferredFamilies.contains(e['family'] as String))
          .toList();

  file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(filtered));

  final removed = manifest.length - filtered.length;
  stdout.writeln('Removed $removed deferred font families from FontManifest.json.');
  stdout.writeln('Remaining: ${filtered.map((e) => e['family']).join(', ')}');
}
