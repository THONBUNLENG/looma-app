import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final Map<String, List<Map<String, dynamic>>> _sections = {
    'System': [
      {'title': 'General Notification', 'value': true},
      {'title': 'Sound', 'value': true},
      {'title': 'Vibrate', 'value': false},
    ],
    'Promotions': [
      {'title': 'Special Offers', 'value': true},
      {'title': 'Promo & Discount', 'value': false},
      {'title': 'Cashback', 'value': false},
    ],
    'Activity': [
      {'title': 'Payments', 'value': true},
      {'title': 'App Updates', 'value': true},
      {'title': 'New Service Available', 'value': false},
      {'title': 'New Tips Available', 'value': false},
    ],
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final pushEnabled = NotificationService.isPushEnabled();
    setState(() {
      for (var section in _sections.values) {
        for (var item in section) {
          final title = item['title'] as String;
          if (title == 'General Notification') {
            item['value'] = pushEnabled;
          } else {
            item['value'] = prefs.getBool('notif_$title') ?? item['value'];
          }
        }
      }
      _isLoading = false;
    });
  }

  Future<void> _updateSetting(Map<String, dynamic> item, bool newValue) async {
    final title = item['title'] as String;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      item['value'] = newValue;
    });

    if (title == 'General Notification') {
      await NotificationService.setPushEnabled(newValue);
    }
    await prefs.setBool('notif_$title', newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextWidget(
          'Notification'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _sections.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: TextWidget(
                        entry.key.tr.toUpperCase(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : Colors.black54,
                        letterSpacing: 1.2,
                      ),
                    ),
                    ...entry.value.map(
                      (item) => SwitchListTile(
                        title: TextWidget(
                          item['title'].toString().tr,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        value: item['value'],
                        activeThumbColor: Colors.white,
                        activeTrackColor: isDark
                            ? Theme.of(context).primaryColor
                            : const Color(0xFF2D3132),
                        onChanged: (bool newValue) =>
                            _updateSetting(item, newValue),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: isDark
                          ? Colors.white10
                          : Colors.grey.withValues(alpha: 0.1),
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
