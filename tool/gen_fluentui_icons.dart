import 'dart:io';
import 'package:path/path.dart' as p;

String resolveTilde(String path) {
  if (path == '~') return Platform.environment['HOME'] ?? '';
  if (path.startsWith('~/') || path.startsWith('~\\')) {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    if (home.isEmpty) {
      throw StateError('HOME/USERPROFILE not set');
    }
    return p.join(home, path.substring(2));
  }
  return path;
}

void main() {
  final explicit = Platform.environment['FLUENT_PKG'];
  final baseDir = explicit != null
      ? Directory(resolveTilde(explicit))
      : Directory(resolveTilde('~/.pub-cache'));
  if (!baseDir.existsSync()) {
    throw StateError(
      'baseDir does not exist: ${baseDir.path}. Run "flutter pub cache dir" to verify.',
    );
  }

  final srcFile = baseDir
      .listSync(recursive: true)
      .whereType<File>()
      .firstWhere(
        (f) => p.basename(f.path) == 'fluent_icons.dart',
        orElse: () => throw StateError(
          'fluent_icons.dart not found. Ensure "flutter pub get" has been run.',
        ),
      );

  print('Found source file: ${srcFile.path}'); // Debug: confirm path

  final lines = srcFile.readAsLinesSync();
  print('Total lines in file: ${lines.length}'); // Debug: check line count

  final entries = <String>[];
  final regex = RegExp(r'^\s*static\s+const\s+IconData\s+([A-Za-z0-9_]+)\s*=');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final m = regex.firstMatch(line);
    if (m != null) {
      final name = m.group(1)!;
      entries.add("  ('$name', FluentIcons.$name),");
    } else if (line.contains('static const IconData')) {
      print(
        'Line $i did not match regex: $line',
      ); // Debug: show unmatched lines
    }
  }

  print('Matched entries: ${entries.length}'); // Debug: confirm matches

  final out = StringBuffer();
  out.writeln('// GENERATED - do not edit by hand');
  out.writeln('// ignore_for_file: prefer_single_quotes');
  out.writeln(
    'import \'package:fluentui_system_icons/fluentui_system_icons.dart\';',
  );
  out.writeln('import \'package:flutter/widgets.dart\';');
  out.writeln('');
  out.writeln('final List<(String, IconData)> fluentuiIconByName = [');
  for (var e in entries) out.writeln(e);
  out.writeln('];');
  File(
    'lib/fluentui_icons/fluentui_icon_list.dart',
  ).writeAsStringSync(out.toString());
  print('wrote ${entries.length} entries');
}
