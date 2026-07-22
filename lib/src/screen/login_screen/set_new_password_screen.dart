import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../widget/button.dart';
import '../main_screen/main_holder.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  Future<void> _handleUpdatePassword() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
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
      await AuthLoginService().updateUserPassword(password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("Password updated successfully!".tr)),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainHolder()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update password: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Image.asset(
              'assets/image/bubble2.png',
              width: 400,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Positioned(
            top: -80,
            right: -120,
            child: Image.asset('assets/image/bubble1.png', width: 250),
          ),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(height: 48),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        TextWidget(
                          "Set New Password".tr,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2D2D),
                        ),
                        const SizedBox(height: 16),
                        TextWidget(
                          "Your identity is verified. Please choose a strong new password for your account.".tr,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.center,
                          lineHeight: 1.5,
                        ),
                        const SizedBox(height: 48),

                        _buildTextField(
                          hint: "New Password".tr,
                          controller: _passwordController,
                          isPassword: true,
                          isObscured: _isObscured,
                          prefixIcon: Icons.lock_outline,
                          onSuffixTap: () => setState(() => _isObscured = !_isObscured),
                        ),
                        const SizedBox(height: 16),
                         _buildTextField(
                          hint: "Confirm Password".tr,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          isObscured: _isObscured,
                          prefixIcon: Icons.lock_reset_outlined,
                          onSuffixTap: () => setState(() => _isObscured = !_isObscured),
                        ),

                        const SizedBox(height: 48),
                        MyCustomButton(
                          text: _isLoading ? "Updating...".tr : "Reset Password".tr,
                          width: double.infinity,
                          height: 58,
                          borderRadius: 15,
                          gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
                          onPressed: _isLoading ? () {} : _handleUpdatePassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isObscured = false,
    IconData? prefixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscured : false,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: onSuffixTap,
                )
              : null,
        ),
      ),
    );
  }
}
