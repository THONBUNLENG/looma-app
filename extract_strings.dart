import 'dart:io';

void main() async {
  final file = File('lib/src/screen/list_url.dart');
  if (!await file.exists()) {
    print('File not found');
    return;
  }

  final content = await file.readAsString();
  final titleRegex = RegExp(r"'title':\s*'([^']+)'");
  final descRegex = RegExp(r"'description':\s*'([^']+)'");
  final descMultilineRegex = RegExp(r"'description':\s*\n\s*'([^']+)'");

  final titles = titleRegex.allMatches(content).map((m) => m.group(1)!).toList();
  final descs = descRegex.allMatches(content).map((m) => m.group(1)!).toList();
  final descsMultiline = descMultilineRegex.allMatches(content).map((m) => m.group(1)!).toList();

  final allStrings = <String>{...titles, ...descs, ...descsMultiline}.toList()..sort();

  final output = File('extracted_strings.txt');
  await output.writeAsString(allStrings.join('\n'));
  print('Extracted ${allStrings.length} strings to extracted_strings.txt');
}
