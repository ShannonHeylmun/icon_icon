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
  final explicit = Platform.environment['HUGEICONS_PKG'];
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
        (f) =>
            p.basename(f.path) == 'hugeicons.dart' &&
            f.path.contains('hugeicons-'),
        orElse: () => throw StateError(
          'hugeicons.dart not found. Ensure "flutter pub get" has been run.',
        ),
      );

  print('Found source file: ${srcFile.path}');

  final lines = srcFile.readAsLinesSync();
  print('Total lines in file: ${lines.length}');

  final entries = <String>[];
  // Matches: static const List<List<dynamic>> strokeRoundedFooBar =
  final regex = RegExp(
    r'^\s*static\s+const\s+List<List<dynamic>>\s+(strokeRounded[A-Za-z0-9_]+)\s*=',
  );
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final m = regex.firstMatch(line);
    if (m != null) {
      final fullName = m.group(1)!;
      // Strip the "strokeRounded" prefix for the display name
      final shortName = fullName.replaceFirst('strokeRounded', '');
      entries.add('  ("$shortName", HugeIcons.$fullName),');
    }
  }

  print('Matched entries: ${entries.length}');

  final out = StringBuffer();
  out.writeln('// GENERATED - do not edit by hand');
  out.writeln('// ignore_for_file: prefer_single_quotes');
  out.writeln('import \'package:hugeicons/hugeicons.dart\';');
  out.writeln('');
  out.writeln('List<(String, List<List<dynamic>>)> hugeHelperList = [');
  for (var e in entries) {
    out.writeln(e);
  }
  out.writeln('];');
  File(
    'lib/pages/huge_icons_lookup/helper_huge_icons.dart',
  ).writeAsStringSync(out.toString());
  print('wrote ${entries.length} entries');
}
