import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';

import '../../widget/button.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool rememberMe = true;
  bool faceId = false;
  bool biometricId = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,

        title: Text(
          'Security'.tr,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildSwitchTile(context, "Remember me".tr, rememberMe, (val) {
              setState(() => rememberMe = val);
            }),
            _buildSwitchTile(context, "Face ID".tr, faceId, (val) {
              setState(() => faceId = val);
            }),
            _buildSwitchTile(context, "Biometric ID".tr, biometricId, (val) {
              setState(() => biometricId = val);
            }),

            _buildNavigationTile(context, "Google Authenticator".tr, () {}),

            const SizedBox(height: 40),

            MyCustomButton(
              text: 'Change PIN'.tr,
              onPressed: () {},
              width: double.infinity,
              height: 58,
              borderRadius: 30,
            ),
            const SizedBox(height: 16),
            MyCustomButton(
              text: 'Change Password'.tr,
              onPressed: () {},
              width: double.infinity,
              height: 58,
              borderRadius: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,

        activeTrackColor: isDark ? Colors.blueAccent : Colors.black87,
        activeThumbColor: Colors.white,
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDark ? Colors.white54 : Colors.black,
      ),
    );
  }
}
