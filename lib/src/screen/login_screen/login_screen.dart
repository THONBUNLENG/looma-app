import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/screen/login_screen/phone_login_screen.dart';
import 'package:shopping_app/src/screen/login_screen/email_login_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../main_screen/main_holder.dart';
import 'create_account.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainHolder()),
            (route) => false,
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
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
                      child: BackButton(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          TextWidget(
                            "Login to LOOMA".tr,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D2D2D),
                          ),
                          const SizedBox(height: 16),
                          TextWidget(
                            "Manage your account, check notifications, rating on product and more."
                                .tr,
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            textAlign: TextAlign.center,
                            lineHeight: 1.5,
                          ),
                          const SizedBox(height: 48),

                          _buildLoginButton(
                            context,
                            text: "Continue with Phone".tr,
                            icon: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.phone_outlined, color: Color(0xFF2196F3), size: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PhoneLoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildLoginButton(
                            context,
                            text: "Continue with Email".tr,
                            icon: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColor.pinkColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.email_outlined, color: AppColor.pinkColor, size: 20),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EmailLoginScreen(),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 48),
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextWidget("OR".tr, color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              bool isLoading = state is LoginLoading;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialCircleIcon(
                                    onTap: isLoading ? () {} : () {
                                      context.read<LoginBloc>().add(GoogleSignInRequested());
                                    },
                                    icon: Image.asset('assets/icon/i_color/google.png', width: 28),
                                  ),
                                  const SizedBox(width: 25),
                                  _buildSocialCircleIcon(
                                    onTap: isLoading ? () {} : () {
                                      context.read<LoginBloc>().add(FacebookSignInRequested());
                                    },
                                    icon: const Icon(Icons.facebook, size: 36, color: Color(0xFF1877F2)),
                                  ),
                                  const SizedBox(width: 25),
                                  _buildSocialCircleIcon(
                                    onTap: isLoading ? () {} : () {
                                      context.read<LoginBloc>().add(AppleSignInRequested());
                                    },
                                    icon: const Icon(Icons.apple, size: 36, color: Colors.black),
                                  ),
                                ],
                              );
                            },
                          ),
                          
                          const SizedBox(height: 48),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(
                                "Don't have an account?".tr,
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CreateAccountScreen(),
                                    ),
                                  );
                                },
                                child: TextWidget(
                                  "Sign Up here".tr,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF8B4513),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          TextWidget(
                            "Secure Payment Methods".tr,
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSmallCardIcon('assets/icon/i_color/visa.png'),
                              const SizedBox(width: 16),
                              _buildSmallCardIcon('assets/icon/i_color/mastercard.png'),
                              const SizedBox(width: 16),
                              _buildSmallCardIcon('assets/icon/i_color/aba.png'),
                              const SizedBox(width: 16),
                              _buildSmallCardIcon('assets/icon/i_color/wing.png'),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoginLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.buttonColor),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialCircleIcon({required VoidCallback onTap, required Widget icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildSmallCardIcon(String assetPath) {
    return Container(
      width: 44,
      height: 30,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }

  Widget _buildLoginButton(
    BuildContext context, {
    required String text,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.primaryColor.withValues(alpha: 0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              icon,
              Expanded(
                child: TextWidget(
                  text,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              const SizedBox(width: 28),
            ],
          ),
        ),
      ),
    );
  }
}
