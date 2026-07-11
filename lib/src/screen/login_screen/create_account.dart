import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../constants/app_color.dart';
import '../../widget/button.dart';
import 'hello_card_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController phoneController = TextEditingController();

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
              TextWidget(
                "Select Country",
                color: AppColor.black,
              ),
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
                        country["name"]!,
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
  bool _isObscured = true;
  Map<String, String> selectedCountry = countries[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 68),
                  TextWidget(
                    "Create\nAccount",
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    lineHeight: 1.1,
                    color: const Color(0xFF2D2D2D),
                  ),

                  const SizedBox(height: 60),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: DottedBorder(
                        options: CircularDottedBorderOptions(
                          dashPattern: [18, 5],
                          strokeWidth: 2,
                          color: AppColor.buttonColor,
                          padding: EdgeInsets.all(4),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icon/camera.png',
                            width: 40,
                            color: AppColor.buttonColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildTextField(hint: "Email"),

                  const SizedBox(height: 20),

                  _buildTextField(
                    hint: "Password",
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
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    hint: 'Enter your phone number',
                    controller: phoneController,
                    prefix: GestureDetector(
                      onTap: _showCountryPicker,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                color: AppColor.black
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_drop_down, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                  MyCustomButton(
                    text: "Done",
                    width: double.infinity,
                    height: 60,
                    borderRadius: 15,
                    gradientColors: [AppColor.buttonColor,AppColor.buttonColor],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelloCardScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: TextWidget(
                        "Cancel",
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
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
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.primaryColor.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscured : false,
        onTap: onTap,
        readOnly: readOnly,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          hintStyle: const TextStyle(
            color:AppColor.grey,
            fontSize: 14,
          ),

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
              icon: Image.asset(
                suffixAsset,
                width: 20,
                height: 20,
              ),
            ),
          )
              : null,
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
