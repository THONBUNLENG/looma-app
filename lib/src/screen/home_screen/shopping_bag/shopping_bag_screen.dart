import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_confirm_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class ShoppingBagScreen extends StatefulWidget {
  const ShoppingBagScreen({super.key});

  @override
  State<ShoppingBagScreen> createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  List<Map<String, dynamic>> get _cartItems => CartManager().cartItems;

  double get _subtotal => CartManager().subtotal;
  double get _deliveryFee => _subtotal == 0 ? 0.0 : 2.00;
  double get _total => _subtotal + _deliveryFee;

  void _updateQuantity(int index, int delta) {
    setState(() {
      CartManager().updateQuantity(index, delta);
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      CartManager().toggleSelection(index);
    });
  }

  void _selectAll(bool? selected) {
    if (selected != null) {
      setState(() {
        CartManager().selectAll(selected);
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      CartManager().removeFromCart(index);
    });
  }

  void _clearCart() {
    setState(() {
      CartManager().clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "My Shopping Bag".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 24),
              onPressed: _clearCart,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _cartItems.isEmpty ? _buildEmptyState(isDark) : _buildCartList(isDark),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBar(isDark),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
            ),
            const SizedBox(height: 30),
            TextWidget(
              "Your bag is empty".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            TextWidget(
              "Looks like you haven't added anything to your bag yet.".tr,
              textAlign: TextAlign.center,
              color: Colors.grey,
              fontSize: 16,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: TextWidget("Start Shopping".tr, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(bool isDark) {
    final cartItemsList = _cartItems;
    return Column(
      children: [
        if (cartItemsList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: CartManager().isAllSelected,
                    onChanged: _selectAll,
                    activeColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(width: 12),
                TextWidget(
                  "Select All".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: cartItemsList.length,
            itemBuilder: (context, index) {
              final item = cartItemsList[index];
              final uniqueKey = item['id']?.toString() ?? item['title']?.toString() ?? index.toString();
              final isSelected = item['isSelected'] ?? true;

              return Dismissible(
                key: Key(uniqueKey),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 30),
                ),
                onDismissed: (_) => _removeItem(index),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (value) => _toggleSelection(index),
                        activeColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
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
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: _getImage(item).isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: _getImage(item),
                                      width: 90,
                                      height: 110,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                                      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                                    )
                                  : Container(
                                      width: 90,
                                      height: 110,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    item['title'] ?? 'Product',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  TextWidget(
                                    _getDetails(item),
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        "\$${_parsePrice(item['price']).toStringAsFixed(2)}",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryColor,
                                      ),
                                      _buildQuantityController(index, isDark),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getImage(Map<String, dynamic> item) {
    if (item['images'] != null && item['images'] is List && (item['images'] as List).isNotEmpty) {
      return item['images'][0].toString();
    }
    return item['image']?.toString() ?? '';
  }

  String _getDetails(Map<String, dynamic> item) {
    List<String> details = [];
    if (item['selectedSize'] != null) details.add("${'Size'.tr}: ${item['selectedSize']}");
    if (item['selectedColorIndex'] != null) details.add("${'Color'.tr}: ${item['selectedColorIndex']}");
    
    return details.isEmpty ? 'No details' : details.join('  |  ');
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    return double.tryParse(price.toString().replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }

  Widget _buildQuantityController(int index, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _quantityButton(Icons.remove, () => _updateQuantity(index, -1), isDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextWidget(
              _cartItems[index]['quantity'].toString(),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          _quantityButton(Icons.add, () => _updateQuantity(index, 1), isDark),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
              ),
          ],
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildCheckoutBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow("Subtotal".tr, "\$${_subtotal.toStringAsFixed(2)}", false),
            const SizedBox(height: 10),
            _summaryRow("Delivery Fee".tr, "\$${_deliveryFee.toStringAsFixed(2)}", false),
            const Divider(height: 30),
            _summaryRow("Total".tr, "\$${_total.toStringAsFixed(2)}", true),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _subtotal > 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmScreen(
                              items: _cartItems.where((e) => e['isSelected'] == true).toList(),
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _subtotal > 0 ? AppColor.pink100Color : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      "Order Now".tr,
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          label,
          fontSize: isTotal ? 18 : 14,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? null : Colors.grey,
        ),
        TextWidget(
          value,
          fontSize: isTotal ? 22 : 16,
          fontWeight: FontWeight.bold,
          color: isTotal ? AppColor.primaryColor : null,
        ),
      ],
    );
  }
}
