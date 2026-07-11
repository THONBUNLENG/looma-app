import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../constants/navigator_extension.dart';
import 'login_screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigated = false;
  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  void _startNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isNavigated) {
        setState(() {
          _isNavigated = true;
        });
        Go.toRemoveUntil(const WelcomeScreen());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.white, AppColor.grey200],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top + 40,
              child: Column(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppColor.black.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/image/logo4-removebg.png',
                        width: 360,
                        height:360,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextWidget(
                    "PREMIUM SHOPPING",
                    color: AppColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.0,
                  ),
                ],
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Lottie.asset(
                  'assets/lottie/ecommerce_shop_online.json',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),

            Positioned(
              bottom: 60,
              child: Column(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextWidget(
                    "LOOMA SHOPPING",
                    color: AppColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: 30,
                    color: Colors.black12,
                  )
                ],
              ),
            ),
          ],
        ),
        ),
    );
  }
}
