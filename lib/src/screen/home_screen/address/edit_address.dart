import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:shopping_app/constants/address_data.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  const EditAddressScreen({super.key, required this.addressData});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;

  String? selectedCountry = "Cambodia";
  String? selectedCity; // Now used for Province
  String? selectedDistrict;
  String? selectedCommune;
  String? selectedLabel = "Home";
  bool _isDefault = false;

  List<String> get cities => (cambodiaAdministrativeData['provinces'] as List)
      .map((p) => p['en'] as String)
      .toList();

  List<Map<String, String>> get currentDistricts {
    if (selectedCity == null) return [];
    final province = (cambodiaAdministrativeData['provinces'] as List)
        .firstWhereOrNull((p) => p['en'] == selectedCity);
    if (province == null) return [];
    return (province['districts'] as List)
        .map((d) => {"en": d['en'] as String, "km": d['km'] as String})
        .toList();
  }

  List<String> get currentCommunes {
    if (selectedCity == null || selectedDistrict == null) return [];
    final province = (cambodiaAdministrativeData['provinces'] as List)
        .firstWhereOrNull((p) => p['en'] == selectedCity);
    if (province == null) return [];
    final district = (province['districts'] as List)
        .firstWhereOrNull((d) => d['en'] == selectedDistrict);
    if (district == null || district['communes'] == null) return [];
    return (district['communes'] as List)
        .map((c) => c['en'] as String)
        .toList();
  }

  String getTranslation(String enName, {bool isProvince = true}) {
    if (isProvince) {
      final province = (cambodiaAdministrativeData['provinces'] as List)
          .firstWhereOrNull((p) => p['en'] == enName);
      return province != null ? province['km'] : enName;
    } else {
      // Handles districts and communes
      final province = (cambodiaAdministrativeData['provinces'] as List)
          .firstWhereOrNull((p) => p['en'] == selectedCity);
      if (province != null) {
        final district = (province['districts'] as List)
            .firstWhereOrNull((d) => d['en'] == enName);
        if (district != null) return district['km'];

        if (selectedDistrict != null) {
          final selDistrict = (province['districts'] as List)
              .firstWhereOrNull((d) => d['en'] == selectedDistrict);
          if (selDistrict != null && selDistrict['communes'] != null) {
            final commune = (selDistrict['communes'] as List)
                .firstWhereOrNull((c) => c['en'] == enName);
            if (commune != null) return commune['km'];
          }
        }
      }
      return enName;
    }
  }

  final List<String> communes = [
    "Tonle Bassac",
    "Boeng Keng Kang I",
    "Boeng Keng Kang II",
  ];

  @override
  void initState() {
    super.initState();
    // Try to parse existing data if possible
    String title = widget.addressData['title'] ?? "";
    List<String> nameParts = title.split(' ');
    if (nameParts.length > 1) {
      _firstNameController = TextEditingController(
        text: nameParts.sublist(0, nameParts.length - 1).join(' '),
      );
      _lastNameController = TextEditingController(text: nameParts.last);
    } else {
      _firstNameController = TextEditingController(text: title);
      _lastNameController = TextEditingController(text: '');
    }

    _phoneController = TextEditingController(
      text: widget.addressData['phone'] ?? "",
    );
    _streetController = TextEditingController(
      text: widget.addressData['street'] ?? widget.addressData['address'] ?? "",
    );
    _isDefault = widget.addressData['isDefault'] ?? false;
    selectedLabel = widget.addressData['label'] ?? "Home";
    selectedCity = widget.addressData['city'];
    selectedDistrict = widget.addressData['district'];
    selectedCommune = widget.addressData['commune'];
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    super.dispose();
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
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "Edit address".tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              label: "First name(Required)".tr,
              controller: _firstNameController,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "Last name(Required)".tr,
              controller: _lastNameController,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "Telephone(Required)".tr,
              controller: _phoneController,
              hint: "Enter phone number".tr,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: "Country".tr,
                    value: selectedCountry,
                    items: ["Cambodia"],
                    onChanged: (val) => setState(() => selectedCountry = val),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdownField(
                    label: "City/province(Required)".tr,
                    value: selectedCity,
                    items: cities,
                    onChanged: (val) {
                      setState(() {
                        selectedCity = val;
                        selectedDistrict = null;
                        selectedCommune = null;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: "District/Khan(Required)".tr,
                    value: selectedDistrict,
                    hint: "Select a District...".tr,
                    items: currentDistricts.map((d) => d['en']!).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDistrict = val;
                        selectedCommune = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdownField(
                    label: "Commune/Sangkat(Required)".tr,
                    value: selectedCommune,
                    hint: "Select a Commune".tr,
                    items: currentCommunes,
                    onChanged: (val) => setState(() => selectedCommune = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              label: "Street, Apartment, Building, Floor(Required)".tr,
              controller: _streetController,
              hint: "Enter Street, Apartment, Building and Floor".tr,
            ),
            const SizedBox(height: 20),
            TextWidget(
              "Label".tr,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabelButton("Home"),
                _buildLabelButton("Office"),
                _buildLabelButton("Other"),
              ],
            ),
            const SizedBox(height: 25),
            _buildDefaultCheckbox(),
            const SizedBox(height: 30),
            _buildDeleteButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              if (_firstNameController.text.trim().isEmpty ||
                  _lastNameController.text.trim().isEmpty ||
                  _phoneController.text.trim().isEmpty ||
                  selectedCity == null ||
                  selectedDistrict == null ||
                  selectedCommune == null ||
                  _streetController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: TextWidget("Please fill all required fields".tr),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final street = _streetController.text.trim();
              final commune = selectedCommune ?? "";
              final district = selectedDistrict ?? "";
              final city = selectedCity ?? "";
              final country = selectedCountry ?? "";

              // Construct full address string
              final fullAddress = [
                street,
                commune,
                district,
                city,
                country
              ].where((s) => s.isNotEmpty).join(", ");

              final updatedData = {
                "title":
                    "${_firstNameController.text} ${_lastNameController.text}"
                        .trim(),
                "address": fullAddress,
                "street": street,
                "phone": _phoneController.text,
                "country": selectedCountry,
                "city": selectedCity,
                "district": selectedDistrict,
                "commune": selectedCommune,
                "label": selectedLabel,
                "isDefault": _isDefault,
              };
              Navigator.pop(context, updatedData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.pink100Color,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: TextWidget(
              'Save'.tr,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context, "deleted");
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            const SizedBox(width: 8),
            TextWidget(
              "Delete Address".tr,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
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
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 14,
            ),
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
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.black;

    String displayText = value ?? hint ?? "";
    if (value != null) {
      if (label.contains("City/province")) {
        displayText = "${getTranslation(value, isProvince: true)} / $value";
      } else if (label.contains("District") || label.contains("Commune")) {
        displayText = "${getTranslation(value, isProvince: false)} / $value";
      }
    }

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
        InkWell(
          onTap: () => _showSelectionSheet(label, items, value, onChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                    displayText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: value == null && hint != null ? (isDark ? Colors.white38 : Colors.black38) : null,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSelectionSheet(
    String title,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onSelected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: TextWidget(
                          title,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for the close button
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    String labelText = item;
                    if (title.contains("City/province")) {
                      labelText =
                          "${getTranslation(item, isProvince: true)} / $item";
                    } else if (title.contains("District") ||
                        title.contains("Commune")) {
                      labelText =
                          "${getTranslation(item, isProvince: false)} / $item";
                    }

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      title: TextWidget(
                        labelText,
                        fontSize: 16,
                        fontWeight: item == selectedValue ? FontWeight.bold : FontWeight.normal,
                      ),
                      onTap: () {
                        onSelected(item);
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

  Widget _buildLabelButton(String label) {
    final isSelected = selectedLabel == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => selectedLabel = label),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            TextWidget(label.tr, fontSize: 14, fontWeight: FontWeight.w500),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCheckbox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => setState(() => _isDefault = !_isDefault),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isDefault ? Colors.green : Colors.transparent,
              border: Border.all(
                color: _isDefault
                    ? Colors.green
                    : (isDark ? Colors.white24 : Colors.grey.shade400),
                width: 1,
              ),
            ),
            child: _isDefault
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          TextWidget(
            "Set As Default".tr,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
