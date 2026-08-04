import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../widget/button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    setState(() => _isLoading = true);

    try {
      await AuthLoginService().sendPasswordResetEmail(email);
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains("] ")) {
          errorMessage = errorMessage.split("] ").last;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TextWidget(errorMessage, color: Colors.white, fontSize: 14),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: TextWidget("Email Sent".tr, fontWeight: FontWeight.bold),
        content: TextWidget(
          "A password reset link has been sent to your email. Please check your inbox and follow the instructions.".tr,
          fontSize: 14,
          color: Colors.grey,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: TextWidget("OK".tr, color: AppColor.buttonColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Left light bubble
          Positioned(
            top: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0F4FF).withValues(alpha: 0.8),
              ),
            ),
          ),
          // Right dark blue bubble
          Positioned(
            top: 250,
            right: -60,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0055FF),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          TextWidget(
                            "Forgot Password".tr,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D2D2D),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextWidget(
                              "Enter the email address associated with your account and we'll send you a link to reset your password.".tr,
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              textAlign: TextAlign.center,
                              lineHeight: 1.5,
                            ),
                          ),
                          const SizedBox(height: 60),
                          _buildTextField(
                            hint: "Email".tr,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required".tr;
                              }
                              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "Please enter a valid email address".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          MyCustomButton(
                            text: _isLoading ? "Sending...".tr : "Send Reset gmail".tr,
                            width: double.infinity,
                            height: 58,
                            borderRadius: 15,
                            gradientColors: const [Colors.black, Colors.black],
                            onPressed: _isLoading ? () {} : _handleResetPassword,
                          ),
                        ],
                      ),
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
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF0055FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
