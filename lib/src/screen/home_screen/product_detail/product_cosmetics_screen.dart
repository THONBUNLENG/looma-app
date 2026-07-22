import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_confirm_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_review_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/widget/product_detail_widgets.dart';
import '../../../../constants/navigator_extension.dart';
import '../../list_url.dart';

class ProductCosmeticsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCosmeticsScreen({super.key, required this.product});

  @override
  State<ProductCosmeticsScreen> createState() => _ProductCosmeticsScreenState();
}

class _ProductCosmeticsScreenState extends State<ProductCosmeticsScreen> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int quantity = 1;

  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product['is_favorite'] ?? false;
    _pageController = PageController(initialPage: 0);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    int imageCount = 1;
    if (widget.product['images'] != null && widget.product['images'] is List) {
      imageCount = (widget.product['images'] as List).length;
    } else if (widget.product['image'] != null) {
      imageCount = 4;
    }

    if (imageCount <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int next = (_currentPage + 1) % imageCount;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

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
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final unitPrice = _parsePrice(widget.product['price']);

    List<String> images = [];
    if (widget.product['images'] != null && widget.product['images'] is List) {
      images = List<String>.from(widget.product['images']);
    } else if (widget.product['image'] != null &&
        widget.product['image'].toString().isNotEmpty) {
      images = List.generate(4, (index) => widget.product['image'].toString());
    } else {
      images = [
        'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
      ];
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey[100],
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                      _startTimer();
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: images[index],
                        child: CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: isDark ? Colors.white10 : AppColor.grey100,
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              imageUrl:
                              'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const CircleAvatar(
                            backgroundColor: Colors.black26,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const CartBadge(showBackground: true, iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColor.primaryColor
                                : Colors.grey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "LOOMA".tr.toUpperCase(),
                    fontSize: 14,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          (widget.product['title'] ?? 'Product Item').toString().tr,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 28,
                            color: isFavorite
                                ? Colors.red
                                : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildBadge(
                        "${widget.product['sold'] ?? '0'} ${"sold".tr}",
                        isDark,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          Go.to(ProductReviewScreen(product: widget.product));
                        },
                        child: TextWidget(
                          "${widget.product['rating'] ?? '4.8'} (${widget.product['reviews'] ?? '0'} ${"reviews".tr})",
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextWidget(
                    "Description".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 10),
                  TextWidget(
                    (widget.product['description'] ??
                        "Premium quality product designed for durability and comfort.")
                        .toString()
                       .tr,
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 15,
                    lineHeight: 1.5,
                  ),
                  const SizedBox(height: 30),
                  TextWidget(
                    "Quantity".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 15),
                  QuantityStepper(
                    quantity: quantity,
                    isDark: isDark,
                    onIncrement: () => setState(() => quantity++),
                    onDecrement: () => setState(() => quantity > 1 ? quantity-- : null),
                  ),
                  const SizedBox(height: 30),
                  DeliveryReturnsInfo(isDark: isDark),
                  const Divider(height: 40),
                  _buildModelInfo(isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Product details".tr, isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Size guide".tr, isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Online exchange policy".tr, isDark),
                  const SizedBox(height: 40),
                  _buildSimilarItems(isDark),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  ProductFooter(isDark: isDark),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(unitPrice, isDark),
    );
  }

  Widget _buildBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextWidget(
        text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  Widget _buildModelInfo(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    return ExpansionTile(
      title: TextWidget(
        "Model info".tr,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: textColor,
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 20, top: 10),
      iconColor: textColor,
      collapsedIconColor: textColor,
      shape: const Border(),
      children: [
        TextWidget(
          "Premium jewelry crafted with high-quality materials and exquisite attention to detail.".tr,
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 15,
          lineHeight: 1.4,
        ),
      ],
    );
  }

  Widget _buildCollapsibleItem(String title, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: TextWidget(
        title.tr,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: textColor,
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: textColor),
      onTap: () {},
    );
  }

  Widget _buildSimilarItems(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Similar items".tr,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: skincare .length > 10 ? 10 : skincare .length,
            itemBuilder: (context, index) {
              final item =skincare [index];
              return _buildSimilarProductCard(item, isDark, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarProductCard(
      Map<String, dynamic> item,
      bool isDark,
      int index,
      ) {
    final dynamic images = item['images'];
    final String imageUrl = images is List && images.isNotEmpty
        ? images.first.toString()
        : (item['image'] ?? '').toString();

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductCosmeticsScreen(product: item),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      color: isDark ? Colors.white10 : AppColor.grey100,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.white24 : Colors.grey[300],
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 10,
                          ),
                          const SizedBox(width: 4),
                          TextWidget(
                            "New In".tr,
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextWidget(
              (item['title'] ?? 'Product').toString().tr,
              fontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 4),
            TextWidget(
              item['price'] ?? '\$0.00',
              fontSize: 14,
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(double unitPrice, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Total price".tr,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                TextWidget(
                  "\$${(unitPrice * quantity).toStringAsFixed(2)}",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final isLoggedIn = await AuthService.isLoggedIn();
                        if (!isLoggedIn) {
                          if (mounted) Go.to(LoginScreen());
                          return;
                        }
                        final cartItem = Map<String, dynamic>.from(widget.product);
                        cartItem['quantity'] = quantity;
                        CartManager().addToCart(cartItem);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: TextWidget(
                                "${'Added to Cart'.tr}: ${widget.product['title'] ?? 'Product Item'}",
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
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? Colors.white30 : Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 18, color: isDark ? Colors.white : Colors.black87),
                          TextWidget(
                            "Add to Cart".tr,
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final isLoggedIn = await AuthService.isLoggedIn();
                        if (!isLoggedIn) {
                          if (mounted) Go.to(LoginScreen());
                          return;
                        }
                        final cartItem = Map<String, dynamic>.from(widget.product);
                        cartItem['quantity'] = quantity;
                        CartManager().addToCart(cartItem);
                        if (mounted) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmScreen(items: [cartItem]),
                          ),
                        );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.pink100Color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 18),
                          TextWidget(
                            "Order Now".tr,
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
