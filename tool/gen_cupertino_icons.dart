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
  // CupertinoIcons is defined in the Flutter SDK itself, not a pub package.
  // Locate it by searching the Flutter SDK relative to this script, or via
  // the FLUTTER_ROOT environment variable.
  final flutterRoot =
      Platform.environment['FLUTTER_ROOT'] ??
      _findFlutterRoot() ??
      (throw StateError(
        'Could not locate Flutter SDK. Set the FLUTTER_ROOT environment variable.',
      ));

  final srcFile = File(
    p.join(
      flutterRoot,
      'packages',
      'flutter',
      'lib',
      'src',
      'cupertino',
      'icons.dart',
    ),
  );

  if (!srcFile.existsSync()) {
    throw StateError(
      'icons.dart not found at ${srcFile.path}. '
      'Verify your Flutter SDK installation.',
    );
  }

  print('Found source file: ${srcFile.path}');

  final lines = srcFile.readAsLinesSync();
  print('Total lines in file: ${lines.length}');

  final entries = <String>[];
  final regex = RegExp(r'^\s*static\s+const\s+IconData\s+([A-Za-z0-9_]+)\s*=');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final m = regex.firstMatch(line);
    if (m != null) {
      final name = m.group(1)!;
      entries.add("  ('$name', CupertinoIcons.$name),");
    }
  }

  print('Matched entries: ${entries.length}');

  final out = StringBuffer();
  out.writeln('// GENERATED - do not edit by hand');
  out.writeln('// ignore_for_file: prefer_single_quotes');
  out.writeln('import \'package:flutter/cupertino.dart\';');
  out.writeln('');
  out.writeln('final List<(String, IconData)> cupertinoIconByName = [');
  for (final e in entries) {
    out.writeln(e);
  }
  out.writeln('];');

  File(
    'lib/cupertino_icons/cupertino_icon_list.dart',
  ).writeAsStringSync(out.toString());
  print('wrote ${entries.length} entries');
}

/// Walk up from the script location looking for a directory that looks like
/// a Flutter SDK root (contains packages/flutter/lib).
String? _findFlutterRoot() {
  // Try FLUTTER_ROOT first (set by flutter tool at runtime).
  final fromEnv = Platform.environment['FLUTTER_ROOT'];
  if (fromEnv != null && Directory(fromEnv).existsSync()) return fromEnv;

  // Try to resolve via `flutter` on PATH.
  final whichResult = Process.runSync('which', ['flutter']);
  if (whichResult.exitCode == 0) {
    // e.g. /some/path/flutter/bin/flutter  →  /some/path/flutter
    final flutterBin = (whichResult.stdout as String).trim();
    final candidate = p.dirname(p.dirname(flutterBin));
    if (File(p.join(candidate, 'packages', 'flutter', 'lib', 'src', 'cupertino', 'icons.dart')).existsSync()) {
      return candidate;
    }
  }

  return null;
}
