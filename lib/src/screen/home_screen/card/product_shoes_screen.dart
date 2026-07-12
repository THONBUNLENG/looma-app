import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../list_url.dart';

class ProductShoesScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductShoesScreen({super.key, required this.product});

  @override
  State<ProductShoesScreen> createState() => _ProductShoesScreenState();
}

class _ProductShoesScreenState extends State<ProductShoesScreen> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  int selectedSize = 1;
  int selectedColor = 0;
  int quantity = 1;

  final List<String> sizes = ['39', '40', '41', '42'];
  final List<Color> colors = [
    const Color(0xFF6A8D92),
    const Color(0xFF8B5E4D),
    const Color(0xFF808080),
    const Color(0xFFA9A9A9),
  ];

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
                    child: IconButton(
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
                    "LOOMA",
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
                          (widget.product['title'] ?? 'Product Item')
                              .toString(),
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
                        "${widget.product['sold'] ?? '0'} ${'sold'.tr}",
                        isDark,
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      TextWidget(
                        "${widget.product['rating'] ?? '4.8'} (${widget.product['reviews'] ?? '0'} ${'reviews'.tr})",
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                            "Premium quality shoes designed for style and comfort.")
                        .toString(),
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 15,
                    lineHeight: 1.5,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildSizeSelector(isDark)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildColorSelector(isDark)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextWidget(
                    "Quantity".tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 15),
                  _buildQuantityStepper(isDark),
                  const SizedBox(height: 30),
                  _buildDeliveryReturns(isDark),
                  const Divider(height: 40),
                  _buildModelInfo(isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Product details", isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Size guide", isDark),
                  const Divider(height: 0),
                  _buildCollapsibleItem("Online exchange policy", isDark),
                  const SizedBox(height: 40),
                  _buildSimilarItems(isDark),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildFooterSections(isDark),
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

  Widget _buildSizeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Size".tr,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(sizes.length, (index) {
            final isSelected = selectedSize == index;

            return GestureDetector(
              onTap: () => setState(() => selectedSize = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: TextWidget(
                    sizes[index],
                    fontSize: 13,
                    color: isSelected
                        ? (isDark ? Colors.black : Colors.white)
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildColorSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Color".tr,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: List.generate(colors.length, (index) {
            bool isSelected = selectedColor == index;
            return GestureDetector(
              onTap: () => setState(() => selectedColor = index),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[index],
                  border: isSelected
                      ? Border.all(color: AppColor.primaryColor, width: 3)
                      : null,
                  boxShadow: [
                    if (isSelected)
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuantityStepper(bool isDark) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => setState(() => quantity > 1 ? quantity-- : null),
            icon: const Icon(Icons.remove, size: 20),
          ),
          TextWidget("$quantity", fontSize: 18, fontWeight: FontWeight.bold),
          IconButton(
            onPressed: () => setState(() => quantity++),
            icon: const Icon(Icons.add, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryReturns(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.black54;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: textColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Fast Delivery".tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    TextWidget(
                      "From 1 - 3 days".tr,
                      color: subColor,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.assignment_return_outlined,
                color: textColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "RETURNS".tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    TextWidget(
                      "Within 14 days".tr,
                      color: subColor,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
          "High-quality materials and craftsmanship for ultimate durability.".tr,
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
            itemCount: shoes.length > 10 ? 10 : shoes.length,
            itemBuilder: (context, index) {
              final item = shoes[index];
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
            builder: (context) => ProductShoesScreen(product: item),
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
                            "New In",
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

  Widget _buildFooterSections(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("LOYALTY", isDark),
                  _buildFooterItem(
                    Icons.favorite_outline,
                    "Membership & Benefits",
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("FOLLOW US", isDark),
                  _buildFooterItem(Icons.facebook, "Facebook", isDark),
                  _buildFooterItem(
                    Icons.camera_alt_outlined,
                    "Instagram",
                    isDark,
                  ),
                  _buildFooterItem(Icons.music_note, "TikTok", isDark),
                  _buildFooterItem(
                    Icons.play_circle_outline,
                    "Youtube",
                    isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _buildSectionTitle("CUSTOMER SERVICES", isDark),
        _buildFooterItem(Icons.help_outline, "Online exchange policy", isDark),
        _buildFooterItem(Icons.security, "Privacy Policy", isDark),
        _buildFooterItem(Icons.chat_bubble_outline, "FAQs & guides", isDark),
        _buildFooterItem(Icons.location_on_outlined, "Find a store", isDark),
        const SizedBox(height: 30),
        _buildSectionTitle("CONTACT US", isDark),
        _buildFooterItem(
          Icons.email_outlined,
          "customer.care@loomakh.com",
          isDark,
        ),
        _buildFooterItem(Icons.phone_outlined, "(+855) 011 820 595", isDark),
        _buildFooterItem(Icons.send, "Telegram", isDark),
        const SizedBox(height: 30),
        _buildSectionTitle("WE ACCEPT", isDark),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPaymentBox(
              "ABA",
              const Color(0xFF005A9C),
              isDark,
              imagePath: 'assets/icon/i_color/aba.png',
            ),
            _buildPaymentBox(
              "VISA",
              const Color(0xFF1A1F71),
              isDark,
              imagePath: 'assets/icon/i_color/visa.png',
            ),
            _buildPaymentBox(
              "MasterCard",
              const Color(0xFFEB001B),
              isDark,
              imagePath: 'assets/icon/i_color/mastercard.png',
            ),
            _buildPaymentBox(
              "Wing",
              const Color(0xFF8DC63F),
              isDark,
              imagePath: 'assets/icon/i_color/wing.png',
            ),
            _buildPaymentBox(
              "UnionPay",
              const Color(0xFF00334E),
              isDark,
              imagePath: 'assets/icon/i_color/union_pay.png',
            ),
            _buildPaymentBox(
              "JCB",
              const Color(0xFF00338D),
              isDark,
              imagePath: 'assets/icon/i_color/jcb.png',
            ),
            _buildPaymentBox(
              "Chip Mong",
              const Color(0xFF00833E),
              isDark,
              imagePath: 'assets/icon/i_color/chip_mong.png',
            ),
            _buildPaymentBox(
              "Bank Transfer",
              Colors.grey,
              isDark,
              imagePath: 'assets/icon/i_color/bank_transfer.png',
            ),
            _buildPaymentBox(
              "Cash on Delivery",
              Colors.brown,
              isDark,
              imagePath: 'assets/icon/i_color/cash_on_delivery.png',
            ),
            _buildPaymentBox(
              "PayPal",
              Colors.amber,
              isDark,
              imagePath: 'assets/icon/i_color/paypal.png',
            ),
            _buildPaymentBox(
              imagePath: 'assets/icon/i_color/ac.png',
              "Acleda Bank",
              Colors.pinkAccent,
              isDark,

            ),
            _buildPaymentBox(
              imagePath: 'assets/icon/i_color/google_pay.png',
              "Google Pay",
              AppColor.accentLightBlue,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextWidget(
        title.tr,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: TextWidget(
              title,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBox(
    String label,
    Color color,
    bool isDark, {
    String? imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      height: 35,
      child: imagePath != null
          ? Image.asset(imagePath, fit: BoxFit.contain)
          : Center(
              child: TextWidget(
                label.tr,
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
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
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 25),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final cartItem = Map<String, dynamic>.from(widget.product);
                  cartItem['quantity'] = quantity;
                  cartItem['selectedSize'] = sizes[selectedSize];
                  cartItem['selectedColorIndex'] = selectedColor;
                  CartManager().addToCart(cartItem);

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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 20),
                    const SizedBox(width: 10),
                    TextWidget(
                      "Add to Cart".tr,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
