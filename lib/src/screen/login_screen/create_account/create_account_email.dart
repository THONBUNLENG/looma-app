import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/login_screen/bloc/login_bloc.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';
import '../../../widget/button.dart';
import '../../main_screen/main_holder.dart';

class CreateAccountEmail extends StatefulWidget {
  const CreateAccountEmail({super.key});

  @override
  State<CreateAccountEmail> createState() => _CreateAccountEmailState();
}

class _CreateAccountEmailState extends State<CreateAccountEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _handleRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<LoginBloc>().add(RegisterRequested(
          email: email,
          password: password,
          name: name,
          imageFile: _imageFile,
        ));
  }

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Registration successful! Please check your email for verification."
                          .tr,
                    ),
                  ),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainHolder()),
                  (route) => false,
                );
              } else if (state is LoginFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Positioned(
                    top: -60,
                    left: -60,
                    child: Image.asset(
                      'assets/image/bubble2.png',
                      width: 360,
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Image.asset('assets/image/bubble1.png', width: 180),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                TextWidget(
                                  "Create Account".tr,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2D2D),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: DottedBorder(
                                        options: CircularDottedBorderOptions(
                                          dashPattern: const [8, 4],
                                          strokeWidth: 2,
                                          color: AppColor.buttonColor,
                                          padding: const EdgeInsets.all(4),
                                        ),
                                        child: Center(
                                          child: _imageFile != null
                                              ? ClipOval(
                                                  child: Image.file(
                                                    _imageFile!,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icon/camera.png',
                                                  width: 32,
                                                  color: AppColor.buttonColor,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),
                                _buildTextField(
                                  hint: "Full Name".tr,
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required".tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  hint: "Email".tr,
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required".tr;
                                    }
                                    final emailRegex = RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(value)) {
                                      return "Please enter a valid email".tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  hint: "Password".tr,
                                  controller: passwordController,
                                  isPassword: true,
                                  isObscured: _isObscured,
                                  suffixAsset: _isObscured
                                      ? "assets/icon/clos_eye.png"
                                      : "assets/icon/open_eye.png",
                                  onSuffixTap: () {
                                    setState(() {
                                      _isObscured = !_isObscured;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required".tr;
                                    }
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters".tr;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                const SizedBox(height: 25),

                                MyCustomButton(
                                  text: "Register".tr,
                                  width: double.infinity,
                                  height: 56,
                                  borderRadius: 15,
                                  gradientColors: [
                                    AppColor.buttonColor,
                                    AppColor.buttonColor,
                                  ],
                                  onPressed: () => _handleRegister(context),
                                ),

                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(color: Colors.grey.shade300),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: TextWidget(
                                        "OR".tr,
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(color: Colors.grey.shade300),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    bool isLoadingSocial = state is LoginLoading;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildSocialCircleIcon(
                                          onTap: isLoadingSocial
                                              ? () {}
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                    GoogleSignInRequested(),
                                                  );
                                                },
                                          icon: Image.asset(
                                            'assets/icon/i_color/google.png',
                                            width: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        _buildSocialCircleIcon(
                                          onTap: isLoadingSocial
                                              ? () {}
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                    FacebookSignInRequested(),
                                                  );
                                                },
                                          icon: const Icon(
                                            Icons.facebook,
                                            size: 36,
                                            color: Color(0xFF1877F2),
                                          ),
                                        ),
                                        const SizedBox(width: 25),
                                        _buildSocialCircleIcon(
                                          onTap: isLoadingSocial
                                              ? () {}
                                              : () {
                                                  context.read<LoginBloc>().add(
                                                    AppleSignInRequested(),
                                                  );
                                                },
                                          icon: const Icon(
                                            Icons.apple,
                                            size: 36,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return Container(
                          color: Colors.black26,
                          child: LoadingWidget.loadingCenterWidget(),
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
      ),
    );
  }

  Widget _buildSocialCircleIcon({
    required VoidCallback onTap,
    required Widget icon,
  }) {
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

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    bool isPassword = false,
    bool isObscured = true,
    String? suffixAsset,
    VoidCallback? onSuffixTap,
    Widget? prefix,
    VoidCallback? onTap,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscured : false,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColor.primaryColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        hintStyle: const TextStyle(color: AppColor.grey, fontSize: 14),
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: prefix,
              )
            : null,
        suffixIcon: suffixAsset != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: onSuffixTap,
                  icon: Image.asset(suffixAsset, width: 20, height: 20),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.black.withValues(alpha: 0.05),
          ),
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
