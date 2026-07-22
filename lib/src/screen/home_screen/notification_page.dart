import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/setting/notification_screen.dart';
import '../../widget/text_widget.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: false,
        title: TextWidget(
          'Notification'.tr,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: isDark ? Colors.white : Colors.black),
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildSectionHeader('Today'.tr, isDark),
          _buildNotificationCard(
            icon: Icons.percent,
            title: '30% Special Discount!'.tr,
            subtitle: 'Special promotion only valid today'.tr,
            isDark: isDark,
            onPressed: () {},
          ),

          _buildSectionHeader('Yesterday'.tr, isDark),
          _buildNotificationCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Top Up E-Wallet Successful!'.tr,
            subtitle: 'You have to top up your e-wallet'.tr,
            isDark: isDark,
            onPressed: () {},
          ),
          _buildNotificationCard(
            icon: Icons.location_on,
            title: 'New Services Available!'.tr,
            subtitle: 'Now you can track orders in real time'.tr,
            isDark: isDark,
            onPressed: () {},
          ),

          _buildSectionHeader('December 22, 2026'.tr, isDark),
          _buildNotificationCard(
            icon: Icons.credit_card,
            title: 'Credit Card Connected!'.tr,
            subtitle: 'Credit Card has been linked!'.tr,
            isDark: isDark,
            onPressed: () {},
          ),
          _buildNotificationCard(
            icon: Icons.person,
            title: 'Account Setup Successful!'.tr,
            subtitle: 'Your account has been created!'.tr,
            isDark: isDark,
            onPressed: () {},
          ),
          const SizedBox(height: 30),
        ],
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
                color: isDark ? Colors.white10 : const Color(0xFF262626),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
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
