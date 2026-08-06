import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/app_color.dart';

class TrackOrderScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const TrackOrderScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Track Order'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildBarcodeSection(context),
            const SizedBox(height: 30),
            _buildTrackingTimeline(context),
            const SizedBox(height: 20),
            _buildOrderDetails(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Image.asset(
          'assets/icon/i_color/receipt.png',
          height: 150,
          color: isDark ? Colors.white : Colors.black,
        ),
        const SizedBox(height: 10),
        TextWidget(
          order['id'] ?? '#1000137',
          letterSpacing: 2,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black,
        ),
      ],
    );
  }

  Widget _buildTrackingTimeline(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = order['status']?.toString().toLowerCase() ?? 'pending';

    // Simplified logic for timeline based on status
    final steps = [
      {'title': 'Order Placed'.tr, 'desc': 'Your order has been received'.tr, 'isDone': true},
      {'title': 'Processing'.tr, 'desc': 'We are preparing your items'.tr, 'isDone': status != 'pending' && status != 'await payment'},
      {'title': 'Shipped'.tr, 'desc': 'Order is on the way to you'.tr, 'isDone': status == 'already paid' || status == 'shipped'},
      {'title': 'Delivered'.tr, 'desc': 'Enjoy your products!'.tr, 'isDone': status == 'delivered'},
    ];

    return _buildInfoCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Tracking Status".tr,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 20),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;
            final isDone = step['isDone'] as bool;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isDone ? AppColor.pink : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? AppColor.pink : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 50,
                        color: isDone ? AppColor.pink : Colors.grey[300],
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        step['title'] as String,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDone ? (isDark ? Colors.white : Colors.black) : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      TextWidget(
                        step['desc'] as String,
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                if (isDone && index == steps.indexWhere((s) => !(s['isDone'] as bool)) - 1 || (isDone && index == steps.length - 1))
                  TextWidget(
                    order['date']?.toString().split(' ')[0] ?? '2024-05-18',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discount = order['discountAmount'] ?? 0.0;
    
    return _buildInfoCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Order Details".tr,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 16),
          _buildRow(context, "Items".tr, order['items'] ?? "1"),
          if (discount > 0) ...[
            const SizedBox(height: 12),
            _buildRow(
              context,
              "Discount".tr,
              "- ${discount.toStringAsFixed(2)} USD",
              valueColor: Colors.redAccent,
            ),
          ],
          const SizedBox(height: 12),
          _buildRow(context, "Total".tr, order['totalAmount'] ?? "40.00 USD", isBold: true),
          const SizedBox(height: 12),
          _buildRow(context, "Status".tr, order['status'] ?? "pending", valueColor: AppColor.pink),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey, fontSize: 14),
        TextWidget(
          value,
          fontSize: 14,
          color: valueColor ?? (isDark ? Colors.white : Colors.black),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
        ),
      ],
    );
  }
}
