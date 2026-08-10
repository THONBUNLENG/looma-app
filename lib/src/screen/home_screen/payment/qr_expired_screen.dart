import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../widget/button_cus.dart';

class QrExpiredScreen extends StatelessWidget {
  final VoidCallback onRefresh;

  const QrExpiredScreen({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
          TextWidget(
                'QR code has\nexpired',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 48),
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/image/qr.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD32F2F),
                        width: 12,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -0.785398, // -45 degrees in radians
                    child: Container(
                      width: 180,
                      height: 12,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
             TextWidget(
                'Ensure you have a stable internet connection and try again.',
                textAlign: TextAlign.center,
               fontSize: 18,
               fontWeight: FontWeight.w500,
               color: Color(0xFF212121),
              ),
              const Spacer(flex: 3),
              ButtonCus(
                buttonName: 'Refresh QR',
                onPressed: () {
                  Navigator.of(context).pop();
                  onRefresh();
                },
                bgColor: const Color(0xFF1976D2),
              ),
              const SizedBox(height: 12),
              ButtonCus(
                buttonName: 'Go to Home',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                bgColor: Colors.grey[800] ?? Colors.black,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
