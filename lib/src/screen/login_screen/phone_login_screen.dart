import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../widget/button.dart';
import 'create_account.dart';
import 'forgot_password_phone_screen.dart';
import 'otp_verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscured = true;

  Future<void> _handlePhoneSignIn() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget("Please enter your phone number".tr)),
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
                ),
              ),
            );
          }
        },
        onVerificationFailed: (e) {
          if (mounted) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: TextWidget("Verification failed: ${e.message}")),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("An error occurred: $e")),
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
                          "Login with Phone".tr,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2D2D),
                        ),
                        const SizedBox(height: 16),
                        TextWidget(
                          "We will send a 6-digit verification code to your phone number.".tr,
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
                        const SizedBox(height: 16),
                        _buildTextField(
                          hint: "Password".tr,
                          controller: _passwordController,
                          isPassword: true,
                          isObscured: _isObscured,
                          prefixIcon: Icons.lock_outline,
                          onSuffixTap: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordPhoneScreen(),
                                ),
                              );
                            },
                            child: TextWidget(
                              "Forgot Password?".tr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.buttonColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        MyCustomButton(
                          text: _isLoading ? "Sending Login.".tr : "Login".tr,
                          width: double.infinity,
                          height: 58,
                          borderRadius: 15,
                          gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
                          onPressed: _isLoading ? () {} : _handlePhoneSignIn,
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              "Don't have an account?".tr,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateAccountScreen(),
                                  ),
                                );
                              },
                              child: TextWidget(
                                "Sign Up".tr,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColor.pinkColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.buttonColor),
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
        obscureText: isPassword ? isObscured : false,
        keyboardType: keyboardType,
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
