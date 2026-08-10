import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';
import '../../../network/datastor/auth_login_service.dart';
import '../../../widget/button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isCurrentObscured = true;
  bool _isNewObscured = true;
  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    final current = _currentPasswordController.text.trim();
    final password = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (current.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget("Please fill in all fields".tr)),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget("Passwords do not match".tr)),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget("Password must be at least 6 characters".tr)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthLoginService();
      
      // Step 1: Re-authenticate
      await authService.reauthenticate(current);
      
      // Step 2: Update Password
      await authService.updateUserPassword(password);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("Password changed successfully!".tr)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        if (errorMsg.contains('wrong-password')) {
          errorMsg = "Current password is incorrect".tr;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 30, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "Change Password".tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              "Current Password".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: "Enter current password".tr,
              controller: _currentPasswordController,
              isObscured: _isCurrentObscured,
              onSuffixTap: () => setState(() => _isCurrentObscured = !_isCurrentObscured),
            ),
            const SizedBox(height: 20),
            
            TextWidget(
              "New Password".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: "Enter new password".tr,
              controller: _newPasswordController,
              isObscured: _isNewObscured,
              onSuffixTap: () => setState(() => _isNewObscured = !_isNewObscured),
            ),
            const SizedBox(height: 20),
            
            TextWidget(
              "Confirm New Password".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              hint: "Confirm new password".tr,
              controller: _confirmPasswordController,
              isObscured: _isNewObscured,
              onSuffixTap: () => setState(() => _isNewObscured = !_isNewObscured),
            ),
            
            const SizedBox(height: 48),
            MyCustomButton(
              text: _isLoading ? "Updating...".tr : "Change Password".tr,
              width: double.infinity,
              height: 58,
              borderRadius: 15,
              gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
              onPressed: _isLoading ? () {} : _handleChangePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required bool isObscured,
    required VoidCallback onSuffixTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscured,
        style: TextStyle(
          fontSize: 15, 
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: onSuffixTap,
          ),
        ),
      ),
    );
  }
}
