import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/setting/notification_screen.dart';
import 'package:shopping_app/src/widget/birthday_reward_dialog.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/manager/notification_service.dart';
import 'package:shopping_app/src/model/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationPageScreen extends StatefulWidget {
  const NotificationPageScreen({super.key});

  @override
  State<NotificationPageScreen> createState() => _NotificationPageScreenState();
}

class _NotificationPageScreenState extends State<NotificationPageScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService.refreshNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      NotificationService.refreshNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: false,
        title: TextWidget(
          'Notifications'.tr,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_sweep_outlined,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            tooltip: 'Clear All'.tr,
            onPressed: () => _confirmClearAll(context),
          ),
          IconButton(
            icon: Icon(
              Icons.sort_rounded,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ValueListenableBuilder<List<NotificationModel>>(
        valueListenable: NotificationService.notificationsNotifier,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 64,
                    color: isDark ? Colors.white24 : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  TextWidget(
                    'No notifications yet'.tr,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                ],
              ),
            );
          }

          // Group notifications by date
          final Map<String, List<NotificationModel>> groupedNotifications = {};
          for (var notif in notifications) {
            String groupKey = _getDateLabel(notif.timestamp);
            groupedNotifications.putIfAbsent(groupKey, () => []).add(notif);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            children: groupedNotifications.entries.expand((entry) {
              return [
                _buildSectionHeader(entry.key.tr, isDark),
                ...entry.value.map(
                  (notif) => Dismissible(
                    key: Key(notif.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                    onDismissed: (direction) {
                      NotificationService.removeNotification(notif.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: TextWidget(
                            "Notification deleted".tr,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: _buildNotificationCard(
                      icon: notif.icon,
                      title: notif.title,
                      subtitle: notif.subtitle,
                      isDark: isDark,
                      iconColor: notif.iconColor,
                      onPressed: () {
                        if (notif.title.contains('Birthday')) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const BirthdayRewardDialog(),
                          );
                        } else {
                          _showNotificationDetail(context, notif.title);
                        }
                      },
                    ),
                  ),
                ),
              ];
            }).toList()..add(const SizedBox(height: 30)),
          );
        },
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate == today) return 'Today';
    if (checkDate == yesterday) return 'Yesterday';
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All'.tr),
        content: Text('Are you sure you want to clear all notifications?'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              NotificationService.cancelAllNotifications();
              Navigator.pop(context);
            },
            child: Text('Clear'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget("Detail for: $title".tr, color: Colors.white),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 15),
      child: TextWidget(
        title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: iconColor != null
                    ? iconColor.withValues(alpha: 0.1)
                    : (isDark ? Colors.white10 : const Color(0xFF262626)),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    subtitle,
                    fontSize: 13,
                    color: isDark ? Colors.white38 : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
