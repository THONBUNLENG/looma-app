
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/login_screen/password_dot.dart';
import 'package:shopping_app/src/screen/login_screen/password_recovery.dart';

import '../../../constants/color.dart';

class PasswordTypeScreen extends StatefulWidget {
  const PasswordTypeScreen({super.key});
  static const int pinLenth = 8;

  @override
  State<PasswordTypeScreen> createState() => _PasswordTypeScreenState();
}

class _PasswordTypeScreenState extends State<PasswordTypeScreen> {
  final _controller = TextEditingController();
  PinStatus _status = PinStatus.typing;

  String correctPassword = "12345678";

  @override
  void initState() {
    _controller.text = correctPassword;
    super.initState();
  }

  void _onPinComplete(String pin) {
    setState(() {
      if (pin.length < PasswordTypeScreen.pinLenth) {
        _status = PinStatus.typing;
        return;
      }
      _status = pin == correctPassword ? PinStatus.correct : PinStatus.wrong;

      if (_status == PinStatus.wrong) {
        Future.delayed(Duration(microseconds: 300), () {
          _controller.clear();
          _status = PinStatus.typing;
        });
      }
      if (_status == PinStatus.correct) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordRecovery()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not you?",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordRecovery()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: mainColor,
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ],
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
                  top: -64,
                  left: -60,
                  child: Image.asset('assets/image/login1.png', width: 360),
                ),
              ],
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
                      "Hello Romina!!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text("Type your password", style: TextStyle(fontSize: 19)),
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        PasswordDot(
                          status: _status,
                          fillCount: _controller.text.length,
                          totalCount: PasswordTypeScreen.pinLenth,
                        ),
                        Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            onChanged: (value) => _onPinComplete(value),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
                    Text("Forgot your password?"),
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
