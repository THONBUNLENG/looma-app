import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final String paymentMethod;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardBgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA);

    return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Screen Header
                Center(
                  child: TextWidget(
                    "Order Successfully".tr,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),

                const Spacer(),
                Lottie.asset(
                  'assets/lottie/delivery.json',
                  width: 200,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),

                // Khmer Success Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TextWidget(
                        "សូមអរគុណ",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                      const SizedBox(height: 6),
                      TextWidget(
                        "ការកុម្ម៉ង់របស់អ្នកជោគជ័យ",
                        fontSize: 16,
                        color: secondaryTextColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Order Summary Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        label: "Order ID".tr,
                        value: "#$orderId",
                        textColor: primaryTextColor,
                        secondaryColor: secondaryTextColor,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        label: "Payment Method".tr,
                        value: paymentMethod,
                        textColor: primaryTextColor,
                        secondaryColor: secondaryTextColor,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        label: "Total Amount".tr,
                        value: "\$${totalAmount.toStringAsFixed(2)}",
                        isBold: true,
                        textColor: primaryTextColor,
                        secondaryColor: secondaryTextColor,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Action Buttons
                Row(
                  children: [
                    // Back Shopping
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront_outlined, size: 20, color: primaryTextColor),
                            const SizedBox(width: 8),
                            TextWidget(
                              "Back Shopping".tr,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Order History
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrderScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, size: 20, color: Colors.white),
                            const SizedBox(width: 8),
                            TextWidget(
                              "Order History".tr,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
    );
    }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required Color textColor,
    required Color secondaryColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          label,
          fontSize: 14,
          color: secondaryColor,
        ),
        TextWidget(
          value,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: textColor,
        ),
      ],
    );
  }
}