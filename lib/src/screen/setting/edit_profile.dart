import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../constants/string_extension.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController dateController;
  late TextEditingController phoneController;

  String? selectedGender = 'Male';
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  late Map<String, String> selectedCountry;

  @override
  void initState() {
    super.initState();
    final profile = ProfileManager();
    nameController = TextEditingController(text: profile.name);
    fullNameController = TextEditingController(text: profile.name);
    emailController = TextEditingController(text: profile.email);
    dateController = TextEditingController(text: '12/27/1995');
    phoneController = TextEditingController(text: profile.phone.replaceAll(RegExp(r'^\+\d+\s*'), ''));
    
    selectedCountry = countries.firstWhere(
      (c) => profile.phone.startsWith(c['code']!),
      orElse: () => countries[0],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 12, 27),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.brightness == Brightness.dark
                ? const ColorScheme.dark(primary: Colors.blueAccent)
                : const ColorScheme.light(primary: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  void _showCountryPicker() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
              ),
              TextWidget(
                "Select Country",
                color: theme.colorScheme.onSurface,

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
                        color: theme.colorScheme.onSurface,
                      ),
                      trailing: TextWidget(
                        country["code"]!,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextWidget(
          'Edit Profile'.tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: isDark
                      ? Colors.grey[800]
                      : const Color(0xFFEEEEEE),
                  backgroundImage: const CachedNetworkImageProvider(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWk3ODZqYyZbb-CHDbmzE7En-1bcFgJBO8pg&s',
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInputField(hint: 'Full Name'.tr, controller: fullNameController),
            _buildInputField(hint: 'Name'.tr, controller: nameController),
            _buildInputField(
              hint: 'Date of Birth'.tr,
              controller: dateController,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: () => _selectDate(context),
            ),
            _buildInputField(
              hint: 'Email'.tr,
              controller: emailController,
              suffixIcon: Icons.email_outlined,
            ),
            _buildInputField(
              hint: selectedCountry["name"]!.tr,
              suffixIcon: Icons.arrow_drop_down,
              onTap: _showCountryPicker,
            ),
            _buildInputField(
              hint: '11 820595',
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
                      Text(
                        selectedCountry["code"]!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_drop_down, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            _buildDropdownField(

              value: selectedGender!,
              items: genderOptions,
              onChanged: (newValue) =>
                  setState(() => selectedGender = newValue),


            ),
            const SizedBox(height: 30),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    IconData? suffixIcon,
    TextEditingController? controller,
    VoidCallback? onTap,
    Widget? prefix,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: InputBorder.none,

          prefixIcon: prefix,

          suffixIcon: suffixIcon != null
              ? Icon(
            suffixIcon,
            color: isDark ? Colors.white54 : Colors.black54,
            size: 20,
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          icon: const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          items: items
              .map(
                (item) =>
                DropdownMenuItem(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(item.tr),
                  ),
                ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }


  Widget _buildUpdateButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          ProfileManager().updateProfile(
            name: fullNameController.text,
            email: emailController.text,
            phone: "${selectedCountry['code']} ${phoneController.text}",
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: TextWidget(
          'Continue'.tr,
          fontWeight: FontWeight.bold,
          fontSize: 18,
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
