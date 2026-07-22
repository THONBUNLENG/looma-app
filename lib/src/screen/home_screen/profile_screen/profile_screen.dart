import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:flutter/material.dart';

import 'package:shopping_app/light_dark_theme/theme.dart';

import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/string_extension.dart';
import '../../../../main.dart';
import '../../../network/crud_firebase/migration_utility.dart';
import '../../../network/datastor/auth_service.dart';
import '../../../telegarm_bot/faq_admin_page.dart';
import '../../../widget/show_dialog.dart';
import '../../login_screen/login_screen.dart';
import '../address/address_screen.dart';
import '../order/order_screen.dart';

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
  bool _isLoading = true;
  bool _isLoggedIn = false;
  String _username = "User";
  String _phone = "";
  String? _picture;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final name = await AuthService.getUsername() ?? "User";
      final phone = await AuthService.getPhone() ?? "";
      final picture = await AuthService.getPicture();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoggedIn = true;
          _username = name;
          _phone = phone;
          _picture = picture;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoggedIn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isLoggedIn) {
      return _buildLoginRequiredView(context, isDark);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: TextWidget(
          'Profile'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [const CartBadge()],
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
                    backgroundImage: _picture != null
                        ? CachedNetworkImageProvider(_picture!)
                        : const CachedNetworkImageProvider(
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
            TextWidget(_username, fontSize: 22, fontWeight: FontWeight.bold),
            const SizedBox(height: 4),
            TextWidget(
              _phone,
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
              "Edit Profile".tr,
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
              "Address".tr,
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
              "My Orders".tr,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderScreen()),
                );
              },
            ),
            _buildProfileItem(
              context,
              'assets/icon/notification.png',
              "Notification".tr,
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
              "Payment".tr,
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
              "Security".tr,
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
              "Language".tr,
              trailingText: translator.currentLocale?.languageCode == 'en'
                  ? "English (US)".tr
                  : (translator.currentLocale?.languageCode == 'km'
                        ? "Khmer".tr
                        : "Chinese".tr),
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
              title: TextWidget("Dark Mode".tr, fontWeight: FontWeight.w600),
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
              "Privacy Policy".tr,
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
              "Help Center".tr,
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
              "Invite Friends".tr,
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
              leading: const Icon(Icons.android, color: Colors.blue),
              title: TextWidget(
                "Telegram FAQ Admin",
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQAdminPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Colors.blue),
              title: TextWidget(
                "Migrate Products to Firestore",
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
              onTap: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text("Starting migration...")),
                );
                try {
                  await MigrationUtility().migrateAllProducts();
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Migration complete!")),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text("Migration failed: $e")),
                  );
                }
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
                "Logout".tr,
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
        title: "Logout".tr,
        message: "Are you sure you want to log out of your account?".tr,
        btn1Text: "Cancel".tr,
        btn2Text: "Logout".tr,
        imagePath: 'assets/icon/i_color/Information.png',
        iconColor: Colors.red,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () async {
          await AuthService.logout();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginRequiredView(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 50,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              TextWidget(
                "Login Required".tr,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 12),
              TextWidget(
                "Please login to view your profile and manage your account.".tr,
                textAlign: TextAlign.center,
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.grey,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: TextWidget(
                    "Login Now".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
