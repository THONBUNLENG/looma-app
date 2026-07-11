import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../../constants/app_color.dart';
import '../../../constants/string_extension.dart';
import '../../widget/text_widget.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  final List<Map<String, String>> languages = [
    {'name': 'ភាសាខ្មែរ', 'flag': '🇰🇭', 'code': 'km'},
    {'name': 'English', 'flag': '🇺🇸', 'code': 'en'},
    {'name': '中文', 'flag': '🇨🇳', 'code': 'cn'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentCode = translator.currentLocale?.languageCode;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'select language'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final lang = languages[index];
          final isSelected = currentCode == lang['code'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              tileColor: isDark
                  ? (isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05))
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColor.primaryColor
                      : (isDark ? Colors.white10 : Colors.transparent),
                  width: 2,
                ),
              ),
              leading: TextWidget(lang['flag']!, fontSize: 28),
              title: TextWidget(
                lang['name']!,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
              trailing: isSelected
                  ? const Icon(
                Icons.check_circle,
                color: AppColor.primaryColor,
                size: 26,
              )
                  : null,
              onTap: () {
                translator.translate(lang['code']!);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}