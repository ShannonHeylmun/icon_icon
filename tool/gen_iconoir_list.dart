import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

String resolveTilde(String path) {
  if (path == '~') return Platform.environment['HOME'] ?? '';
  if (path.startsWith('~/') || path.startsWith('~\\')) {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    if (home.isEmpty) throw StateError('HOME/USERPROFILE not set');
    return p.join(home, path.substring(2));
  }
  return path;
}

Directory getPackageDirFromConfig(String packageName) {
  final config = File('.dart_tool/package_config.json');
  if (!config.existsSync()) {
    throw StateError(
      '.dart_tool/package_config.json not found; run flutter pub get',
    );
  }

  final data = jsonDecode(config.readAsStringSync()) as Map<String, dynamic>;
  final packages = (data['packages'] as List<dynamic>?);
  if (packages == null) {
    throw StateError('package_config missing packages entry');
  }

  for (final entry in packages.cast<Map<String, dynamic>>()) {
    if (entry['name'] == packageName) {
      final rootUri = entry['rootUri'] as String?;
      if (rootUri == null) continue;
      final dir = Uri.parse(rootUri).isAbsolute
          ? Directory(Uri.parse(rootUri).toFilePath())
          : Directory(
              p.join(Directory.current.path, Uri.parse(rootUri).toFilePath()),
            );
      if (dir.existsSync()) return dir;
    }
  }

  throw StateError('Package $packageName not found in package_config.json');
}

String _basenameToClass(String basename) {
  final parts = basename
      .replaceAll('.dart', '')
      .replaceAll('-', '_')
      .split('_')
      .where((p) => p.isNotEmpty)
      .map((p) => p[0].toUpperCase() + p.substring(1))
      .toList();
  return parts.join();
}

Iterable<String> collectIconoirIconClasses(Directory packageDir) sync* {
  final libDir = Directory(p.join(packageDir.path, 'lib'));
  if (!libDir.existsSync()) {
    throw StateError('iconoir lib directory not found: ${libDir.path}');
  }

  final classRegex = RegExp(
    r'^\s*class\s+([A-Za-z0-9_]+)\s+extends\s+[A-Za-z0-9_<>]+',
  );
  for (final f
      in libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))) {
    final lines = f.readAsLinesSync();
    for (final line in lines) {
      final m = classRegex.firstMatch(line);
      if (m != null) {
        yield m.group(1)!;
      }
    }
  }
}

Iterable<String> collectIconoirFromExports(Directory packageDir) sync* {
  final main = File(p.join(packageDir.path, 'lib', 'iconoir_flutter.dart'));
  if (!main.existsSync()) return;
  final exportRegex = RegExp(r'''^\s*export\s+['"](.+?\.dart)['"]''');
  for (final line in main.readAsLinesSync()) {
    final m = exportRegex.firstMatch(line);
    if (m != null) {
      final target = m.group(1)!;
      final base = p.basename(target);
      final className = _basenameToClass(base);
      if (className.isNotEmpty) yield className;
    }
  }
}

void main() {
  final explicit = Platform.environment['ICONOIR_PKG'];
  final packageDir = explicit != null
      ? Directory(resolveTilde(explicit))
      : getPackageDirFromConfig('iconoir_flutter');

  if (!packageDir.existsSync()) {
    throw StateError('iconoir package path does not exist: ${packageDir.path}');
  }

  final iconNames = <String>{
    ...collectIconoirIconClasses(packageDir),
    ...collectIconoirFromExports(packageDir),
  }.toList()..sort();

  if (iconNames.isEmpty) {
    throw StateError('No icon entries parsed from ${packageDir.path}');
  }

  final out = StringBuffer()
    ..writeln('// GENERATED - do not edit by hand')
    ..writeln('// ignore_for_file: prefer_single_quotes')
    ..writeln(
      "import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;",
    )
    ..writeln('')
    ..writeln('')
    ..writeln('const iconoirIcons = [');

  for (final name in iconNames) {
    out.writeln("  ('$name', iconoir.$name()),");
  }

  out.writeln('];');

  final outputFile = File('lib/pages/iconoir_icons/iconoir_icon_list.dart');
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(out.toString());

  print('wrote ${iconNames.length} entries to ${outputFile.path}');
}
