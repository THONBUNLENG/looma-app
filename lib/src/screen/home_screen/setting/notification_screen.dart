import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notification'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: _sections.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  entry.key.tr.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...entry.value.map(
                    (item) => SwitchListTile(
                  title: Text(
                    item['title'].toString().tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: item['value'],
                  activeThumbColor: Colors.white,
                  activeTrackColor: isDark ? Colors.blueAccent : const Color(0xFF2D3132),
                  onChanged: (bool newValue) {
                    setState(() {
                      item['value'] = newValue;
                    });
                  },
                ),
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}