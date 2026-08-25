import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';

import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/manager/profile_manager.dart';

import 'package:shopping_app/src/screen/home_screen/order/order_confirm_screen.dart';
import 'package:shopping_app/src/model/gift_card_model.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../network/datastor/membership_service.dart';
import '../../../model/order_model.dart';

class ShoppingBagScreen extends StatefulWidget {
  const ShoppingBagScreen({super.key});

  @override
  State<ShoppingBagScreen> createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  final TextEditingController _claimCodeController = TextEditingController();

  double _appliedDiscount = 0.0;
  String? _appliedCode;

  bool _isSummaryExpanded = false;

  List<Map<String, dynamic>> get _cartItems => CartManager().cartItems;

  List<Map<String, dynamic>> get _selectedItems {
    return _cartItems.where((item) => item['isSelected'] == true).toList();
  }

  double get _selectedSubtotal {
    double subtotal = 0.0;

    for (final item in _selectedItems) {
      final price = _parsePrice(item['price']);

      final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

      subtotal += price * quantity;
    }

    return subtotal;
  }

  double get _deliveryFee {
    return _selectedSubtotal > 0 ? 2.00 : 0.0;
  }

  double get _effectiveAppliedDiscount {
    if (_appliedDiscount <= 0) return 0.0;
    return _appliedDiscount > _selectedSubtotal
        ? _selectedSubtotal
        : _appliedDiscount;
  }


  double _calculateMembershipDiscount(MemberLevel level) {
    return _selectedSubtotal * level.discountPercentage;
  }

  double _calculateAutomaticDiscount() {
    if (_selectedSubtotal >= 16000.0) {
      return _selectedSubtotal * 0.10;
    }
    return 0.0;
  }

  double _totalAmount(MemberLevel level) {
    double calculated =
        _selectedSubtotal +
            _deliveryFee -
            _effectiveAppliedDiscount -
            _calculateAutomaticDiscount() -
            _calculateMembershipDiscount(level);
    return calculated.clamp(0.01, double.infinity);
  }

  double _originalUnitPrice(double unitPrice, double discountRate) {
    if (discountRate > 0 && discountRate < 1) {
      return unitPrice / (1 - discountRate);
    }
    return unitPrice * 1.25;
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _cartItems.length) {
      return;
    }

