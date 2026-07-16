import 'dart:io';

void main() async {
  final extractedFile = File('extracted_strings.txt');
  if (!await extractedFile.exists()) {
    print('extracted_strings.txt not found');
    return;
  }

  final lines = await extractedFile.readAsLines();
  
  // Load existing translations
  final enFile = File('lib/localization/locale_en.dart');
  final kmFile = File('lib/localization/locale_km.dart');
  final chFile = File('lib/localization/locale_ch.dart');

  String enContent = await enFile.readAsString();
  String kmContent = await kmFile.readAsString();
  String chContent = await chFile.readAsString();

  StringBuffer enNewLines = StringBuffer();
  StringBuffer kmNewLines = StringBuffer();
  StringBuffer chNewLines = StringBuffer();

  for (var line in lines) {
    String key = line.trim();
    if (key.isEmpty) continue;

    // Check if already exists in English (as a simple check)
    if (!enContent.contains("'$key':") && !enContent.contains('"$key":')) {
      enNewLines.writeln("  '$key': '$key',");
      kmNewLines.writeln("  '$key': '$key', // TODO: Translate to Khmer");
      chNewLines.writeln("  '$key': '$key', // TODO: Translate to Chinese");
    }
  }

  if (enNewLines.isNotEmpty) {
    enContent = enContent.replaceFirst('};', '${enNewLines.toString()}};');
    kmContent = kmContent.replaceFirst('};', '${kmNewLines.toString()}};');
    chContent = chContent.replaceFirst('};', '${chNewLines.toString()}};');

    await enFile.writeAsString(enContent);
    await kmFile.writeAsString(kmContent);
    await chFile.writeAsString(chContent);
    print('Updated locale files with ${lines.length} potential new strings.');
  } else {
    print('No new strings to add.');
  }
}
