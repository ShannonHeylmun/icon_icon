import 'dart:io';

final scripts = [
  'tool/gen_animated_icons_list.dart',
  'tool/gen_cupertino_icons.dart',
  'tool/gen_fluentui_icons.dart',
  'tool/gen_hugeicons.dart',
  'tool/gen_iconoir_list.dart',
];

Future<void> main() async {
  for (final script in scripts) {
    print('Running $script...');
    final result = await Process.run(
      'dart',
      ['run', script],
      workingDirectory: Directory.current.path,
    );
    stdout.write(result.stdout);
    if (result.stderr.toString().isNotEmpty) stderr.write(result.stderr);
    if (result.exitCode != 0) {
      print('Error: $script exited with code ${result.exitCode}');
      exit(result.exitCode);
    }
    print('Done: $script\n');
  }
  print('All scripts completed.');
}
