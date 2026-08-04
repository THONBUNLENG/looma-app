import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_detail_screen.dart';
import 'package:shopping_app/src/screen/home_screen/order/payment_history.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/constants/string_extension.dart';
import '../../../../constants/app_color.dart';
import '../../../widget/text_widget.dart';

import 'track_order_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, dynamic>> allOrders = [
    {
      "id": "#1000137",
      "date": "2024-05-18 10:27:08",
      "status": "pending",
      "total": "40.00 USD",
      "items": "1",
      "discount": "0.00 USD",
      "totalAmount": "40.00 USD",
    },
    {
      "id": "#1000138",
      "date": "2024-05-19 11:30:00",
      "status": "Already Paid",
      "total": "120.00 USD",
      "items": "2",
      "discount": "10.00 USD",
      "totalAmount": "110.00 USD",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextWidget(
            'My Orders'.tr,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [const CartBadge()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: TabBar(
              indicatorColor: AppColor.pink,
              labelColor: AppColor.pink,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: "All Order".tr),
                Tab(text: "Await Payment".tr),
                Tab(text: "Already Paid".tr),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(allOrders, isDark),
            _buildOrderList(
                allOrders.where((o) => o['status'] == 'pending').toList(),
                isDark),
            _buildOrderList(
                allOrders.where((o) => o['status'] != 'pending').toList(),
                isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, bool isDark) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            TextWidget(
              "No data available".tr,
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, isDark);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark) {
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final isPending = order['status'] == 'pending';
    final statusText = isPending ? "Await Payment".tr : "Already Paid".tr;
    final statusColor = isPending ? Colors.orange : AppColor.successGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                order['id'],
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(height: 4),
          TextWidget(
            order['date'],
            color: isDark ? Colors.white54 : Colors.grey,
            fontSize: 13,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          _buildInfoRow("Total".tr, order['total'], isDark),
          const SizedBox(height: 10),
          _buildInfoRow("Total Item".tr, order['items'], isDark),
          const SizedBox(height: 10),
          _buildInfoRow("Discount".tr, order['discount'], isDark),
          const SizedBox(height: 10),
          _buildInfoRow("Total Amount".tr, order['totalAmount'], isDark, isBold: true),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildCardButton(
                  "View tracking".tr,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackOrderScreen(order: order),
                      ),
                    );
                  },
                  isDark,
                  borderColor: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCardButton(
                  "Payment".tr,
                  isPending
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentHistory(order: order),
                            ),
                          );
                        }
                      : () {},
                  isDark,
                  backgroundColor: isPending ? null : (isDark ? Colors.white10 : Colors.grey[100]),
                  textColor: isPending ? null : Colors.grey,
                  borderColor: isPending ? (isDark ? Colors.white24 : Colors.grey.shade300) : Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCardButton(
                  "Detail".tr,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  isDark,
                  backgroundColor: AppColor.pink,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
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
          color: isBold ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white70 : Colors.black87),
        ),
      ],
    );
  }

  Widget _buildCardButton(
    String label,
    VoidCallback onTap,
    bool isDark, {
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      height: 38,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        child: TextWidget(
          label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor ?? (isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
