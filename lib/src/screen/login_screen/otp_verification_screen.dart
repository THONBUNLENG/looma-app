import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/string_extension.dart';
import '../../network/datastor/auth_login_service.dart';
import '../../network/datastor/auth_service.dart';
import '../../widget/button.dart';
import '../main_screen/main_holder.dart';
import 'set_new_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final bool isResetPasswordMode;

  const OTPVerificationScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.isResetPasswordMode = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    final code = _otpController.text.trim();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 6-digit OTP".tr)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await AuthLoginService().signInWithOTP(
        verificationId: widget.verificationId,
        smsCode: code,
      );

      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;

        if (widget.isResetPasswordMode) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SetNewPasswordScreen()),
            );
          }
        } else {
          await AuthService.saveLoginData(
            username: user.displayName ?? "User",
            phone: user.phoneNumber ?? widget.phoneNumber,
            picture: user.photoURL,
            token: await user.getIdToken(),
          );

          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainHolder()),
              (route) => false,
            );
          }
        }
      } else {
        throw "Invalid verification code";
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.buttonColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextWidget(
              "OTP Verification".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 16),
            TextWidget(
              "${"Enter the code sent to".tr} ${widget.phoneNumber}",
              fontSize: 14,
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Pinput(
              length: 6,
              controller: _otpController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              autofillHints: const [AutofillHints.oneTimeCode],
              showCursor: true,
              onCompleted: (pin) => _verifyOTP(),
            ),
            const SizedBox(height: 48),
            MyCustomButton(
              text: _isLoading ? "Verifying...".tr : "Verify".tr,
              width: double.infinity,
              height: 58,
              borderRadius: 15,
              gradientColors: const [AppColor.buttonColor, AppColor.buttonColor],
              onPressed: _isLoading ? () {} : _verifyOTP,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextWidget(
                "Change Phone Number".tr,
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
