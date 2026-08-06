import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "Order Detail".tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(context, isDark),
            const SizedBox(height: 24),
            TextWidget("Items".tr, fontSize: 16, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            _buildItemsList(context, isDark),
            const SizedBox(height: 24),
            TextWidget(
              "Shipping Address".tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _buildShippingAddress(context, isDark),
            const SizedBox(height: 24),
            TextWidget(
              "Payment Summary".tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            _buildPaymentSummary(context, isDark),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context, bool isDark) {
    final status = order['status']?.toString().toLowerCase() ?? 'pending';
    final isPending = status == 'pending' || status == 'await payment';
    final statusText = isPending ? "Await Payment".tr : "Already Paid".tr;
    final statusColor = isPending ? Colors.orange : AppColor.successGreen;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget("Order ID".tr, fontSize: 12, color: Colors.grey),
              const SizedBox(height: 4),
              TextWidget(
                order['id'] ?? 'Unknown',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextWidget(
              statusText,
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, bool isDark) {
    final List<dynamic> items = order['rawItems'] ?? [];

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: TextWidget("No items".tr)),
      );
    }

    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: item['image'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      item['title'] ?? item['name'] ?? "Product".tr,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      "${"Qty".tr}: ${item['quantity'] ?? 1}",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      "\$${(item['price'] ?? 0.0).toStringAsFixed(2)}",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pink,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShippingAddress(BuildContext context, bool isDark) {
    final Map<String, dynamic> address = order['rawAddress'] ?? {};
    final addressText = address.isNotEmpty
        ? "${address['name'] ?? ''}\n${address['street'] ?? ''}, ${address['city'] ?? ''}, ${address['country'] ?? ''}"
        : "No address provided".tr;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColor.pink,
                size: 20,
              ),
              const SizedBox(width: 8),
              TextWidget(
                address['label'] ?? "Shipping Address".tr,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextWidget(addressText, fontSize: 13, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Payment Method".tr,
            (order['paymentMethod']?.toString() ?? "Unknown").tr,
            isDark,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            "Delivery Method".tr,
            (order['deliveryMethod']?.toString() ?? "Standard").tr,
            isDark,
          ),
          const Divider(height: 30),
          _buildSummaryRow(
            "Subtotal".tr,
            order['total']?.toString() ?? "0.00 USD",
            isDark,
          ),
          const SizedBox(height: 10),
          _buildSummaryRow("Shipping".tr, "0.00 USD", isDark),
          const SizedBox(height: 10),
          _buildSummaryRow(
            "Discount".tr,
            order['discount']?.toString() ?? "0.00 USD",
            isDark,
            valueColor: Colors.red,
          ),
          const Divider(height: 30),
          _buildSummaryRow(
            "Total Amount".tr,
            order['totalAmount']?.toString() ?? "0.00 USD",
            isDark,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          label,
          fontSize: 14,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
        TextWidget(
          value,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color:
              valueColor ??
              (isBold
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? Colors.white70 : Colors.black87)),
        ),
      ],
    );
  }
}
