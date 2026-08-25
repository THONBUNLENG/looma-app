import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/manager/callback_manager.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/string_extension.dart';
import '../address/address_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController dateController;
  late TextEditingController phoneController;

  late Map<String, String> selectedCountry;
  String? selectedGender;
  String? _picture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final profile = ProfileManager();

    String fullName = profile.name;
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length > 1) {
      firstNameController = TextEditingController(
        text: nameParts.sublist(0, nameParts.length - 1).join(' '),
      );
      lastNameController = TextEditingController(text: nameParts.last);
    } else {
      firstNameController = TextEditingController(text: fullName);
      lastNameController = TextEditingController(text: '');
    }

    emailController = TextEditingController(text: profile.email);
    dateController = TextEditingController(text: profile.dateOfBirth);
    selectedGender = profile.gender;
    _picture = profile.picture;

    String rawPhone = profile.phone;
    selectedCountry = countries.firstWhere(
      (c) => rawPhone.startsWith(c['code']!),
      orElse: () => countries[0],
    );

    String phoneWithoutCode = rawPhone;
    if (rawPhone.startsWith(selectedCountry['code']!)) {
      phoneWithoutCode = rawPhone
          .substring(selectedCountry['code']!.length)
          .trim();
    }
    phoneController = TextEditingController(text: phoneWithoutCode);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);

    DateTime initialDate = DateTime(2000, 1, 1);
    try {
      final parts = dateController.text.split('/');
      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.brightness == Brightness.dark
                ? ColorScheme.dark(primary: Theme.of(context).primaryColor)
                : ColorScheme.light(primary: Theme.of(context).primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      _uploadImage(File(image.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    if (!imageFile.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selected file no longer exists.")),
        );
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not authenticated";

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      await uploadTask.whenComplete(() => null);

      final downloadUrl = await storageRef.getDownloadURL();

      if (mounted) {
        setState(() {
          _picture = downloadUrl;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("Failed to upload image: $e")),
        );
      }
    }
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Profile'.tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black12,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor:
                          isDark ? Colors.white10 : Colors.grey[100],
                      backgroundImage:
                          _picture != null && _picture!.isNotEmpty
                              ? NetworkImage(_picture!)
                              : null,
                       child: _isUploading
                          ? LoadingWidget.loadingCenterWidget()
                          : (_picture == null || _picture!.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: isDark ? Colors.white54 : Colors.grey,
                                )
                              : null),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextWidget("Gender".tr, fontSize: 16, fontWeight: FontWeight.w500),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildGenderRadio("Male"),
                const SizedBox(width: 20),
                _buildGenderRadio("Female"),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'First name'.tr,
                    controller: firstNameController,
                    showCheck: firstNameController.text.isNotEmpty,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInputField(
                    label: 'Last name'.tr,
                    controller: lastNameController,
                    showCheck: lastNameController.text.isNotEmpty,
                    onChanged: (v) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: 'Email'.tr,
              controller: emailController,
              showCheck: emailController.text.isNotEmpty,
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => setState(() {}),
            ),
            const SizedBox(height: 20),

            _buildPhoneInputField(),
            const SizedBox(height: 20),

            _buildInputField(
              label: 'Date of birth (DD/MM/YYYY)'.tr,
              controller: dateController,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 12),
            TextWidget(
              "Add your birthday to unlock additional offering/reward!".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 30),
            TextWidget(
              "Your address".tr,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        "Address book".tr,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      const Icon(Icons.chevron_right, size: 30),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildSaveButton(),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.black;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          'Mobile number'.tr,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: () => _showCountryPicker(),
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    TextWidget(selectedCountry['flag']!, fontSize: 20),
                    const SizedBox(width: 8),
                    TextWidget(
                      selectedCountry['code']!,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Add contact number'.tr,
                  hintStyle: const TextStyle(color: Color(0xFF0055FF)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                "Select Country".tr,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return ListTile(
                      leading: TextWidget(country['flag']!, fontSize: 24),
                      title: TextWidget(country['name']!.tr),
                      trailing: TextWidget(country['code']!),
                      onTap: () {
                        setState(() {
                          selectedCountry = country;
                        });
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

  Widget _buildGenderRadio(String gender) {
    final isSelected = selectedGender == gender;
    return InkWell(
      onTap: () => setState(() => selectedGender = gender),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          TextWidget(gender.tr, fontSize: 16),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    TextEditingController? controller,
    String? hint,
    TextStyle? hintStyle,
    VoidCallback? onTap,
    bool showCheck = false,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: onTap != null,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                hintStyle ??
                TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            suffixIcon: showCheck
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.green,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          String fullName =
              "${firstNameController.text} ${lastNameController.text}".trim();
          String fullPhone =
              "${selectedCountry['code']}${phoneController.text.trim()}";
          
          await ProfileManager().updateProfile(
            name: fullName,
            email: emailController.text,
            phone: fullPhone,
            gender: selectedGender,
            dateOfBirth: dateController.text,
            picture: _picture,
          );
          
          // Trigger birthday check immediately after saving
          CallbackManager().checkBirthdayReward?.call();
          
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidget("Profile updated successfully".tr)),
          );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: TextWidget('Save'.tr, fontWeight: FontWeight.bold, fontSize: 16),
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