    CartManager().removeFromCart(index);
    if (_selectedSubtotal <= 0 && _appliedDiscount > 0) {
      setState(() {
        _appliedDiscount = 0.0;
        _appliedCode = null;
        _claimCodeController.clear();
      });
    }
  }

  void _updateItem(int index, Map<String, dynamic> updated) {
    if (index < 0 || index >= _cartItems.length) {
      return;
    }

    CartManager().updateItem(index, updated);
  }

  @override
  void dispose() {
    _claimCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkMode : AppColor.white;
    final textColor = isDark ? AppColor.white : AppColor.black;
    return ListenableBuilder(
      listenable: CartManager(),
      builder: (context, _) {
        return StreamBuilder<List<OrderModel>>(
          stream: MembershipService.getOrdersStream(),
          builder: (context, snapshot) {
            final orders = snapshot.data ?? [];
            final totalSpent = MembershipService.calculateTotalSpent(orders);
            final level = MembershipService.getLevel(totalSpent);
            final discountPercent = level.discountPercentage;
            _totalAmount(level);
            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: BackButton(color: textColor),
                title: TextWidget(
                  "${"My shopping bag".tr} "
                      "(${_cartItems.length})",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),

                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border, color: textColor),
                  ),
                ],
              ),

              body: _cartItems.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildCartList(isDark, discountPercent),
              bottomNavigationBar: _cartItems.isEmpty
                  ? null
                  : _buildCheckoutBar(isDark, level),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/bag_card.json',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            TextWidget(
              "Your bag is empty".tr,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),

            const SizedBox(height: 12),

            TextWidget(
              "Looks like you haven't added anything "
                  "to your bag yet."
                  .tr,
              textAlign: TextAlign.center,
              color: Colors.grey,
              fontSize: 16,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  "Start Shopping".tr,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(bool isDark, double discountPercent) {
    final textColor = isDark ? Colors.white : Colors.black;

    final secondaryTextColor = isDark ? Colors.white70 : Colors.black87;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: CartManager().isAllSelected,

                    onChanged: (value) {
                      CartManager().selectAll(value ?? false);
                    },

                    activeColor: AppColor.primaryColor,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                TextWidget(
                  "Select All".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),

                const Spacer(),

                if (_selectedItems.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      CartManager().removeSelected();
                    },
                    child: TextWidget(
                      "Remove Selected".tr,
                      fontSize: 14,
                      color: AppColor.errorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          const Divider(),

          ...List.generate(_cartItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildCartItem(
                index,
                isDark,
                discountPercent,
                textColor,
                secondaryTextColor,
              ),
            );
          }),
          _buildClaimCodeSection(isDark),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      int index,
      bool isDark,
      double discountPercent,
      Color textColor,
      Color secondaryTextColor,
      ) {
    final item = _cartItems[index];

    final bool isSelected = item['isSelected'] ?? true;

    final int quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

    final double unitPrice = _parsePrice(item['price']);

    final double discountRate = discountPercent > 1
        ? discountPercent / 100
        : discountPercent;

    // FIX #1: use the shared helper so this matches _calculateTotalOriginal.
    final double originalUnitPrice = _originalUnitPrice(unitPrice, discountRate);

    final double lineOriginal = originalUnitPrice * quantity;

    final double lineTotal = unitPrice * quantity;

    final double lineDiscount = (lineOriginal - lineTotal).clamp(
      0.0,
      double.infinity,
    );

    final double selectedSubtotal = _selectedSubtotal;

    // FIX #2: use the clamped effective discount so a per-item voucher
    // share is never computed from a stale/oversized applied amount.
    final double effectiveAppliedDiscount = _effectiveAppliedDiscount;

    double itemVoucherShare = 0.0;

    if (effectiveAppliedDiscount > 0 && isSelected && selectedSubtotal > 0) {
      itemVoucherShare =
          effectiveAppliedDiscount * (lineTotal / selectedSubtotal);
      itemVoucherShare = itemVoucherShare.clamp(0.0, lineTotal);
    }

    final double lineFinal = (lineTotal - itemVoucherShare).clamp(
      0.0,
      double.infinity,
    );

    final int displayDiscountPercent = discountRate > 0
        ? (discountRate * 100).round()
        : 20;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,

                  onChanged: (_) {
                    CartManager().toggleSelection(index);
                  },

                  activeColor: AppColor.primaryColor,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _getImage(item).isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: _getImage(item),
                width: 100,
                height: 130,
                fit: BoxFit.cover,

                placeholder: (context, url) {
                  return Container(
                    width: 100,
                    height: 130,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },

                errorWidget: (context, url, error) {
                  return Container(
                    width: 100,
                    height: 130,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: const Icon(Icons.broken_image),
                  );
                },
              )
                  : Container(
                width: 100,
                height: 130,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wb_sunny,
                              color: Colors.orange,
                              size: 12,
                            ),

                            const SizedBox(width: 4),

                            TextWidget(
                              "New In".tr,
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          _removeItem(index);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  TextWidget(
                    (item['title'] ?? 'Product').toString().tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: textColor,
                  ),

                  const SizedBox(height: 4),

                  // Minor fix: run the "Code." label through .tr so it
                  // localizes along with the rest of the row.
                  TextWidget(
                    "${"Code.".tr} "
                        "${item['id'] ?? '11226041893'}"
                        " - "
                        "${item['selectedColor'] ?? 'Brown'}",
                    fontSize: 12,
                    color: secondaryTextColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SIZE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            "Size".tr,
                            fontSize: 12,
                            color: Colors.grey,
                          ),

                          const SizedBox(height: 4),

                          _buildSelectionBox(
                            item['selectedSize']?.toString() ?? 'L',
                                () => _showSizePicker(index, item),
                            isDark,
                          ),
                        ],
                      ),

                      const SizedBox(width: 10),

                      // QUANTITY
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextWidget(
                            "Quantity".tr,
                            fontSize: 12,
                            color: Colors.grey,
                          ),

                          const SizedBox(height: 4),

                          _buildSelectionBox(
                            quantity.toString(),
                                () => _showQuantityPicker(index, item),
                            isDark,
                          ),
                        ],
                      ),

                      const SizedBox(width: 8),

                      // PRICE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "\$${lineOriginal.toStringAsFixed(2)}",
                              fontSize: 13,
                              color: secondaryTextColor,
                              textAlign: TextAlign.right,
                              textDecoration: TextDecoration.lineThrough,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            TextWidget(
                              "($displayDiscountPercent% off) "
                                  "-\$${lineDiscount.toStringAsFixed(2)}",
                              fontSize: 11,
                              color: secondaryTextColor,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (itemVoucherShare > 0)
                              TextWidget(
                                "${"Voucher Discount".tr} "
                                    "-\$${itemVoucherShare.toStringAsFixed(2)}",
                                fontSize: 11,
                                color: secondaryTextColor,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                            const SizedBox(height: 2),

                            TextWidget(
                              "\$${lineFinal.toStringAsFixed(2)}",
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColor.errorRed,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            WishlistManager().addToWishlist(item);
            _removeItem(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    TextWidget("Moved to wishlist".tr, color: Colors.white),
                backgroundColor: AppColor.successGreen,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Icon(Icons.favorite_border, size: 20, color: textColor),

              const SizedBox(width: 8),

              TextWidget(
                "Move to wishlist".tr,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1),
        ),
      ],
    );
  }

  Widget _buildSelectionBox(String text, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),

            const SizedBox(width: 5),

            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  void _showSizePicker(int index, Map<String, dynamic> item) {
    final sizes = _extractSizes(item);
    final currentSize = item['selectedSize']?.toString() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColor.darkMode : AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                _buildSheetHandle(isDark),
                const SizedBox(height: 12),
                TextWidget(
                  "Select size".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const Divider(),
                Expanded(
                  child: sizes.isEmpty
                      ? Center(
                    child: TextWidget(
                      "No sizes available".tr,
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  )
                      : ListView.builder(
                    controller: scrollController,
                    itemCount: sizes.length,
                    itemBuilder: (context, sizeIndex) {
                      final size = sizes[sizeIndex];

                      return ListTile(
                        title: TextWidget(
                          size,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        trailing: currentSize == size
                            ? Icon(
                          Icons.check,
                          color: isDark ? Colors.white : Colors.black,
                        )
                            : null,
                        onTap: () {
                          final updated = Map<String, dynamic>.from(item);
                          updated['selectedSize'] = size;
                          _updateItem(index, updated);
                          Navigator.pop(sheetContext);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  List<String> _extractSizes(Map<String, dynamic> item) {
    final dynamic rawSizes = item['sizes'] ?? item['availableSizes'] ?? item['size'];

    if (rawSizes is List) {
      return rawSizes.map((e) => e.toString()).toList();
    } else if (rawSizes is String && rawSizes.isNotEmpty) {
      return rawSizes.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return const [];
  }

  void _showQuantityPicker(int index, Map<String, dynamic> item) {
    final currentQty = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

    final int maxQty = currentQty > 10 ? currentQty : 10;
    final quantities = List.generate(maxQty, (i) => i + 1);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColor.darkMode : AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),

                _buildSheetHandle(isDark),

                const SizedBox(height: 12),

                TextWidget(
                  "Select quantity".tr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),

                const Divider(),

                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: quantities.length,
                    itemBuilder: (context, quantityIndex) {
                      final qty = quantities[quantityIndex];

                      return ListTile(
                        title: TextWidget(
                          qty.toString(),
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),

                        trailing: currentQty == qty
                            ? Icon(
                          Icons.check,
                          color: isDark ? Colors.white : Colors.black,
                        )
                            : null,

                        onTap: () {
                          final updated = Map<String, dynamic>.from(item);

                          updated['quantity'] = qty;

                          _updateItem(index, updated);

                          Navigator.pop(sheetContext);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSheetHandle(bool isDark) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  void _showVoucherPicker() {
    final profile = ProfileManager();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String userIdentifier = "USER";
    if (profile.name.isNotEmpty) {
      userIdentifier = profile.name.split(' ').first.toUpperCase();
    }
    userIdentifier = userIdentifier.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (userIdentifier.isEmpty) {
      userIdentifier = "USER";
    }
    final vouchers = GiftCardModel.getSampleData(
      userIdentifier,
    ).where((v) => v.isActive).toList();
    if (profile.dateOfBirth.isNotEmpty) {
      try {
        final parts = profile.dateOfBirth.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final now = DateTime.now();
          if (now.day == day && now.month == month) {
            vouchers.insert(
              0,
              GiftCardModel.birthdayVoucher(
                userIdentifier,
                userName: profile.name,
              ),
            );
          }
        }
      } catch (_) {}
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColor.darkMode : AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                _buildSheetHandle(isDark),
                const SizedBox(height: 20),
                TextWidget(
                  "My Vouchers".tr,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),

                const SizedBox(height: 12),

                const Divider(),

                Expanded(
                  child: vouchers.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.confirmation_number_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),

                        const SizedBox(height: 16),

                        TextWidget(
                          "No active vouchers found".tr,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: vouchers.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final card = vouchers[index];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _claimCodeController.text = card.claimCode;
                          });

                          Navigator.pop(sheetContext);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColor.darkMode
                                : Colors.white,

                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                            ),

                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      card.title,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),

                                    const SizedBox(height: 4),

                                    TextWidget(
                                      "Valid from:".tr,
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),

                                    TextWidget(
                                      "${_formatDate(card.validFrom)} - "
                                          "${_formatDate(card.validUntil)}",
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),

                                    const SizedBox(height: 4),

                                    TextWidget(
                                      card.description,
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  TextWidget(
                                    "\$${card.amount.toInt()}",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),

                                  const SizedBox(height: 6),

                                  TextWidget(
                                    "Claim code:".tr,
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),

                                  TextWidget(
                                    card.claimCode,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CLAIM CODE SECTION
  // ============================================================

  Widget _buildClaimCodeSection(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Claim code".tr,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _claimCodeController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: "Claim code".tr,
                    hintStyle: const TextStyle(color: Colors.grey),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),

                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _applyClaimCode,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: TextWidget(
                    "Apply".tr,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: _showVoucherPicker,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // FIX #3: draw the underline as a bottom border on the
                // actual content instead of a separately-sized fixed-width
                // Container. This way the line always matches the real
                // rendered width of the icon + label, regardless of
                // translation length via .tr.
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.lightBlueAccent
                            : const Color(0xFF003D66),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.confirmation_num_outlined,
                        size: 20,
                        color: isDark
                            ? Colors.lightBlueAccent
                            : const Color(0xFF003D66),
                      ),

                      const SizedBox(width: 8),

                      TextWidget(
                        "FREE VOUCHER".tr,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.lightBlueAccent
                            : const Color(0xFF003D66),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyClaimCode() {
    final code = _claimCodeController.text.trim();

    if (code.isEmpty) {
      return;
    }

    if (_selectedSubtotal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Please select at least one item.".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_appliedCode == code) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Code already applied!".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final profile = ProfileManager();

    String userIdentifier = "USER";

    if (profile.name.isNotEmpty) {
      userIdentifier = profile.name
          .split(' ')
          .first
          .toUpperCase()
          .replaceAll(RegExp(r'[^A-Z0-9]'), '');
    }

    if (userIdentifier.isEmpty) {
      userIdentifier = "USER";
    }

    final vouchers = GiftCardModel.getSampleData(userIdentifier);

    GiftCardModel? foundVoucher;

    try {
      foundVoucher = vouchers.firstWhere(
            (v) => v.claimCode == code && v.isActive,
      );
    } catch (_) {
      if (profile.dateOfBirth.isNotEmpty) {
        final birthdayVoucher = GiftCardModel.birthdayVoucher(
          userIdentifier,
          userName: profile.name,
        );

        if (birthdayVoucher.claimCode == code) {
          foundVoucher = birthdayVoucher;
        }
      }
    }

    if (foundVoucher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Invalid or inactive claim code.".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final discount = foundVoucher.amount > _selectedSubtotal
        ? _selectedSubtotal
        : foundVoucher.amount;

    setState(() {
      _appliedDiscount = discount;
      _appliedCode = foundVoucher!.claimCode;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          "Discount of \$${discount.toStringAsFixed(2)} applied!".tr,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCheckoutBar(bool isDark, MemberLevel level) {
    final selectedItems = _selectedItems;
    final hasSelection = selectedItems.isNotEmpty;
    final textColor = isDark ? Colors.white : Colors.black;

    final discountPercent = level.discountPercentage;

    final double totalOriginal = _calculateTotalOriginal(selectedItems, discountPercent);

    final double totalDiscount = (totalOriginal - _selectedSubtotal).clamp(0.0, double.infinity);
    final double effectiveAppliedDiscount = _effectiveAppliedDiscount;

    final double membershipDiscount = _calculateMembershipDiscount(level);
    final double autoDiscount = _calculateAutomaticDiscount();
    final double totalToPay = _totalAmount(level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
            if (_isSummaryExpanded) ...[
              GestureDetector(
                onTap: () => setState(() => _isSummaryExpanded = false),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  child: Icon(Icons.keyboard_arrow_down, color: textColor),
                ),
              ),
              const SizedBox(height: 16),
              _summaryRow(
                "Total",
                "\$${totalOriginal.toStringAsFixed(2)}",
                false,
                isDark,
              ),
              const SizedBox(height: 12),
              _summaryRow(
                "Save",
                "-\$${totalDiscount.toStringAsFixed(2)}",
                false,
                isDark,
              ),
              if (effectiveAppliedDiscount > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Voucher Discount",
                  "-\$${effectiveAppliedDiscount.toStringAsFixed(2)}",
                  false,
                  isDark,
                ),
              ],
              if (membershipDiscount > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Membership Discount",
                  "-\$${membershipDiscount.toStringAsFixed(2)}",
                  false,
                  isDark,
                ),
              ],
              if (autoDiscount > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Auto Discount",
                  "-\$${autoDiscount.toStringAsFixed(2)}",
                  false,
                  isDark,
                ),
              ],
              if (_deliveryFee > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Delivery Fee",
                  "\$${_deliveryFee.toStringAsFixed(2)}",
                  false,
                  isDark,
                ),
              ],
              const SizedBox(height: 12),
              _summaryRow(
                "Amount to pay",
                "\$${totalToPay.toStringAsFixed(2)}",
                true,
                isDark,
              ),
            ] else ...[
              GestureDetector(
                onTap: () => setState(() => _isSummaryExpanded = true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextWidget(
                        "${"Amount to pay".tr} \$${totalToPay.toStringAsFixed(2)}",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_up, color: textColor),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection && _selectedSubtotal > 0
                    ? () => _goToCheckout(level)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  disabledBackgroundColor: isDark ? Colors.grey[800] : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  "Proceed to Checkout".tr,
                  color: (hasSelection && _selectedSubtotal > 0)
                      ? (isDark ? Colors.black : Colors.white)
                      : Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  double _calculateTotalOriginal(List<Map<String, dynamic>> items, double discountPercent) {
    double total = 0.0;
    final rate = discountPercent > 1 ? discountPercent / 100.0 : discountPercent;

    for (final item in items) {
      final unitPrice = _parsePrice(item['price']);
      final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

      // FIX #1: use the same helper as the per-item row so "Save" in the
      // summary always matches the sum of each item's crossed-out discount.
      final originalUnitPrice = _originalUnitPrice(unitPrice, rate);

      total += originalUnitPrice * quantity;
    }
    return total;
  }

  void _goToCheckout(MemberLevel level) {
    final selectedItems = _selectedItems;

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Please select at least one item.".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmScreen(
          items: selectedItems,
          appliedDiscount: _effectiveAppliedDiscount,
          appliedCode: _appliedCode,
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isTotal, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          label.tr,
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),

        TextWidget(
          value,
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),
      ],
    );
  }

  String _getImage(Map<String, dynamic> item) {
    if (item['images'] != null &&
        item['images'] is List &&
        (item['images'] as List).isNotEmpty) {
      return (item['images'] as List).first.toString();
    }

    return item['image']?.toString() ?? '';
  }

  double _parsePrice(dynamic price) {
    if (price == null) {
      return 0.0;
    }

    if (price is num) {
      return price.toDouble();
    }

    final value = price.toString().replaceAll(RegExp(r'[^\d.]'), '');

    return double.tryParse(value) ?? 0.0;
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }
}