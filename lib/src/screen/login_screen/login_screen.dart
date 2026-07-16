import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../constants/string_extension.dart';
import '../../widget/button_cus.dart';
import '../../widget/text_form_cus.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset('assets/image/login2.png'),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset('assets/image/login1.png', width: 240),
                ),
              ],
            ),
            Positioned(
              top: 300,
              right: 0,
              child: Image.asset('assets/image/login3.png'),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/image/login4.png',
              color: AppColor.accentLightBlue),

            ),
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 400),
                TextWidget(
                  'Login'.tr,
                  fontSize: 50, fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Good to see you back!'.tr,
                      style: TextStyle(fontSize: 19),
                    ),
                    Image.asset('assets/icon/like1.png', width: 22),
                  ],
                ),
                SizedBox(height: 24),
                TextFormCus(hintText: "Email".tr),
                SizedBox(height: 36),
                ButtonCus(
                  buttonName: "Next".tr,
                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => PasswordScreen()),
                  //   );
                  // },
                ),
                SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: TextWidget(
                      "Cancel".tr,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
