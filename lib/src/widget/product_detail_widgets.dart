import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryReturnsInfo extends StatelessWidget {
  final bool isDark;
  const DeliveryReturnsInfo({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: textColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Fast Delivery".tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    TextWidget(
                      "From 1 - 3 days".tr,
                      color: subColor,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.assignment_return_outlined,
                color: textColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "RETURNS".tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    TextWidget(
                      "Within 14 days".tr,
                      color: subColor,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final bool isDark;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.isDark,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: Icon(Icons.remove, size: 20, color: isDark ? Colors.white : Colors.black),
          ),
          TextWidget(
            "$quantity",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          IconButton(
            onPressed: onIncrement,
            icon: Icon(Icons.add, size: 20, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}

class ProductFooter extends StatelessWidget {
  final bool isDark;
  const ProductFooter({super.key, required this.isDark});

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/+QWy3vO16nphjODBl');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("LOYALTY", isDark),
                  _buildFooterItem(
                    Icons.favorite_outline,
                    "Membership & Benefits",
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("FOLLOW US", isDark),
                  _buildFooterItem(Icons.facebook, "Facebook", isDark),
                  _buildFooterItem(
                    Icons.camera_alt_outlined,
                    "Instagram",
                    isDark,
                  ),
                  _buildFooterItem(Icons.music_note, "TikTok", isDark),
                  _buildFooterItem(
                    Icons.play_circle_outline,
                    "Youtube",
                    isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSectionTitle("CUSTOMER SERVICES", isDark),
        _buildFooterItem(Icons.help_outline, "Online exchange policy", isDark),
        _buildFooterItem(Icons.security, "Privacy Policy", isDark),
        _buildFooterItem(Icons.chat_bubble_outline, "FAQs & guides", isDark),
        _buildFooterItem(Icons.location_on_outlined, "Find a store", isDark),
        const SizedBox(height: 30),
        _buildSectionTitle("CONTACT US", isDark),
        _buildFooterItem(
          Icons.email_outlined,
          "customer.care@loomakh.com",
          isDark,
        ),
        _buildFooterItem(Icons.phone_outlined, "(+855) 011 820 595", isDark),
        _buildFooterItem(
          Icons.send,
          "Telegram",
          isDark,
          onTap: _launchTelegram,
        ),
        const SizedBox(height: 30),
        _buildSectionTitle("WE ACCEPT", isDark),
        const SizedBox(height: 10),
        const PaymentMethodsGrid(),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextWidget(
        title.tr,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String title, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black87),
            const SizedBox(width: 10),
            Expanded(
              child: TextWidget(
                title.tr,
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodsGrid extends StatelessWidget {
  const PaymentMethodsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildPaymentBox("ABA", const Color(0xFF005A9C), isDark, imagePath: 'assets/icon/i_color/aba.png'),
        _buildPaymentBox("VISA", const Color(0xFF1A1F71), isDark, imagePath: 'assets/icon/i_color/visa.png'),
        _buildPaymentBox("MasterCard", const Color(0xFFEB001B), isDark, imagePath: 'assets/icon/i_color/mastercard.png'),
        _buildPaymentBox("Wing", const Color(0xFF8DC63F), isDark, imagePath: 'assets/icon/i_color/wing.png'),
        _buildPaymentBox("UnionPay", const Color(0xFF00334E), isDark, imagePath: 'assets/icon/i_color/union_pay.png'),
        _buildPaymentBox("JCB", const Color(0xFF00338D), isDark, imagePath: 'assets/icon/i_color/jcb.png'),
        _buildPaymentBox("Chip Mong", const Color(0xFF00833E), isDark, imagePath: 'assets/icon/i_color/chip_mong.png'),
        _buildPaymentBox("Bank Transfer", Colors.grey, isDark, imagePath: 'assets/icon/i_color/bank_transfer.png'),
        _buildPaymentBox("Cash on Delivery", Colors.brown, isDark, imagePath: 'assets/icon/i_color/cash_on_delivery.png'),
        _buildPaymentBox("PayPal", Colors.amber, isDark, imagePath: 'assets/icon/i_color/paypal.png'),
        _buildPaymentBox("Acleda Bank", Colors.pinkAccent, isDark, imagePath: 'assets/icon/i_color/ac.png'),
        _buildPaymentBox("Google Pay", AppColor.accentLightBlue, isDark, imagePath: 'assets/icon/i_color/google_pay.png'),
      ],
    );
  }

  Widget _buildPaymentBox(String label, Color color, bool isDark, {String? imagePath}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      height: 35,
      child: imagePath != null
          ? Image.asset(imagePath, fit: BoxFit.contain)
          : Center(
              child: TextWidget(
                label.tr,
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
    );
  }
}
