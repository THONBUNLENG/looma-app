import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/model/order_model.dart';
import 'package:shopping_app/src/model/payment_model.dart';
import 'package:shopping_app/src/screen/home_screen/order/bloc/order_bloc.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_success_screen.dart';
import 'package:shopping_app/src/screen/home_screen/payment/checkout_payment_screen.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../network/datastor/membership_service.dart';
import '../../../widget/show_dialog.dart';

import '../address/address_screen.dart';
import '../address/bloc/address_bloc.dart';
import '../address/edit_address.dart';
import '../address/new_address.dart';
import 'select_payment_screen.dart';

class OrderConfirmScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double appliedDiscount;
  final String? appliedCode;

  const OrderConfirmScreen({
    super.key,
    required this.items,
    this.appliedDiscount = 0.0,
    this.appliedCode,
  });

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen>
    with LoadingWidget {
  final TextEditingController _voucherController = TextEditingController();

  final TextEditingController _contactLineController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  int _selectedPayment = 0;

  double _discountAmount = 0.0;

  String? _appliedVoucherCode;

  int _pointsToRedeem = 0;

  int _contactMethod = 0;

  bool _isPriceExpanded = false;

  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _discountAmount = widget.appliedDiscount;
    _appliedVoucherCode = widget.appliedCode;
  }

  @override
  void dispose() {
    _voucherController.dispose();
    _contactLineController.dispose();
    _noteController.dispose();
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

  double get _deliveryFee {
    final profile = ProfileManager();
    final address = profile.defaultAddress;

    final String fullAddress = (address?['address'] ?? '')
        .toString()
        .toLowerCase();

    final bool isPhnomPenh = fullAddress.contains("phnom penh");

    if (isPhnomPenh) {
      return 0.0;
    }

    if (_subtotal >= 16000.0) {
      return 0.0;
    }
    return 2.00;
  }

  double get _automaticDiscount {
    if (_subtotal >= 16000.0) {
      return _subtotal * 0.10;
    }

    return 0.0;
  }

  double _calculateMembershipDiscount(MemberLevel level) {
    return _subtotal * level.discountPercentage;
  }

  int get _availablePoints {
    return MembershipService.calculateAvailablePoints(_orders);
  }

  int get _maxPointsBySubtotal {
    final double sharedMaxDiscount = _subtotal * 0.9;

    final double remainingDiscountLimit = (sharedMaxDiscount - _discountAmount)
        .clamp(0.0, double.infinity);

    return (remainingDiscountLimit / 0.15).floor();
  }

  int get _effectiveMaxPoints {
    final int byBalance = _availablePoints;
    final int byLimit = _maxPointsBySubtotal;
    return byBalance < byLimit ? byBalance : byLimit;
  }

  double _calculatePointsDiscount() {
    final points = _pointsToRedeem > _effectiveMaxPoints
        ? _effectiveMaxPoints
        : _pointsToRedeem;
    return points * 0.15;
  }

  double _totalAmount(MemberLevel level) {
    double calculated =
        _subtotal +
        _deliveryFee -
        _discountAmount -
        _automaticDiscount -
        _calculateMembershipDiscount(level) -
        _calculatePointsDiscount();
    return calculated.clamp(0.01, double.infinity);
  }

  double _parsePrice(dynamic price) {
    if (price == null) {
      return 0.0;
    }
    if (price is num) {
      return price.toDouble();
    }
    return double.tryParse(
          price.toString().replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderBloc()),
        BlocProvider(create: (context) => AddressBloc()..add(LoadAddresses())),
      ],
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            final order = state.order!;
            CartManager().clearCart();
            if (order.paymentMethod == 'Bank transfer') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPaymentScreen(
                    totalAmount: order.totalAmount,
                    orderId: order.id!,
                    paymentMethod: order.paymentMethod,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSuccessScreen(
                    orderId: order.id!,
                    totalAmount: order.totalAmount,
                    paymentMethod: order.paymentMethod,
                  ),
                ),
              );
            }
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget("Failed to place order: ${state.error}".tr),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },

        child: StreamBuilder<List<OrderModel>>(
          stream: MembershipService.getOrdersStream(),
          builder: (context, membershipSnapshot) {
            final orders = membershipSnapshot.data ?? [];
            _orders = orders;
            final totalSpent = MembershipService.calculateTotalSpent(orders);
            final level = MembershipService.getLevel(totalSpent);
            return BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final orderBloc = context.read<OrderBloc>();
                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: isDark
                          ? const Color(0xFF121212)
                          : const Color(0xFFF8F9FA),
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        leading: BackButton(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        title: TextWidget(
                          "Order Confirm".tr,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),

                      body: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              "My shopping bag (${widget.items.length})",
                              isDark,
                            ),
                            _buildShoppingBagSection(isDark),
                            const SizedBox(height: 24),
                            _buildSectionTitle(
                              "Delivery address",
                              isDark,
                              isRequired: true,
                            ),
                            BlocBuilder<AddressBloc, AddressState>(
                              builder: (context, addressState) {
                                if (addressState is AddressLoaded) {
                                  return _buildAddressSection(
                                    isDark,
                                    addressState.addresses,
                                  );
                                }
                                return _buildAddressCard(isDark);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildShippingMethod(isDark),
                            const SizedBox(height: 24),
                            _buildSectionTitle(
                              "Preferred contact line",
                              isDark,
                              isRequired: true,
                            ),
                            _buildContactLineSection(isDark),
                            const SizedBox(height: 24),
                            _buildSectionTitle("Payment", isDark),
                            _buildPaymentMethods(isDark),
                            const SizedBox(height: 24),
                            _buildSectionTitle("Redeem Points", isDark),
                            _buildPointsRedemptionSection(isDark, orders),
                            const SizedBox(height: 24),
                            _buildSectionTitle("Note", isDark),
                            _buildNoteSection(isDark),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                      bottomNavigationBar: _buildBottomBar(
                        isDark,
                        state,
                        level,
                        orderBloc,
                      ),
                    ),
                    if (state is OrderLoading)
                      Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: LoadingWidget.loadingCenterWidget(),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    bool isDark, {
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        children: [
          TextWidget(
            title.tr,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          if (isRequired)
            TextWidget(
              " *",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
        ],
      ),
    );
  }

  Widget _buildShoppingBagSection(bool isDark) {
    return SizedBox(
      height: 156,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          String imageUrl = '';
          if (item['image'] != null) {
            imageUrl = item['image'].toString();
          } else if (item['images'] is List &&
              (item['images'] as List).isNotEmpty) {
            imageUrl = item['images'][0].toString();
          }

          return SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
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

                const SizedBox(height: 4),
                Flexible(
                  child: TextWidget(
                    "${item['title'] ?? ''}",
                    fontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                Flexible(
                  child: TextWidget(
                    "Quantity ${item['quantity'] ?? 1} / \$${_parsePrice(item['price']).toStringAsFixed(2)}",
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(bool isDark) {
    final profile = ProfileManager();

    final address = profile.defaultAddress;

    if (address == null) {
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewAddressScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.add_location_alt_outlined, color: Colors.grey),
              const SizedBox(width: 12),
              TextWidget(
                "Add Delivery Address".tr,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  (address['title'] ?? profile.name).toString().toUpperCase(),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                TextWidget(
                  address['address'],
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(
    bool isDark,
    List<Map<String, dynamic>> addresses,
  ) {
    final profile = ProfileManager();
    final address = profile.defaultAddress ??
        (addresses.isNotEmpty ? addresses.first : null);
    return Column(
      children: [
        if (address != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        (address['label'] ?? address['title'] ?? profile.name)
                            .toString()
                            .toUpperCase(),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      TextWidget(
                        address['address'],
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildAddressActions(isDark, address, addresses),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSmallActionButton(
              icon: Icons.add,
              label: "Add",
              isDark: isDark,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewAddressScreen(),
                  ),
                );
                if (result != null &&
                    result is Map<String, dynamic> &&
                    mounted) {
                  context.read<AddressBloc>().add(AddAddress(result));
                }
              },
            ),
            _buildSmallActionButton(
              icon: Icons.list,
              label: "Show",
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressScreen(),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressActions(
    bool isDark,
    Map<String, dynamic> item,
    List<Map<String, dynamic>> addresses,
  ) {
    int resolveIndex() {
      final id = item['id'];
      if (id != null) {
        final byId = addresses.indexWhere((a) => a['id'] == id);
        if (byId != -1) return byId;
      }
      final byFields = addresses.indexWhere(
        (a) =>
            a['address'] == item['address'] &&
            (a['label'] ?? a['title']) == (item['label'] ?? item['title']),
      );
      return byFields;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 20,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          onPressed: () async {
            final index = resolveIndex();
            if (index == -1) return;
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAddressScreen(addressData: item),
              ),
            );
            if (result != null && mounted) {
              if (result == "deleted") {
                context.read<AddressBloc>().add(DeleteAddress(index));
              } else if (result is Map<String, dynamic>) {
                context.read<AddressBloc>().add(UpdateAddress(index, result));
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            size: 20,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            final index = resolveIndex();
            if (index == -1) return;
            final confirm = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => StatusDialog(
                title: "Delete Address".tr,
                message:
                    "${"Are you sure you want to delete".tr} '${item['label'] ?? item['title']}'?",
                btn1Text: "Cancel".tr,
                btn2Text: "Delete".tr,
                icon: Icons.delete_sweep_rounded,
                iconColor: AppColor.mutedRed,
                onBtn1Pressed: () => Navigator.of(dialogContext).pop(false),
                onBtn2Pressed: () => Navigator.of(dialogContext).pop(true),
              ),
            );
            if (confirm == true && mounted) {
              context.read<AddressBloc>().add(DeleteAddress(index));
            }
          },
        ),
      ],
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 4),
            TextWidget(
              label.tr,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethod(bool isDark) {
    final profile = ProfileManager();
    final address = profile.defaultAddress;
    final String fullAddress = (address?['address'] ?? '')
        .toString()
        .toLowerCase();
    final bool isPhnomPenh = fullAddress.contains('phnom penh');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: TextWidget(
                "LOOMA",
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Standard Shipping | \$${_deliveryFee.toStringAsFixed(2)}",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                TextWidget(
                  isPhnomPenh
                      ? "Free delivery in Phnom Penh".tr
                      : "Reliable delivery in 1 to 3 days.".tr,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ],
            ),
          ),
          TextWidget("More", color: Colors.grey, fontSize: 12),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildContactLineSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: _buildContactRadio(
                  0,
                  Icons.phone_outlined,
                  "Phone call",
                  isDark,
                ),
              ),
              Flexible(
                child: _buildContactRadio(
                  1,
                  FontAwesomeIcons.telegram,
                  "Telegram",
                  isDark,
                ),
              ),
              Flexible(
                child: _buildContactRadio(
                  2,
                  FontAwesomeIcons.whatsapp,
                  "WhatsApp",
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                TextWidget("+855", fontWeight: FontWeight.bold),
                const Icon(Icons.keyboard_arrow_down, size: 16),
                const VerticalDivider(width: 20, indent: 12, endIndent: 12),
                Expanded(
                  child: TextField(
                    controller: _contactLineController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter your contact line".tr,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRadio(
    int value,
    dynamic icon,
    String label,
    bool isDark,
  ) {
    final isSelected = _contactMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          _contactMethod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off,
              color: isSelected ? Colors.green : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon is IconData
                        ? Icon(
                            icon,
                            size: 14,
                            color: isDark ? Colors.white : Colors.black,
                          )
                        : FaIcon(
                            icon,
                            size: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: TextWidget(
                        label.tr,
                        fontSize: 11,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods(bool isDark) {
    final profile = ProfileManager();
    final address = profile.defaultAddress;
    final String fullAddress = (address?['address'] ?? '')
        .toString()
        .toLowerCase();
    final bool isPhnomPenh = fullAddress.contains('phnom penh');

    final method =
        kPaymentMethods[_selectedPayment < kPaymentMethods.length
            ? _selectedPayment
            : 0];
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectPaymentScreen(
              selectedIndex: _selectedPayment,
              isPhnomPenh: isPhnomPenh,
            ),
          ),
        );
        if (result != null && result is int) {
          setState(() {
            _selectedPayment = result;
          });
        }
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(method.icon),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    method.title.tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  TextWidget(
                    method.subtitle.tr,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: "Write something...".tr,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPointsRedemptionSection(bool isDark, List<OrderModel> orders) {
    final availablePoints = _availablePoints;
    final int effectiveMaxPoints = _effectiveMaxPoints;
    if (availablePoints <= 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextWidget(
          "You have 0 points available for redemption.".tr,
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  "${"Available:".tr} $availablePoints ${"Points".tr}",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextWidget(
                  "${"Limit:".tr} $effectiveMaxPoints ${"Points".tr} (90%)",
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColor.pink100Color,
                    inactiveTrackColor: AppColor.pink100Color.withValues(
                      alpha: 0.2,
                    ),
                    thumbColor: AppColor.pink100Color,
                    overlayColor: AppColor.pink100Color.withValues(alpha: 0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: _pointsToRedeem.toDouble().clamp(
                      0,
                      effectiveMaxPoints.toDouble(),
                    ),
                    min: 0,
                    max: effectiveMaxPoints.toDouble() > 0
                        ? effectiveMaxPoints.toDouble()
                        : 1,
                    divisions: effectiveMaxPoints > 0 ? effectiveMaxPoints : 1,
                    onChanged: effectiveMaxPoints > 0
                        ? (value) {
                            setState(() {
                              _pointsToRedeem = value.toInt();
                            });
                          }
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 50,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: TextWidget(
                    "${_pointsToRedeem > effectiveMaxPoints ? effectiveMaxPoints : _pointsToRedeem}",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColor.pink100Color,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: TextWidget(
                  "${"Points used:".tr} - \$${_calculatePointsDiscount().toStringAsFixed(2)}",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextWidget(
                  "${"Value:".tr} \$${(availablePoints * 0.15).toStringAsFixed(2)}",
                  color: Colors.green,
                  fontSize: 12,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextWidget(
            "* ${"Voucher code and points discount together can cover up to 90% of the item total price.".tr}",
            fontSize: 10,
            color: isDark ? Colors.white60 : Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey),
        TextWidget(value, fontWeight: FontWeight.bold, color: valueColor),
      ],
    );
  }

  Widget _buildBottomBar(
    bool isDark,
    OrderState state,
    MemberLevel level,
    OrderBloc orderBloc,
  ) {
    final double total = _totalAmount(level);
    final double savings =
        _discountAmount +
        _automaticDiscount +
        _calculateMembershipDiscount(level) +
        _calculatePointsDiscount();
    final textColor = isDark ? Colors.white : Colors.black;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isPriceExpanded = !_isPriceExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      "${"Amount to pay".tr} \$${total.toStringAsFixed(2)}",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    const SizedBox(width: 6),
                    // FIX #1: chevron direction was inverted. Collapsed state
                    // now shows "down" (tap to expand downward), expanded
                    // state shows "up" (tap to collapse) — matches standard
                    // expand/collapse convention.
                    Icon(
                      _isPriceExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: textColor,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _isPriceExpanded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                            height: 1,
                          ),
                          const SizedBox(height: 12),
                          _summaryRow(
                            "Total".tr,
                            "\$${_subtotal.toStringAsFixed(2)}",
                            isDark,
                          ),
                          const SizedBox(height: 10),
                          _summaryRow(
                            "Save".tr,
                            "-\$${savings.toStringAsFixed(2)}",
                            isDark,
                          ),
                          const SizedBox(height: 10),
                          if (_discountAmount > 0) ...[
                            _summaryRow(
                              "Voucher Discount".tr,
                              "-\$${_discountAmount.toStringAsFixed(2)}",
                              isDark,
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (_calculateMembershipDiscount(level) > 0) ...[
                            _summaryRow(
                              "Membership Discount".tr,
                              "-\$${_calculateMembershipDiscount(level).toStringAsFixed(2)}",
                              isDark,
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (_automaticDiscount > 0) ...[
                            _summaryRow(
                              "Auto Discount".tr,
                              "-\$${_automaticDiscount.toStringAsFixed(2)}",
                              isDark,
                            ),
                            const SizedBox(height: 10),
                          ],
                          if (_pointsToRedeem > 0) ...[
                            _summaryRow(
                              "Points Used".tr,
                              "-\$${_calculatePointsDiscount().toStringAsFixed(2)}",
                              isDark,
                            ),
                            const SizedBox(height: 10),
                          ],
                          _summaryRow(
                            "Delivery Fee".tr,
                            "\$${_deliveryFee.toStringAsFixed(2)}",
                            isDark,
                          ),
                          const SizedBox(height: 12),
                          _summaryRow(
                            "Amount to pay".tr,
                            "\$${total.toStringAsFixed(2)}",
                            isDark,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: state is OrderLoading
                      ? null
                      : () async {
                          await _placeOrder(orderBloc, level);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    disabledBackgroundColor: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state is OrderLoading
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        )
                      : TextWidget(
                          "Place Order (Final)".tr,
                          color: isDark ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeOrder(OrderBloc orderBloc, MemberLevel level) async {
    final profile = ProfileManager();
    final address = profile.defaultAddress;
    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Please add a receive address first".tr),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_contactLineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget("Please enter your contact line".tr),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

    final orderId =
        "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final int redeemedPoints = _pointsToRedeem > _effectiveMaxPoints
        ? _effectiveMaxPoints
        : _pointsToRedeem;

    final String paymentMethodName =
        kPaymentMethods[_selectedPayment < kPaymentMethods.length
                ? _selectedPayment
                : 0]
            .title;

    final order = OrderModel(
      id: orderId,

      userId: userId,

      items: widget.items,

      totalAmount: _totalAmount(level),

      status: 'Processing',

      paymentMethod: paymentMethodName,

      deliveryMethod: 'Automatic Benefits',

      address: address,

      createdAt: DateTime.now(),

      promoCode: _appliedVoucherCode,

      discountAmount:
          _discountAmount +
          _automaticDiscount +
          _calculateMembershipDiscount(level) +
          _calculatePointsDiscount(),

      pointsRedeemed: redeemedPoints,

      note: _noteController.text,

      contactLine: _contactLineController.text,

      contactMethod: _contactMethod,
    );

    orderBloc.add(PlaceOrder(order));
  }
}
