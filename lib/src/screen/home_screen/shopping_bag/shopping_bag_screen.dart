import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/navigator_extension.dart';
import 'package:shopping_app/constants/string_extension.dart';

import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/manager/profile_manager.dart';

import 'package:shopping_app/src/screen/home_screen/order/order_confirm_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
import 'package:shopping_app/src/model/gift_card_model.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../network/datastor/membership_service.dart';
import '../../../model/order_model.dart';
import 'bloc/bag_bloc.dart';

class ShoppingBagScreen extends StatefulWidget {
  const ShoppingBagScreen({super.key});

  @override
  State<ShoppingBagScreen> createState() => _ShoppingBagScreenState();
}

class _ShoppingBagScreenState extends State<ShoppingBagScreen> {
  final TextEditingController _claimCodeController = TextEditingController();

  double _appliedDiscount = 0.0;
  String? _appliedCode;

  int _pointsToRedeem = 0;
  List<OrderModel> _orders = [];

  bool _isSummaryExpanded = false;

  double _deliveryFee(double subtotal) {
    return subtotal > 0 ? 2.00 : 0.0;
  }

  double _effectiveAppliedDiscount(double subtotal) {
    if (_appliedDiscount <= 0) return 0.0;
    return _appliedDiscount > subtotal ? subtotal : _appliedDiscount;
  }

  double _calculateMembershipDiscount(double subtotal, MemberLevel level) {
    return subtotal * level.discountPercentage;
  }

  int get _availablePoints {
    return MembershipService.calculateAvailablePoints(_orders);
  }

  int _maxPointsBySubtotal(double subtotal) {
    final double sharedMaxDiscount = subtotal * 0.9;
    final double voucherDiscount = _effectiveAppliedDiscount(subtotal);
    final double remainingDiscountLimit = (sharedMaxDiscount - voucherDiscount)
        .clamp(0.0, double.infinity);
    return (remainingDiscountLimit / 0.15).floor();
  }

  int _effectiveMaxPoints(double subtotal) {
    final int byBalance = _availablePoints;
    final int byLimit = _maxPointsBySubtotal(subtotal);
    return byBalance < byLimit ? byBalance : byLimit;
  }

  double _calculatePointsDiscount(double subtotal) {
    final maxPts = _effectiveMaxPoints(subtotal);
    final points = _pointsToRedeem > maxPts ? maxPts : _pointsToRedeem;
    return points * 0.15;
  }

  double _totalAmount(double subtotal, MemberLevel level) {
    double calculated =
        subtotal +
        _deliveryFee(subtotal) -
        _effectiveAppliedDiscount(subtotal) -
        _calculateMembershipDiscount(subtotal, level) -
        _calculatePointsDiscount(subtotal);
    return calculated.clamp(0.01, double.infinity);
  }

  double _parseDiscount(dynamic discount) {
    if (discount == null) return 0.0;
    if (discount is num) return discount.toDouble();
    final String d = discount.toString();
    if (d.contains('%')) {
      return (double.tryParse(d.replaceAll('%', '')) ?? 0.0) / 100.0;
    }
    return double.tryParse(d) ?? 0.0;
  }

  double _originalUnitPrice(double unitPrice, double discountRate) {
    if (discountRate > 0 && discountRate < 1) {
      return unitPrice / (1 - discountRate);
    }
    return unitPrice;
  }

