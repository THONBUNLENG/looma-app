import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../widget/button.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordPhoneScreen extends StatefulWidget {
  const ForgotPasswordPhoneScreen({super.key});

  @override
  State<ForgotPasswordPhoneScreen> createState() => _ForgotPasswordPhoneScreenState();
}

class _ForgotPasswordPhoneScreenState extends State<ForgotPasswordPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSendOTP() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your phone number".tr)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthLoginService().verifyPhoneNumber(
        phoneNumber: phone,
        onCodeSent: (verificationId) {
          if (mounted) {
            setState(() => _isLoading = false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                  verificationId: verificationId,
                  phoneNumber: phone,
                  isResetPasswordMode: true,
                ),
              ),
            );
          }
        },
        onVerificationFailed: (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Verification failed: ${e.message}")),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Bubbles
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton( color: Colors.black)
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        TextWidget(
                          "Phone Recovery".tr,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2D2D),
                        ),
                        const SizedBox(height: 16),
                        TextWidget(
                          "Enter your phone number to receive a verification code for password reset.".tr,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.center,
                          lineHeight: 1.5,
                        ),
                        const SizedBox(height: 48),

                        _buildTextField(
                          hint: "Phone Number".tr,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 48),
                        MyCustomButton(
                          text: _isLoading ? "Sending...".tr : "Send Verification Code".tr,
                          width: double.infinity,
                          height: 58,
                          borderRadius: 15,
                          gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
                          onPressed: _isLoading ? () {} : _handleSendOTP,
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
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
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
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        ),
      ),
    );
  }
}
