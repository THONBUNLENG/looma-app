import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/constants/string_extension.dart';


import '../../../widget/text_widget.dart';

import '../notification_page.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, dynamic>> activeOrders = [
    {
      "id": "ORD-7732",
      "name": "Tambour Street Diver Burning Rock",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWk3ODZqYyZbb-CHDbmzE7En-1bcFgJBO8pg&s",
      "price": 7500.00,
      "status": "In Delivery",
      "items": 1,
      "date": "Oct 24, 2023",
    },
    {
      "id": "ORD-5521",
      "name": "Classic Silver Chronograph",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMtNTbmYEibQQkk2v--nTlZs8D0KZaAWrYCw&s",
      "price": 3200.00,
      "status": "Processing",
      "items": 2,
      "date": "Oct 22, 2023",
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      "id": "ORD-1204",
      "name": "Midnight Black Voyager",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOYyx4JXs1SL410TfqkqzPpgK25gNKIepdCw&s",
      "price": 1850.00,
      "status": "Completed",
      "items": 1,
      "date": "Oct 15, 2023",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF9F9F9),
          elevation: 0,
          centerTitle: true,
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: IconButton(
              splashRadius: 24,
              icon: ImageIcon(
                const AssetImage('assets/icon/notification.png'),
                color: isDark ? Colors.white : Colors.black,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),
          ),
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? const [Colors.white, Colors.white70]
                  : const [Colors.black, Colors.black54],
            ).createShader(bounds),
            child: TextWidget(
              'LOOMA',
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          actions: [const CartBadge()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : const Color(0xFFF1F1F1),
                  ),
                  child: TextWidget(
                    "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TabBar(
                  indicatorColor: isDark ? Colors.white : Colors.black,
                  labelColor: isDark ? Colors.white : Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: "Active".tr),
                    Tab(text: "Completed".tr),
                  ],
                ),
              ],
            ),
          ),
        ),
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color(0xFFF8F9FA),
        body: TabBarView(
          children: [
            _buildOrderList(activeOrders, isDark),
            _buildOrderList(completedOrders, isDark),
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
              "No orders yet".tr,
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, isDark);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, bool isDark) {
    bool isCompleted = order['status'] == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(order['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      order['name'].toString().tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                      "${order['items']} ${'Item'.tr}${order['items'] > 1 ? 's'.tr : ''}",
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "\$${order['price'].toStringAsFixed(2)}",
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextWidget(
                            order['status'].toString().tr,
                            color: isCompleted ? Colors.green : Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                    ),
                  ),
                  child: TextWidget(
                    (isCompleted ? "Leave Review" : "Track Order").tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: TextWidget(
                    (isCompleted ? "Re-order" : "Details").tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



