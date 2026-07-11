
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/login_screen/password_recovery_2.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../constants/color.dart';
import '../../widget/button_cus.dart';
import 'chip_select.dart';

class PasswordRecovery extends StatelessWidget {
  const PasswordRecovery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [],
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/image/login2.png'),
            ),
            Positioned(
              top: -64,
              left: -60,
              child: Image.asset('assets/image/login1.png', width: 360),
            ),

            ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(height: 150),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 24),
                      // BoxShadow(color: Colors.black12),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Password Recovery",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "How you would like to restore \nyour password?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 35),
                    ChipSelect(
                      isSelected: true,
                      chipLabel: "SMS",
                      chipColor: mainColor,
                    ),
                    SizedBox(height: 20),
                    ChipSelect(
                      isSelected: false,
                      chipLabel: "Email",
                      fontWeight: FontWeight.normal,
                      chipColor: orageColor,
                      textColor: Colors.black,
                    ),
                    SizedBox(height: 220),

                    ButtonCus(
                      buttonName: "Next",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordRecovery2(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),

                    TextButton(
                      onPressed: () {},
                      child: TextWidget(
                        "Cancel",
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
