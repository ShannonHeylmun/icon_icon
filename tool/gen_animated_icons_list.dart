import 'dart:io';
import 'package:path/path.dart' as p;

/// Finds the Flutter SDK root via (in order):
///   1. FLUTTER_ROOT env var
///   2. Resolving the `flutter` executable on PATH
Directory findFlutterSdk() {
  final fromEnv = Platform.environment['FLUTTER_ROOT'];
  if (fromEnv != null && fromEnv.isNotEmpty) {
    final dir = Directory(fromEnv);
    if (dir.existsSync()) return dir;
  }

  // Walk PATH entries looking for the `flutter` binary
  final pathEnv = Platform.environment['PATH'] ?? '';
  final separator = Platform.isWindows ? ';' : ':';
  for (final dir in pathEnv.split(separator)) {
    final exe = File(
      p.join(dir, Platform.isWindows ? 'flutter.bat' : 'flutter'),
    );
    if (exe.existsSync()) {
      // bin/flutter → SDK root is two levels up from the resolved symlink
      final resolved = exe.resolveSymbolicLinksSync();
      return Directory(p.dirname(p.dirname(resolved)));
    }
  }

  throw StateError(
    'Flutter SDK not found. Set FLUTTER_ROOT or ensure `flutter` is on PATH.',
  );
}

File findAnimatedIconsSource(Directory sdkRoot) {
  // Standard location inside the Flutter repo / SDK
  final candidates = [
    p.join(
      sdkRoot.path,
      'packages',
      'flutter',
      'lib',
      'src',
      'material',
      'animated_icons',
      'animated_icons_data.dart',
    ),
    p.join(
      sdkRoot.path,
      'packages',
      'flutter',
      'lib',
      'src',
      'material',
      'animated_icons',
      'animated_icons.dart',
    ),
    // Older SDK layouts kept it directly in material/
    p.join(
      sdkRoot.path,
      'packages',
      'flutter',
      'lib',
      'src',
      'material',
      'animated_icons.dart',
    ),
  ];

  for (final c in candidates) {
    final f = File(c);
    if (f.existsSync()) return f;
  }

  throw StateError(
    'animated_icons.dart not found under ${sdkRoot.path}.\n'
    'Tried:\n${candidates.map((c) => '  $c').join('\n')}',
  );
}

/// Extracts names of static AnimatedIconData fields from the AnimatedIcons class.
Iterable<String> parseAnimatedIconNames(File source) sync* {
  // Pattern: `static const AnimatedIconData name = ...`
  final fieldRegex = RegExp(
    r'^\s*static\s+const\s+AnimatedIconData\s+([a-z_][a-zA-Z0-9_]*)',
  );

  for (final line in source.readAsLinesSync()) {
    final m = fieldRegex.firstMatch(line);
    if (m != null) yield m.group(1)!;
  }
}

/// Groups icon names into pairs where the name segments are reversed
/// (e.g. "arrow_menu" / "menu_arrow"), then sorts groups by their
/// alphabetically-first member and lists each pair in alphabetical order.
List<List<String>> groupIntoPairs(List<String> names) {
  final remaining = names.toSet();
  final pairs = <List<String>>[];

  for (final name in names) {
    if (!remaining.contains(name)) continue;
    remaining.remove(name);

    final parts = name.split('_');
    final reverseName = parts.reversed.join('_');

    if (remaining.contains(reverseName)) {
      remaining.remove(reverseName);
      final pair = [name, reverseName]..sort();
      pairs.add(pair);
    } else {
      pairs.add([name]);
    }
  }

  // Sort groups by their alphabetically-first member
  pairs.sort((a, b) => a.first.compareTo(b.first));
  return pairs;
}

void main() {
  final sdkRoot = findFlutterSdk();
  final sourceFile = findAnimatedIconsSource(sdkRoot);

  final names = parseAnimatedIconNames(sourceFile).toList()..sort();

  if (names.isEmpty) {
    throw StateError(
      'No AnimatedIconData fields parsed from ${sourceFile.path}',
    );
  }

  final groups = groupIntoPairs(names);

  final out = StringBuffer()
    ..writeln('// GENERATED - do not edit by hand')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln('')
    ..writeln('final List<(String, AnimatedIconData)> iconsList = [');

  for (final group in groups) {
    for (final name in group) {
      out.writeln("  ('$name', AnimatedIcons.$name),");
    }
    if (group.length > 1) out.writeln(); // blank line between pairs
  }

  out.writeln('];');

  final outputFile = File('lib/pages/animated_icons/animated_helper.dart');
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(out.toString());

  print('wrote ${names.length} entries to ${outputFile.path}');
}
