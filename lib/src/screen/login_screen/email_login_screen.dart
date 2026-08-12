import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../network/datastor/auth_service.dart';
import '../../utils/firebase_error_handler.dart';
import '../../widget/button.dart';
import '../main_screen/main_holder.dart';
import 'create_account/create_account_screen.dart';
import 'forgot_password_gmail_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await AuthLoginService().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        await AuthService.saveLoginData(
          username: user.displayName ?? "User",
          email: email, // Use the login email
          phone: user.phoneNumber ?? "",
          picture: user.photoURL,
          token: await user.getIdToken(),
        );

        await ProfileManager().init();

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainHolder()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = FirebaseErrorHandler.getErrorMessage(e);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
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

          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: Colors.black),
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
                        const SizedBox(height: 20),
                        TextWidget(
                          "Login with Email".tr,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2D2D),
                        ),
                        const SizedBox(height: 16),
                        TextWidget(
                          "Access your account with your email and password.".tr,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.center,
                          lineHeight: 1.5,
                        ),
                        const SizedBox(height: 32),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: "Email".tr,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required".tr;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 8),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required".tr;
                            }
                            return null;
                          },
                        ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
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

                        const SizedBox(height: 16),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextWidget(
                              _errorMessage!,
                              color: Colors.red,
                              fontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        MyCustomButton(
                          text: "Login".tr,
                          width: double.infinity,
                          height: 58,
                          borderRadius: 15,
                          gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
                          onPressed: _isLoading ? () {} : _handleLogin,
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
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: LoadingWidget.loadingCenterWidget(),
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscured : false,
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
