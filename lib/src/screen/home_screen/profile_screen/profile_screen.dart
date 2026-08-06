import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:flutter/material.dart';

import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/string_extension.dart';
import 'package:shopping_app/constants/app_color.dart';
import '../../../../main.dart';
import '../../../network/datastor/auth_service.dart';
import '../../../widget/show_dialog.dart';
import '../../login_screen/login_screen.dart';
import '../../main_screen/main_holder.dart';
import '../order/order_screen.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'edit_profile.dart';

import 'help_center/help_center.dart';
import 'gift_card_screen.dart';
import 'membership_qr_screen.dart';

import 'membership_screen.dart';

import 'privacy_policy_screen.dart';
import 'country_selection_screen.dart';
import 'language_selection_screen.dart';
import 'contact_us_screen.dart';
import '../../../../manager/preferences_manager.dart';

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
  String _selectedCountry = "";
  String _selectedFlag = "";

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _loadCountry();
  }

  Future<void> _loadCountry() async {
    final country = await PreferencesManager().setGetString(PrefKey.country);
    if (country.isNotEmpty) {
      final List<Map<String, String>> countries = [
        {'name': 'Cambodia', 'flag': '🇰🇭'},
        {'name': 'Japan', 'flag': '🇯🇵'},
        {'name': 'Malaysia', 'flag': '🇲🇾'},
        {'name': 'Philippines', 'flag': '🇵🇭'},
        {'name': 'South Korea', 'flag': '🇰🇷'},
        {'name': 'United Kingdom', 'flag': '🇬🇧'},
      ];

      final countryData = countries.firstWhere(
        (element) => element['name'] == country,
        orElse: () => {},
      );

      if (mounted && countryData.isNotEmpty) {
        setState(() {
          _selectedCountry = "$country - USD(\$)";
          _selectedFlag = countryData['flag']!;
        });
      }
    }
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final name = await AuthService.getUsername() ?? "User";
      final phone = await AuthService.getPhone() ?? "";
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoggedIn = true;
          _username = name;
          _phone = phone;
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
        body: LoadingWidget.loadingCenterWidget(),
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
          'Me'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [const CartBadge()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  ).then((_) => _checkAuth());
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            _username.toUpperCase(),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 8),
                          TextWidget(
                            _phone.isEmpty ? "No email or phone" : _phone,
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 30),
                  ],
                ),
              ),
            ),

            // Membership Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:  Color(0xFFD9904D),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "ONLINE",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MembershipScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              TextWidget(
                                "Explore more",
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextWidget(
                      "You haven't made any success purchase yet.",
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildGridItem(
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
                  ),
                  Expanded(
                    child: _buildGridItem(
                      context,
                      'assets/image/qr.png',
                      "My QR",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MembershipQRScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildGridItem(
                      context,
                      'assets/icon/gift_card.png',
                      "Gift Card",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GiftCardScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildGridItem(
                      context,
                      'assets/icon/store.png',
                      "Find a Store",
                      onTap: () {
        
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                "Country and Language".tr,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildSelectionItem(
              context,
              "Country".tr,
              _selectedCountry,
              flag: _selectedFlag,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CountrySelectionScreen(),
                  ),
                );
                if (result == true) {
                  _loadCountry();
                }
              },
            ),
            _buildSelectionItem(
              context,
              "Language/ភាសា",
              translator.currentLocale?.languageCode == 'en' ? "English" : (translator.currentLocale?.languageCode == 'km' ? "ខ្មែរ" : "中文"),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSelectionScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {});
                }
              },
            ),

            const SizedBox(height: 40),

            // Support Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                "Support",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileItem(
              context,
              'assets/icon/privacy_policy.png',
              "Privacy policy".tr,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
              showLeading: false,
            ),
            _buildProfileItem(
              context,
              'assets/icon/help_center.png',
              "FAQs & guides".tr,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
              showLeading: false,
            ),
            _buildProfileItem(
              context,
              'assets/icon/star.png',
              "Rate this app".tr,
              onTap: () {
                // Rate this app action
              },
              showLeading: false,
            ),
            _buildProfileItem(
              context,
              'assets/icon/recommend.png',
              "Recommend this app".tr,
              onTap: () => _recommendApp(),
              showLeading: false,
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildWideButton(
                context,
                "Contact us".tr,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUsScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                "Settings",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileItem(
              context,
              'assets/icon/cache.png',
              "Clear cache".tr,
              onTap: () => _showClearCacheDialog(context),
              showLeading: false,
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildWideButton(
                context,
                "LOG OUT".tr,
                onPressed: () => _showLogoutDialog(context),
              ),
            ),

            const SizedBox(height: 30),

            // Account deletion Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextWidget(
                "Account deletion",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildProfileItem(
              context,
              'assets/icon/delete.png',
              "Delete account".tr,
              onTap: () => _showDeleteAccountDialog(context),
              showLeading: false,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildWideButton(
    BuildContext context,
    String text, {
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColor.grey100.withValues(alpha: 0.1)
              : Colors.black,
          foregroundColor: isDark ? Colors.white : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: TextWidget(text, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSelectionItem(
    BuildContext context,
    String title,
    String value, {
    String? flag,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: flag != null && flag.isNotEmpty
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: TextWidget(flag, fontSize: 22),
              ),
            )
          : Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.public,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
      title: TextWidget(
        value.isEmpty ? "Select".tr : value,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: isDark ? Colors.white : Colors.black,
      ),
      subtitle: TextWidget(
        title,
        fontSize: 14,
        color: isDark ? Colors.white54 : Colors.black54,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 30,
        color: isDark ? Colors.white : Colors.black,
      ),
      onTap: onTap,
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    String iconPath,
    String label, {
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isColored = iconPath.contains('i_color');
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 30,
            height: 30,
            color: isColored ? null : (isDark ? Colors.white : Colors.black),
            errorBuilder: (_, _, _) => Icon(
              Icons.grid_view_rounded,
              size: 30,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          TextWidget(
            label.tr,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String? imagePath,
    String title, {
    VoidCallback? onTap,
    bool showLeading = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isColored = imagePath?.contains('i_color') ?? false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: showLeading && imagePath != null
          ? Image.asset(
              imagePath,
              width: 24,
              height: 24,
              color: isColored ? null : (isDark ? Colors.white : Colors.black),
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.image_not_supported, size: 22),
            )
          : null,
      title: TextWidget(
        title,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: isDark ? Colors.white : Colors.black,
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 30,
        color: isDark ? Colors.white : Colors.black,
      ),
      onTap: onTap,
    );
  }

  void _recommendApp() {
    const String appLink = "https://play.google.com/store/apps/details?id=com.loomakh.app";
    Share.share(
      "Check out this amazing shopping app! Download it now: $appLink".tr,
      subject: "Recommend Looma App".tr,
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Clear cache".tr,
        message: "Are you sure you want to clear the app cache? This will free up space but might make images load slower temporarily.".tr,
        btn1Text: "Cancel".tr,
        btn2Text: "Clear".tr,
        imagePath: 'assets/icon/i_color/Information.png',
        iconColor: AppColor.primaryColor,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () async {
          await DefaultCacheManager().emptyCache();
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget("Cache cleared successfully".tr, color: Colors.white),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
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
              MaterialPageRoute(builder: (context) => const MainHolder()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Delete Account".tr,
        message:
            "Are you sure you want to permanently delete your account? This action cannot be undone."
                .tr,
        btn1Text: "Cancel".tr,
        btn2Text: "Delete".tr,
        imagePath: 'assets/icon/i_color/Information.png',
        iconColor: Colors.red,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () async {
          await AuthService.deleteAccountPermanent();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainHolder()),
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
              TextWidget(
                "Login Required".tr,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
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
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
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
