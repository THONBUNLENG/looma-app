import 'dart:io';

void main() {
  final enFile = File('lib/localization/locale_en.dart');
  final kmFile = File('lib/localization/locale_km.dart');
  final chFile = File('lib/localization/locale_ch.dart');

  final enPairs = extractPairs(enFile.readAsStringSync());
  final kmPairs = extractPairs(kmFile.readAsStringSync());
  final chPairs = extractPairs(chFile.readAsStringSync());

  final allStrings = <String>{};

  final dir = Directory('lib');
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      if (entity.path.contains('localization/')) continue;
      final content = entity.readAsStringSync();

      // Better regex for .tr strings
      // Matches "text".tr or 'text'.tr, handling escaped quotes
      final trRegExp = RegExp(r"(['\u0022])((?:(?!\1).|\\.)*?)\1\.tr");
      for (final m in trRegExp.allMatches(content)) {
        allStrings.add(unescape(m.group(2)!));
      }

      // Matches .trArgs
      final traRegExp = RegExp(r"(['\u0022])((?:(?!\1).|\\.)*?)\1\.trArgs");
      for (final m in traRegExp.allMatches(content)) {
        allStrings.add(unescape(m.group(2)!));
      }

      // Matches TextWidget
      final twRegExp = RegExp(r"TextWidget\(\s*(['\u0022])((?:(?!\1).|\\.)*?)\1");
      for (final m in twRegExp.allMatches(content)) {
        allStrings.add(unescape(m.group(2)!));
      }
    }
  }

  // Filter valid strings
  final validStrings = allStrings.where((s) {
    if (s.trim().isEmpty) return false;
    if (s.startsWith('\$') && !s.contains(' ')) return false; // Probably just a variable
    if (s.length < 2 && !RegExp(r'[a-zA-Z]').hasMatch(s)) return false;
    return true;
  }).toList();

  final mergedEn = Map<String, String>.from(enPairs);
  for (final s in validStrings) {
    if (!mergedEn.containsKey(s)) {
      mergedEn[s] = s;
    }
  }

  // Update English
  updateFile('lib/localization/locale_en.dart', mergedEn, 'english');
  
  // Re-read English to get the final set of keys
  final finalEn = extractPairs(File('lib/localization/locale_en.dart').readAsStringSync());
  
  // Sync Khmer and Chinese
  syncLocale('lib/localization/locale_km.dart', finalEn, kmPairs, 'khmer');
  syncLocale('lib/localization/locale_ch.dart', finalEn, chPairs, 'chinese');
  
  print('Total keys in final set: ${finalEn.length}');
  print('Sync V2 complete.');
}

String unescape(String s) {
  return s.replaceAll('\\\'', "'").replaceAll('\\"', '"').replaceAll('\\\$', '\$').replaceAll('\\n', '\n');
}

String escape(String s) {
  return s.replaceAll("'", "\\'").replaceAll('\n', '\\n').replaceAll('\$', '\\\$');
}

Map<String, String> extractPairs(String content) {
  final pairs = <String, String>{};
  // Matches 'key': 'value', with multi-line support
  final regExp = RegExp(r"^\s+(['\u0022])((?:(?!\1).|\\.)*?)\1\s*:\s*(['\u0022])((?:(?!\3).|\\.)*?)\3,", multiLine: true);
  for (final m in regExp.allMatches(content)) {
    pairs[unescape(m.group(2)!)] = unescape(m.group(4)!);
  }
  return pairs;
}

void updateFile(String filePath, Map<String, String> pairs, String varName) {
  final buffer = StringBuffer('const Map<String, String> $varName = {\n');
  final sortedKeys = pairs.keys.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  for (final key in sortedKeys) {
    final escapedKey = escape(key);
    final escapedValue = escape(pairs[key]!);
    buffer.writeln("  '$escapedKey': '$escapedValue',");
  }
  buffer.writeln('};');
  File(filePath).writeAsStringSync(buffer.toString());
  print('Updated $filePath');
}

void syncLocale(String filePath, Map<String, String> enPairs, Map<String, String> currentPairs, String varName) {
  final synced = <String, String>{};
  for (final key in enPairs.keys) {
    synced[key] = currentPairs[key] ?? enPairs[key]!;
  }
  updateFile(filePath, synced, varName);
}
