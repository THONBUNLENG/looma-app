import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/screen/home_screen/shopping_bag/checkout_payment_screen.dart';
import 'package:shopping_app/src/screen/setting/address/address_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class OrderConfirmScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const OrderConfirmScreen({super.key, required this.items});

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  final TextEditingController _promoController = TextEditingController();
  int _selectedDelivery = 0;
  int _selectedPayment = 0;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  double get _subtotal {
    double total = 0.0;
    for (var item in widget.items) {
      final price = _parsePrice(item['price']);
      final quantity = item['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  double get _deliveryFee => _selectedDelivery == 1 ? 1.0 : 0.0;

  double get _total => _subtotal + _deliveryFee;

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    return double.tryParse(
          price.toString().replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          "Order Confirm".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.pink100Color,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Receive Address", isDark),
            _buildAddressCard(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle("Delivery Methods", isDark),
            _buildDeliveryMethods(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle("Payment Methods", isDark),
            _buildPaymentMethods(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle("Promo Code", isDark),
            _buildPromoCodeSection(isDark),
            const SizedBox(height: 24),
            _buildSectionTitle("Item summary", isDark),
            _buildItemSummary(isDark),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(isDark),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextWidget(
        title.tr,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildAddressCard(bool isDark) {
    final profile = ProfileManager();
    final address = profile.defaultAddress;

    if (address == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              "Receive Address not found".tr,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressScreen()),
              ).then((_) => setState(() {})),
              icon: Icon(
                Icons.add_location_alt_outlined,
                color: AppColor.pink100Color,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(profile.name, fontWeight: FontWeight.bold),
                const SizedBox(height: 4),
                TextWidget(profile.phone, color: Colors.grey),
                const SizedBox(height: 4),
                TextWidget(
                  address['address'],
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressScreen()),
            ).then((_) => setState(() {})),
            icon: Icon(Icons.edit_note_rounded, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethods(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRadioOption(
            "Free delivery សម្រាប់ អតិថិជននៅភ្នំពេញ រាល់ការ បញ្ជាទិញចាប់ពី 10\$ ឡើងទៅ"
                .tr,
            0,
            _selectedDelivery,
            (v) => setState(() => _selectedDelivery = v!),
            isDark,
          ),
          _buildRadioOption(
            "គិតថ្លៃដឹក 1\$ សម្រាប់ការបញ្ជាទិញក្រោម 10\$".tr,
            1,
            _selectedDelivery,
            (v) => setState(() => _selectedDelivery = v!),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRadioOption(
            "Cash On Delivery".tr,
            0,
            _selectedPayment,
            (v) => setState(() => _selectedPayment = v!),
            isDark,
          ),
          _buildRadioOption(
            "Bank transfer".tr,
            1,
            _selectedPayment,
            (v) => setState(() => _selectedPayment = v!),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promoController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "Enter Promo Code".tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply promo code logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.pink100Color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: TextWidget(
              "Apply".tr,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    int value,
    int groupValue,
    ValueChanged<int?> onChanged,
    bool isDark,
  ) {
    return RadioListTile<int>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      title: TextWidget(
        title,
        fontSize: 14,
        color: isDark ? Colors.white : Colors.black87,
      ),
      activeColor: AppColor.pink100Color,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildItemSummary(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                color: isDark ? Colors.white10 : Colors.grey.shade100,
                height: 1,
              ),
            ),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              String imageUrl = '';
              if (item['image'] != null) {
                imageUrl = item['image'].toString();
              } else if (item['images'] is List &&
                  (item['images'] as List).isNotEmpty) {
                imageUrl = item['images'][0].toString();
              }

              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          (item['title'] ?? 'Product').toString().tr,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextWidget(
                                "Qty: ${item['quantity'] ?? 1}",
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextWidget(
                    "\$${_parsePrice(item['price']).toStringAsFixed(2)}",
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppColor.pink100Color,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
          const SizedBox(height: 16),
          _summaryRow("Item:", "${widget.items.length}", isDark),
          const SizedBox(height: 12),
          _summaryRow(
            "Subtotal Amount:",
            "${_subtotal.toStringAsFixed(2)} USD",
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey),
        TextWidget(value, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget("Total amount:".tr, fontSize: 12, color: Colors.grey),
              TextWidget(
                "${_total.toStringAsFixed(2)} USD",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            width: 180,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedPayment == 1) {
                  // Bank transfer selected
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPaymentScreen(),
                    ),
                  );
                } else {
                  // Cash On Delivery - placeholder action
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.pink100Color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: TextWidget(
                "Order Now".tr,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
