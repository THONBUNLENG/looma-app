import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';
import 'qr_scanner_screen.dart';
import '../../../network/datastor/membership_service.dart';
import '../../../model/order_model.dart';

class MembershipQRScreen extends StatefulWidget {
  const MembershipQRScreen({super.key});

  @override
  State<MembershipQRScreen> createState() => _MembershipQRScreenState();
}

class _MembershipQRScreenState extends State<MembershipQRScreen> {
  int _secondsRemaining = 120; // 2 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Membership'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: MembershipService.getOrdersStream(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? [];
          final totalSpent = MembershipService.calculateTotalSpent(orders);
          final level = MembershipService.getLevel(totalSpent);
          final membershipId = MembershipService.getMembershipId();

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextWidget(
                  level.label,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 10),
                TextWidget(
                  "ID: $membershipId",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: level.color,
                ),
                const SizedBox(height: 10),
                Center(
                  child: QrImageView(
                    data: membershipId,
                    version: QrVersions.auto,
                    size: 250.0,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextWidget(
                  "Expire in",
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(height: 10),
                Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: TextWidget(
                      _formatTime(_secondsRemaining),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Membership Benefits",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 15),
                      TextWidget(
                        "You can now become LOOMA member without extra charge when you make your purchase in one receipt from:",
                        fontSize: 14,
                        lineHeight: 1.4,
                      ),
                      const SizedBox(height: 10),
                      _buildBulletPoint("USD5000: SILVER Card (10% Discount)"),
                      _buildBulletPoint("USD10000: GOLD Card (15% Discount)"),
                      _buildBulletPoint("USD100000: PLATINUM Card (20% Discount)"),
                      const SizedBox(height: 20),
                      TextWidget(
                        "All LOOMA members can earn 1 Point with every USD10 purchase. All saved points can be used to upgrade your membership card without point deduction.",
                        fontSize: 14,
                        lineHeight: 1.4,
                      ),
                      const SizedBox(height: 10),
                      _buildBulletPoint("500 Points: Upgrade from ONLINE to SILVER Card"),
                      _buildBulletPoint("1000 Points: Upgrade from SILVER to GOLD Card"),
                      _buildBulletPoint("10000 Points: Upgrade from GOLD to PLATINUM Card"),
                      const SizedBox(height: 20),
                      TextWidget(
                        "point Redemption: 17 Points = USD5 Coupon to spend in store  ",
                        fontSize: 14,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget("• ", fontSize: 14, fontWeight: FontWeight.bold),
          Expanded(
            child: TextWidget(
              text,
              fontSize: 14,
              lineHeight: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
