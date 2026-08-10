import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';
import '../../../../manager/preferences_manager.dart';
import '../../../widget/button.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController _pinController = TextEditingController();

  bool _isConfirming = false;
  String _firstPin = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleSavePin() async {
    final pin = _pinController.text;
    
    if (pin.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget("Please enter a 6-digit PIN".tr)),
      );
      return;
    }

    if (!_isConfirming) {
      setState(() {
        _firstPin = pin;
        _isConfirming = true;
        _pinController.clear();
      });
    } else {
      if (pin != _firstPin) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("PINs do not match".tr)),
        );
        _pinController.clear();
        return;
      }

      setState(() => _isLoading = true);
      
      try {
        await PreferencesManager().setGetString(PrefKey.pin, pin);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidget("PIN updated successfully!".tr)),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: isDark ? Colors.white : const Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? Colors.white24 : const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.buttonColor),
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 30, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "Change PIN".tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.buttonColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 50,
                color: AppColor.buttonColor,
              ),
            ),
            const SizedBox(height: 30),
            TextWidget(
              _isConfirming ? "Confirm PIN".tr : "Set New PIN".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 12),
            TextWidget(
              _isConfirming 
                ? "Please re-enter your 6-digit PIN to confirm".tr 
                : "Create a 6-digit PIN to secure your account".tr,
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.grey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Pinput(
              length: 6,
              controller: _pinController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              obscureText: true,
              showCursor: true,
              onCompleted: (pin) => _handleSavePin(),
            ),
            const SizedBox(height: 60),
            MyCustomButton(
              text: _isLoading 
                ? "Saving...".tr 
                : (_isConfirming ? "Confirm".tr : "Continue".tr),
              width: double.infinity,
              height: 58,
              borderRadius: 15,
              gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
              onPressed: _isLoading ? () {} : _handleSavePin,
            ),
            if (_isConfirming) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isConfirming = false;
                    _pinController.clear();
                  });
                },
                child: TextWidget(
                  "Back".tr,
                  fontSize: 16,
                  color: AppColor.buttonColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
