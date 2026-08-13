import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/src/model/order_model.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_detail_screen.dart';
import 'package:shopping_app/src/screen/home_screen/order/payment_details.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/constants/string_extension.dart';
import '../../../../constants/app_color.dart';
import '../../../widget/text_widget.dart';
import 'package:lottie/lottie.dart';

import 'track_order_screen.dart'; 

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_currentUserId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: TextWidget("My Orders".tr)),
        body: Center(child: TextWidget("Please login to view orders".tr)),
      );
    }

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
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
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
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              tabs: [
                Tab(text: "All Order".tr),
                Tab(text: "Await Payment".tr),
                Tab(text: "Already Paid".tr),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: _currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: TextWidget("Error: ${snapshot.error}"));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders =
                snapshot.data?.docs
                    .map((doc) => OrderModel.fromFirestore(doc))
                    .toList() ??
                [];

            orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            return TabBarView(
              children: [
                _buildOrderList(orders, isDark),
                _buildOrderList(
                  orders
                      .where(
                        (o) =>
                            o.status.toLowerCase() == 'pending' ||
                            o.status.toLowerCase() == 'await payment',
                      )
                      .toList(),
                  isDark,
                ),
                _buildOrderList(
                  orders
                      .where(
                        (o) =>
                            o.status.toLowerCase() != 'pending' &&
                            o.status.toLowerCase() != 'await payment',
                      )
                      .toList(),
                  isDark,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders, bool isDark) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/no_connection.json',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
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
  
  Widget _buildOrderCard(OrderModel order, bool isDark) {
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;
    final statusLower = order.status.toLowerCase();
    final isPending =
        statusLower == 'pending' || statusLower == 'await payment';
    final statusText = isPending ? "Await Payment".tr : "Already Paid".tr;
    final statusColor = isPending ? Colors.orange : AppColor.successGreen;

    // Calculate subtotal from total and discount for display purposes
    final subtotalAmount = order.totalAmount + (order.discountAmount ?? 0.0);

    // Convert OrderModel to Map for Detail and Tracking screens (compatibility)
    final orderMap = {
      "id": order.id,
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(order.createdAt),
      "status": order.status,
      "total": "${subtotalAmount.toStringAsFixed(2)} USD",
      "items": order.items.length.toString(),
      "discount": "-${(order.discountAmount ?? 0.0).toStringAsFixed(2)} USD",
      "totalAmount": "${order.totalAmount.toStringAsFixed(2)} USD",
      "rawItems": order.items,
      "rawAddress": order.address,
      "promoCode": order.promoCode,
      "discountAmount": order.discountAmount ?? 0.0,
      "paymentMethod": order.paymentMethod,
      "deliveryMethod": order.deliveryMethod,
      "pointsRedeemed": order.pointsRedeemed,
      "pointsRewarded": order.pointsRewarded,
    };

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
                order.id ?? 'Unknown',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
            DateFormat('yyyy-MM-dd HH:mm:ss').format(order.createdAt),
            color: isDark ? Colors.white54 : Colors.grey,
            fontSize: 13,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          _buildInfoRow(
            "Subtotal".tr,
            "${subtotalAmount.toStringAsFixed(2)} USD",
            isDark,
          ),
          const SizedBox(height: 10),
          _buildInfoRow("Total Item".tr, order.items.length.toString(), isDark),
          const SizedBox(height: 10),
          if (order.discountAmount != null && order.discountAmount! > 0) ...[
            _buildInfoRow(
              "Discount".tr,
              "-\$${order.discountAmount!.toStringAsFixed(2)} USD",
              isDark,
              valueColor: Colors.redAccent,
            ),
            const SizedBox(height: 10),
          ],
          if (order.pointsRedeemed != null && order.pointsRedeemed! > 0) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              "Points Redeemed".tr,
              "${order.pointsRedeemed} pts",
              isDark,
              valueColor: Colors.green,
            ),
          ],
          if (order.pointsRewarded != null && order.pointsRewarded! > 0) ...[
            const SizedBox(height: 10),
            _buildInfoRow(
              "Points Received".tr,
              "+${order.pointsRewarded} pts",
              isDark,
              valueColor: Colors.blue,
            ),
          ],
          const SizedBox(height: 10),
          _buildInfoRow(
            "Total Amount".tr,
            "${order.totalAmount.toStringAsFixed(2)} USD",
            isDark,
            isBold: true,
          ),
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
                        builder: (context) => TrackOrderScreen(order: orderMap),
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
                              builder: (context) =>
                                  PaymentDetails(order: orderMap),
                            ),
                          );
                        }
                      : () {},
                  isDark,
                  backgroundColor: isPending
                      ? null
                      : (isDark ? Colors.white10 : Colors.grey[100]),
                  textColor: isPending ? null : Colors.grey,
                  borderColor: isPending
                      ? (isDark ? Colors.white24 : Colors.grey.shade300)
                      : Colors.transparent,
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
                        builder: (context) =>
                            OrderDetailScreen(order: orderMap),
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

  Widget _buildInfoRow(
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
          color: valueColor ??
              (isBold
                  ? (isDark ? Colors.white : Colors.black)
                  : (isDark ? Colors.white70 : Colors.black87)),
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
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
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
