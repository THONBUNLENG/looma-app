import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isLoading = false;
  String _selectedContactMethod = "Phone call";

  Future<void> _handleSendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();

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
                    child: Form(
                      key: _formKey,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required".tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          _buildPreferredContactSection(),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferredContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Preferred contact line".tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildContactOption("Phone call", Icons.phone_outlined),
                    const SizedBox(width: 12),
                    _buildContactOption("Telegram", FontAwesomeIcons.telegram),
                    const SizedBox(width: 12),
                    _buildContactOption("WhatsApp", FontAwesomeIcons.whatsapp),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildContactInputField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption(String method, dynamic icon) {
    bool isSelected = _selectedContactMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedContactMethod = method),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_off,
            color: isSelected ? Colors.green : Colors.grey.shade400,
            size: 20,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (icon is FaIconData)
                  FaIcon(icon, size: 16, color: Colors.black)
                else
                  Icon(icon as IconData, size: 16, color: Colors.black),
                const SizedBox(width: 8),
                TextWidget(
                  method.tr,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextWidget(
                  "+855",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 18),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: TextFormField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Enter your contact line".tr,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
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
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColor.buttonColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
