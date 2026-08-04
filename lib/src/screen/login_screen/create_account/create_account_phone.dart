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
import '../otp_verification_screen.dart';

class CreateAccountPhoneScreen extends StatefulWidget {
  const CreateAccountPhoneScreen({super.key});

  @override
  State<CreateAccountPhoneScreen> createState() => _CreateAccountPhoneScreenState();
}

class _CreateAccountPhoneScreenState extends State<CreateAccountPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? _imageFile;
  bool _isObscured = true;

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
    String phoneNum = phoneController.text.trim();
    if (phoneNum.startsWith('0')) {
      phoneNum = phoneNum.substring(1);
    }
    final phone = "${selectedCountry["code"]}$phoneNum";
    final password = passwordController.text.trim();

    context.read<LoginBloc>().add(SendOtpRequested(
          phone: phone,
          name: name,
          password: password,
          imageFile: _imageFile,
        ));
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.grey100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.grey300,
                ),
              ),
              TextWidget("Select Country".tr, color: AppColor.black),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: Text(
                        country["flag"]!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: TextWidget(
                        country["name"]!.tr,
                        color: AppColor.black,
                      ),
                      trailing: TextWidget(
                        country["code"]!,
                        color: AppColor.black,
                      ),
                      onTap: () {
                        setState(() => selectedCountry = country);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> selectedCountry = countries[0];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is OtpSentState) {
                final name = nameController.text.trim();
                final phone = "${selectedCountry["code"]}${phoneController.text.trim()}";
                final password = passwordController.text.trim();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerificationScreen(
                      verificationId: state.verificationId,
                      phoneNumber: phone,
                      name: name,
                      password: password,
                      imageFile: _imageFile,
                    ),
                  ),
                );
              } else if (state is LoginSuccess) {
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
                                  hint: 'Enter your phone number'.tr,
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This field is required".tr;
                                    }
                                    if (value.length < 8) {
                                      return "Please enter a valid phone number".tr;
                                    }
                                    return null;
                                  },
                                  prefix: GestureDetector(
                                    onTap: _showCountryPicker,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedCountry["flag"]!,
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(width: 6),
                                          TextWidget(
                                            selectedCountry["code"]!,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.black,
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscured : false,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
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

final List<Map<String, String>> countries = [
  {"name": "Cambodia", "flag": "🇰🇭", "code": "+855"},
  {"name": "United Kingdom", "flag": "🇬🇧", "code": "+44"},
  {"name": "United States", "flag": "🇺🇸", "code": "+1"},
  {"name": "Thailand", "flag": "🇹🇭", "code": "+66"},
  {"name": "Vietnam", "flag": "🇻🇳", "code": "+84"},
  {"name": "France", "flag": "🇫🇷", "code": "+33"},
  {"name": "Germany", "flag": "🇩🇪", "code": "+49"},
  {"name": "Japan", "flag": "🇯🇵", "code": "+81"},
  {"name": "South Korea", "flag": "🇰🇷", "code": "+82"},
  {"name": "China", "flag": "🇨🇳", "code": "+86"},
];
