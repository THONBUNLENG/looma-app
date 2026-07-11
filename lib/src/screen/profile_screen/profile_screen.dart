import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/light_dark_theme/theme.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../widget/show_dialog.dart';
import '../home_screen/order/order_screen.dart';
import '../home_screen/shopping_bag/shopping_bag_screen.dart';
import '../login_screen/welcome_screen.dart';
import '../setting/address/address_screen.dart';
import '../setting/change_language_screen.dart';
import '../setting/edit_profile.dart';
import '../setting/help_center/help_center.dart';
import '../setting/invite_friend.dart';
import '../setting/notification_screen.dart';
import '../setting/payment_screen.dart';
import '../setting/privacy_policy_screen.dart';
import '../setting/security_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: TextWidget(
          'Profile',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  splashRadius: 24,
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color:
                    isDark ? Colors.white : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShoppingBagScreen(),
                      ),
                    );
                  },
                ),

                Positioned(
                  right: 0,
                  top: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius:
                      BorderRadius.circular(100),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF121212)
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                    child:  Center(
                      child: TextWidget(
                        '0',
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : const Color(0xFFEEEEEE),
                    backgroundImage: const CachedNetworkImageProvider(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWk3ODZqYyZbb-CHDbmzE7En-1bcFgJBO8pg&s',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? theme.primaryColor : Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        'assets/icon/edit.png',
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            TextWidget("Li Anna", fontSize: 22, fontWeight: FontWeight.bold),
            const SizedBox(height: 4),
            TextWidget(
              "+855 11 820 595",
              color: isDark ? Colors.white60 : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 24),
            Divider(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            _buildProfileItem(
              context,
              'assets/icon/edit_profile.png',
              "Edit Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/address.png',
              "Address",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/order.png',
              "My Orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/notification.png',
              "Notification",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationSettingsScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/payment.png',
              "Payment",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentSettingsScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/security.png',
              "Security",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecuritySettingsScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/language.png',
              "Language",
              trailingText: "English (US)",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangeLanguageScreen(),
                  ),
                );
              },
            ),

            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: Image.asset(
                isDark ? 'assets/icon/night.png' : 'assets/icon/day_mode.png',
                width: 24,
                height: 24,
                color: isDark ? Colors.white : Colors.black,
              ),
              title: TextWidget("Dark Mode", fontWeight: FontWeight.w600),
              trailing: Switch(
                value: isDark,
                activeTrackColor: theme.primaryColor,
                onChanged: (val) {
                  TAppTheme.themeMode.value = val
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
              ),
            ),

            _buildProfileItem(
              context,
              'assets/icon/privacy_policy.png',
              "Privacy Policy",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/help_center.png',
              "Help Center",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/invite_friends.png',
              "Invite Friends",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InviteFriendsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            ListTile(
              leading: Image.asset(
                'assets/icon/logout.png',
                width: 24,
                height: 24,
                color: Colors.red,
              ),
              title: TextWidget(
                "Logout",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String imagePath,
    String title, {
    String? trailingText,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Image.asset(
        imagePath,
        width: 24,
        height: 24,
        color: isDark ? Colors.white : Colors.black,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.image_not_supported, size: 22),
      ),
      title: TextWidget(
        title,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            TextWidget(
              trailingText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/icon/go.png',
            width: 16,
            height: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Logout",
        message: "Are you sure you want to log out of your account?",
        btn1Text: "Cancel",
        btn2Text: "Logout",
        imagePath: 'assets/icon/i_color/Information.png',
        iconColor: Colors.red,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );
        },
      ),
    );
  }
}
