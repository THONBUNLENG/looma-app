import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';


class PaymentSettingsScreen extends StatelessWidget {
  const PaymentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: TextWidget(
          'Payment'.tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                PaymentMethodTile(
                  title: 'ABA Bank',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/aba.png',
                ),
                PaymentMethodTile(
                  title: 'ACLEDA Bank',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/ac.png',
                ),
                PaymentMethodTile(
                  title: 'Wing Bank',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/wing.png',
                ),
                PaymentMethodTile(
                  title: 'True Money',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/true_money.png',
                ),
                PaymentMethodTile(
                  title: '•••• •••• •••• 8888',
                  subtitle: 'Mastercard',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/mastercard.png',
                ),
                PaymentMethodTile(
                  title: 'PayPal',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/paypal.png',
                ),
                PaymentMethodTile(
                  title: 'Visa Card',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/visa.png',
                ),
                PaymentMethodTile(
                  title: 'Google Pay',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/google_pay.png',
                ),
                PaymentMethodTile(
                  title: 'Apple Pay',
                  status: 'Connected',
                  imagePath: 'assets/icon/i_color/apple.png',
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String imagePath;

  const PaymentMethodTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
        title: Text(
          title.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle.tr,
                style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
              )
            : null,
        trailing: Text(
          status.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
