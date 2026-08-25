import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/payment_model.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class SelectPaymentScreen extends StatefulWidget {
  final int selectedIndex;
  final bool isPhnomPenh;

  const SelectPaymentScreen({
    super.key,
    required this.selectedIndex,
    required this.isPhnomPenh,
  });

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex >= 0 && widget.selectedIndex < kPaymentMethods.length) {
      _selectedIndex = widget.selectedIndex;
    } else {
      _selectedIndex = -1;
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: TextWidget(
          "Select a payment".tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: kPaymentMethods.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final methodInfo = kPaymentMethods[index];
          final isSelected = _selectedIndex == index;
          final isCod = methodInfo.method == PaymentMethod.cashOnDelivery;
          final bool isEnabled = !isCod || widget.isPhnomPenh;

          return InkWell(
            onTap: isEnabled
                ? () {
                    setState(() => _selectedIndex = index);
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        Navigator.pop(context, index);
                      }
                    });
                  }
                : null,
            child: Opacity(
              opacity: isEnabled ? 1.0 : 0.4,
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_off,
                    color: isSelected ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  _buildMethodIcon(methodInfo, isDark),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          methodInfo.title.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        if (methodInfo.subtitle.isNotEmpty)
                          TextWidget(
                            methodInfo.subtitle.tr,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        if (isCod && !widget.isPhnomPenh)
                          TextWidget(
                            "Available in Phnom Penh only".tr,
                            fontSize: 10,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMethodIcon(PaymentMethodInfo method, bool isDark) {
    final bool isCard = method.method == PaymentMethod.visa;

    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: isCard ? EdgeInsets.zero : const EdgeInsets.all(4),
      child: isCard ? _buildCardIcon(method, isDark) : _safeAsset(method.icon, fit: BoxFit.contain),
    );
  }

  Widget _buildCardIcon(PaymentMethodInfo method, bool isDark) {
    final logos = method.logos ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _safeAsset(
          method.icon,
          height: 24,
          fit: BoxFit.contain,
        ),
        if (logos.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: logos.map((logo) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: _safeAsset(logo, height: 8, fit: BoxFit.contain),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _safeAsset(
    String path, {
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    if (path.isEmpty) {
      return Icon(Icons.image_not_supported, size: height ?? 20, color: Colors.grey);
    }
    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image_not_supported, size: height ?? 20, color: Colors.grey);
      },
    );
  }
}