  void _removeItem(BuildContext context, int index, double subtotal) {
    context.read<BagBloc>().add(BagItemRemoved(index));
    if (subtotal <= 0) {
      setState(() {
        _appliedDiscount = 0.0;
        _appliedCode = null;
        _pointsToRedeem = 0;
        _claimCodeController.clear();
      });
    }
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

    return BlocProvider(
      create: (context) => BagBloc()..add(BagStarted()),
      child: BlocBuilder<BagBloc, BagState>(
        builder: (context, state) {
          final items = state is BagLoaded
              ? state.items
              : <Map<String, dynamic>>[];
          final subtotal = state is BagLoaded ? state.subtotal : 0.0;

          return StreamBuilder<List<OrderModel>>(
            stream: MembershipService.getOrdersStream(),
            builder: (context, snapshot) {
              final orders = snapshot.data ?? [];
              _orders = orders;
              final totalSpent = MembershipService.calculateTotalSpent(orders);
              final level = MembershipService.getLevel(totalSpent);
              final discountPercent = level.discountPercentage;

              return Scaffold(
                backgroundColor: bgColor,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  centerTitle: true,
                  leading: BackButton(color: textColor),
                  title: TextWidget(
                    "${"My shopping bag".tr} (${items.length})",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.favorite_border, color: textColor),
                    ),
                  ],
                ),
                body: items.isEmpty
                    ? _buildEmptyState(isDark)
                    : _buildCartList(
                        context,
                        items,
                        subtotal,
                        isDark,
                        discountPercent,
                      ),
                bottomNavigationBar: items.isEmpty
                    ? null
                    : _buildCheckoutBar(
                        context,
                        items,
                        subtotal,
                        isDark,
                        level,
                      ),
              );
            },
          );
        },
      ),
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

  Widget _buildCartList(
    BuildContext context,
    List<Map<String, dynamic>> items,
    double subtotal,
    bool isDark,
    double discountPercent,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black87;
    final selectedItems = items
        .where((item) => item['isSelected'] == true)
        .toList();
    final isAllSelected =
        items.isNotEmpty && items.every((item) => item['isSelected'] == true);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isAllSelected,
                    onChanged: (value) {
                      context.read<BagBloc>().add(
                        BagAllSelected(value ?? false),
                      );
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
                if (selectedItems.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      context.read<BagBloc>().add(BagSelectedRemoved());
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
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildCartItem(
                context,
                index,
                items,
                subtotal,
                isDark,
                discountPercent,
                textColor,
                secondaryTextColor,
              ),
            );
          }),
          const SizedBox(height: 10),
          _buildPointsRedemptionSection(context, subtotal, isDark),
          const SizedBox(height: 24),
          _buildClaimCodeSection(context, subtotal, isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    int index,
    List<Map<String, dynamic>> items,
    double selectedSubtotal,
    bool isDark,
    double discountPercent,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final item = items[index];
    final bool isSelected = item['isSelected'] ?? true;
    final int quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
    final double unitPrice = _parsePrice(item['price']);
    final double productDiscountRate = _parseDiscount(item['discount']);
    final double originalUnitPrice = _originalUnitPrice(
      unitPrice,
      productDiscountRate,
    );
    final double lineOriginal = originalUnitPrice * quantity;
    final double lineTotal = unitPrice * quantity;
    final double lineDiscount = (lineOriginal - lineTotal).clamp(
      0.0,
      double.infinity,
    );
    final int displayDiscountPercent = (productDiscountRate * 100).round();

    final double effectiveAppliedDiscount = _effectiveAppliedDiscount(
      selectedSubtotal,
    );
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
                    context.read<BagBloc>().add(BagSelectionToggled(index));
                  },
                  activeColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Go.to(ProductDetailScreen(product: item)),
              child: ClipRRect(
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => Go.to(ProductDetailScreen(product: item)),
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
                            _removeItem(context, index, selectedSubtotal);
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
                    TextWidget(
                      "${"Code.".tr} ${item['id'] ?? '11226041893'} - ${item['selectedColor'] ?? 'Brown'}",
                      fontSize: 12,
                      color: secondaryTextColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              () => _showSizePicker(context, index, item),
                              isDark,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
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
                              () => _showQuantityPicker(context, index, item),
                              isDark,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (productDiscountRate > 0) ...[
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
                                  "($displayDiscountPercent% off) -\$${lineDiscount.toStringAsFixed(2)}",
                                  fontSize: 11,
                                  color: secondaryTextColor,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (itemVoucherShare > 0)
                                TextWidget(
                                  "${"Voucher Discount".tr} -\$${itemVoucherShare.toStringAsFixed(2)}",
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
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            WishlistManager().addToWishlist(item);
            _removeItem(context, index, selectedSubtotal);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget(
                  "Moved to wishlist".tr,
                  color: Colors.white,
                ),
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

  Widget _buildPointsRedemptionSection(
    BuildContext context,
    double subtotal,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.white : Colors.black;
    final double pointsDiscount = _calculatePointsDiscount(subtotal);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Point Redemption".tr,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _showPointsBottomSheet(context, subtotal, isDark),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF4F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: Color(0xFF0F3959),
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          "Use points".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        const SizedBox(height: 2),
                        TextWidget(
                          "$_pointsToRedeem points ≈ \$${pointsDiscount.toStringAsFixed(2)}",
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPointsBottomSheet(
    BuildContext context,
    double subtotal,
    bool isDark,
  ) {
    final availablePoints = _availablePoints;
    final int effectiveMaxPoints = _effectiveMaxPoints(subtotal);
    int tempPoints = _pointsToRedeem;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColor.darkMode : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final double valueDollar = tempPoints * 0.15;
            final double totalBalanceDollar = availablePoints * 0.15;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextWidget(
                      "LOOMA rewards".tr,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(height: 24),
                    TextWidget(
                      "$tempPoints PTS ≈ \$${valueDollar.toStringAsFixed(2)}",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF06292),
                    ),
                    const SizedBox(height: 6),
                    TextWidget(
                      "Available points / Exchangeable".tr,
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 6),
                    TextWidget(
                      "Total Balance: $availablePoints PTS (\$${totalBalanceDollar.toStringAsFixed(2)})",
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 24),
                    if (effectiveMaxPoints > 0) ...[
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFFF06292),
                          inactiveTrackColor: const Color(
                            0xFFF06292,
                          ).withValues(alpha: 0.2),
                          thumbColor: const Color(0xFFF06292),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: tempPoints.toDouble().clamp(
                            0,
                            effectiveMaxPoints.toDouble(),
                          ),
                          min: 0,
                          max: effectiveMaxPoints.toDouble(),
                          divisions: effectiveMaxPoints,
                          onChanged: (val) {
                            setSheetState(() {
                              tempPoints = val.toInt();
                            });
                          },
                        ),
                      ),
                      TextWidget(
                        "* Can cover up to 90% of item total ($effectiveMaxPoints PTS max)"
                            .tr,
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextWidget(
                          availablePoints <= 0
                              ? "You don't have available points to redeem.".tr
                              : "Limit reached or item total is 0.".tr,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _pointsToRedeem = tempPoints;
                          });
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: TextWidget(
                          "Confirm".tr,
                          color: isDark ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClaimCodeSection(
    BuildContext context,
    double subtotal,
    bool isDark,
  ) {
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
                  onPressed: () => _applyClaimCode(context, subtotal),
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
            onTap: () => _showVoucherPicker(context),
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
    );
  }

  void _applyClaimCode(BuildContext context, double subtotal) {
    final code = _claimCodeController.text.trim();

    if (code.isEmpty) return;

    if (subtotal <= 0) {
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
    } catch (_)
    {
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

    final discount = foundVoucher.amount > subtotal
        ? subtotal
        : foundVoucher.amount;

    setState(() {
      _appliedDiscount = discount;
      _appliedCode = foundVoucher!.claimCode;
      final maxPts = _effectiveMaxPoints(subtotal);
      if (_pointsToRedeem > maxPts) {
        _pointsToRedeem = maxPts;
      }
    });

    context.read<BagBloc>().add(BagVoucherApplied(code));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          "Discount of \$${discount.toStringAsFixed(2)} applied!".tr,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    List<Map<String, dynamic>> items,
    double subtotal,
    bool isDark,
    MemberLevel level,
  ) {
    final selectedItems = items
        .where((item) => item['isSelected'] == true)
        .toList();
    final hasSelection = selectedItems.isNotEmpty;
    final textColor = isDark ? Colors.white : Colors.black;

    final double totalOriginal = _calculateTotalOriginal(selectedItems);
    final double totalDiscount = (totalOriginal - subtotal).clamp(
      0.0,
      double.infinity,
    );
    final double effectiveAppliedDiscount = _effectiveAppliedDiscount(subtotal);
    final double pointsDiscount = _calculatePointsDiscount(subtotal);

    final double membershipDiscount = _calculateMembershipDiscount(
      subtotal,
      level,
    );
    final double totalToPay = _totalAmount(subtotal, level);

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
                "Product Discount",
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
              if (pointsDiscount > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Points Used",
                  "-\$${pointsDiscount.toStringAsFixed(2)}",
                  false,
                  isDark,
                ),
              ],
              if (_deliveryFee(subtotal) > 0) ...[
                const SizedBox(height: 12),
                _summaryRow(
                  "Delivery Fee",
                  "\$${_deliveryFee(subtotal).toStringAsFixed(2)}",
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
                onPressed: hasSelection && subtotal > 0
                    ? () => _goToCheckout(context, selectedItems, subtotal)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  disabledBackgroundColor: isDark
                      ? Colors.grey[800]
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  "Proceed to Checkout".tr,
                  color: (hasSelection && subtotal > 0)
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

  double _calculateTotalOriginal(List<Map<String, dynamic>> items) {
    double total = 0.0;
    for (final item in items) {
      final unitPrice = _parsePrice(item['price']);
      final quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
      final productDiscountRate = _parseDiscount(item['discount']);
      final originalUnitPrice = _originalUnitPrice(
        unitPrice,
        productDiscountRate,
      );
      total += originalUnitPrice * quantity;
    }
    return total;
  }

  void _goToCheckout(
    BuildContext context,
    List<Map<String, dynamic>> selectedItems,
    double subtotal,
  ) {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Please select at least one item.".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final int effectivePoints = _pointsToRedeem > _effectiveMaxPoints(subtotal)
        ? _effectiveMaxPoints(subtotal)
        : _pointsToRedeem;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderConfirmScreen(
          items: selectedItems,
          appliedDiscount: _effectiveAppliedDiscount(subtotal),
          appliedCode: _appliedCode,
          pointsRedeemed: effectivePoints,
        ),
      ),
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

  void _showSizePicker(
    BuildContext context,
    int index,
    Map<String, dynamic> item,
  ) {
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
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  : null,
                              onTap: () {
                                final updated = Map<String, dynamic>.from(item);
                                updated['selectedSize'] = size;
                                context.read<BagBloc>().add(
                                  BagItemUpdated(index, updated),
                                );
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
    final dynamic rawSizes =
        item['sizes'] ?? item['availableSizes'] ?? item['size'];
    List<String> sizes = [];
    if (rawSizes is List) {
      sizes = rawSizes.map((e) => e.toString()).toList();
    } else if (rawSizes is String && rawSizes.isNotEmpty) {
      sizes = rawSizes
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (sizes.isEmpty) {
      sizes = ['S', 'M', 'L', 'XL'];
    }
    final selected = item['selectedSize']?.toString();
    if (selected != null && selected.isNotEmpty && !sizes.contains(selected)) {
      sizes.add(selected);
    }
    return sizes;
  }

  void _showQuantityPicker(
    BuildContext context,
    int index,
    Map<String, dynamic> item,
  ) {
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
                          context.read<BagBloc>().add(
                            BagItemUpdated(index, updated),
                          );
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

  void _showVoucherPicker(BuildContext context) {
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
                                            "${_formatDate(card.validFrom)} - ${_formatDate(card.validUntil)}",
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
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    final value = price.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(value) ?? 0.0;
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

}
