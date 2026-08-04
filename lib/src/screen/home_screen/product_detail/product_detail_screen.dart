import 'dart:async';
import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/manager/wishlist_manager.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_confirm_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_review_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/widget/product_detail_widgets.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import '../../../../constants/navigator_extension.dart';

class ProductClothesScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductClothesScreen({super.key, required this.product});

  @override
  State<ProductClothesScreen> createState() => _ProductClothesScreenState();
}

class _ProductClothesScreenState extends State<ProductClothesScreen> {
  late ProductModel product;
  late PageController _pageController;
  late Stream<List<ProductModel>> _similarProductsStream;
  int _currentPage = 0;

  int selectedSize = 0;
  int selectedColor = 0;
  int quantity = 1;

  List<String> get sizes => product.sizes.isNotEmpty ? product.sizes : ['S', 'M', 'L', 'XL'];
  
  List<Color> get colors {
    if (product.colors.isEmpty) {
      return [
        const Color(0xFF6A8D92),
        const Color(0xFF8B5E4D),
        const Color(0xFF808080),
        const Color(0xFFA9A9A9),
      ];
    }
    return product.colors.map((c) => _parseColor(c)).toList();
  }

  Color _parseColor(String colorName) {
    colorName = colorName.toLowerCase().trim().replaceAll(' ', '');
    switch (colorName) {
      case 'pink':
        return AppColor.pink;
      case 'salered':
        return AppColor.saleRed;
      case 'successgreen':
        return AppColor.successGreen;
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'blue':
      case 'skyblue':
        return Colors.blue;
      case 'navy':
      case 'darkblue':
        return const Color(0xFF000080);
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'purple':
        return Colors.purple;
      case 'tan':
        return const Color(0xFFD2B48C);
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'khaki':
        return const Color(0xFFC3B091);
      case 'mint':
        return const Color(0xFF98FF98);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      default:
        if (colorName.startsWith('#')) {
          try {
            return Color(int.parse(colorName.replaceFirst('#', '0xFF')));
          } catch (_) {}
        }
        return Colors.grey;
    }
  }

  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    product = ProductModel.fromMap(widget.product);
    isFavorite = WishlistManager().isFavorite(widget.product);
    _pageController = PageController(initialPage: 0);
    _similarProductsStream = FirestoreService().getProducts(category: product.category);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final unitPrice = product.price;

    List<String> images = List.from(product.images);
    if (images.isEmpty) {
      images = [
        'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
      ];
    }
    if (product.imageColor.length > selectedColor && product.imageColor[selectedColor].isNotEmpty) {
      final colorImage = product.imageColor[selectedColor];
      if (!images.contains(colorImage)) {
        images.insert(0, colorImage);
      } else {
        images.remove(colorImage);
        images.insert(0, colorImage);
      }
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
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: images[index] + (widget.product['id'] ?? widget.product['title'] ?? ''),
                        child: CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: isDark ? Colors.white10 : AppColor.grey100,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined, size: 40),
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
                        const CartBadge(showBackground: true, iconColor: Colors.white),
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
                          product.title.tr,
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
                            WishlistManager().toggleWishlist(widget.product);
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
                        "${product.sold ?? '0'} ${'sold'.tr}",
                        isDark,
                      ),
                      if (product.gender != null && product.gender!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        _buildBadge(
                          product.gender!.tr.toUpperCase(),
                          isDark,
                          icon: Icons.person_outline,
                        ),
                      ],
                      if (product.discount != null && product.discount != '0%' && product.discount != '0') ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.saleRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextWidget(
                            "-${product.discount}",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const Spacer(),
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
                          "${product.rating} (${product.reviews ?? '0'} ${'reviews'.tr})",
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
                    (product.description ??
                            "Premium quality clothing designed for style and comfort.")
                        .tr,
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

  Widget _buildBadge(String text, bool isDark, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isDark ? Colors.white54 : Colors.black45),
            const SizedBox(width: 4),
          ],
          TextWidget(
            text,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Size".tr, fontSize: 16, fontWeight: FontWeight.bold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(sizes.length, (index) {
            bool isSelected = selectedSize == index;
            return GestureDetector(
              onTap: () => setState(() => selectedSize = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                constraints: const BoxConstraints(minWidth: 45, minHeight: 45),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizes[index].length > 2 ? 15 : 30),
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: IntrinsicWidth(
                  child: Center(
                    child: TextWidget(
                      sizes[index],
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white : Colors.black),
                      fontWeight: FontWeight.bold,
                    ),
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
        TextWidget("Colors".tr, fontSize: 16, fontWeight: FontWeight.bold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(colors.length, (index) {
            bool isSelected = selectedColor == index;

            String? imageUrl;
            if (product.imageColor.length > index && product.imageColor[index].isNotEmpty) {
              imageUrl = product.imageColor[index];
            } else if (product.imageColor.isEmpty && product.images.length > index) {
              imageUrl = product.images[index];
            }

            bool hasImage = imageUrl != null;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                  if (_pageController.hasClients) {
                    // If we have a specific image_color, it's moved to the front (index 0)
                    // Otherwise, we jump to the corresponding index in the main gallery
                    int targetPage = (product.imageColor.length > index && product.imageColor[index].isNotEmpty) 
                        ? 0 
                        : index;
                    
                    if (targetPage < product.images.length || targetPage == 0) {
                      _pageController.animateToPage(
                        targetPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: hasImage ? 80 : 48,
                height: hasImage ? 80 : 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
                  border: Border.all(
                    color: isSelected 
                        ? (isDark ? Colors.white : Colors.black) 
                        : (isDark ? Colors.white10 : Colors.grey.shade200),
                    width: 2,
                  ),
                ),
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 1),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 20),
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[index],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
              ),
            );
          }),
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
          "Model is 175 cm tall / 65 kg weight and is wearing size M.".tr,
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
          child: StreamBuilder<List<ProductModel>>(
            stream: _similarProductsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var products = snapshot.data ?? [];
              
              // Filter out current product
              var filteredProducts = products.where((p) => p.title != product.title).toList();
              
              // Fallback to local data if empty
              if (filteredProducts.isEmpty) {
                 final String cat = product.category.toUpperCase();
                 final String? subCat = product.subCategory?.toUpperCase();
                 
                 List<Map<String, dynamic>> localSource = [];

                 // Try to match subCategory first for better accuracy
                 if (subCat == 'POLOS') {
                   localSource = polos;
                 } else if (subCat == 'JEANS') {
                   localSource = jeans;
                 } else if (subCat == 'DRESSES') {
                   localSource = dresses;
                 } else if (subCat == 'T-SHIRTS' || subCat == 'TSHIRTS') {
                   localSource = tShirts;
                 } else if (subCat == 'JACKETS') {
                   localSource = jackets;
                 } else if (subCat == 'SKIRT') {
                   localSource = skirt;
                 } else if (subCat == 'BELTS') {
                   localSource = belts;
                 } else if (subCat == 'WATCHES') {
                   localSource = watches;
                 } else if (subCat == 'SKINCARE') {
                   localSource = skincare;
                 } else if (subCat == 'MAKEUP') {
                   localSource = makeup;
                 } else {
                   // Fallback to broader category if subCategory match not found
                   if (cat == 'CLOTHING') {
                     localSource = clothes;
                   } else if (cat == 'SHOES') {
                     localSource = shoes;
                   } else if (cat == 'BAGS') {
                     localSource = bags;
                   } else if (cat == 'ACCESSORIES') {
                     localSource = accessories;
                   } else if (cat == 'BEAUTY') {
                     localSource = beauty;
                   } else if (cat == 'GIFTS') {
                     localSource = gift;
                   } else {
                     localSource = allItems;
                   }
                 }

                 // Create models and shuffle to show different items each time
                 var mappedProducts = localSource.map((m) => ProductModel.fromMap(m)).toList();
                 mappedProducts.shuffle();
                 
                 filteredProducts = mappedProducts
                    .where((p) => p.title != product.title)
                    .take(10)
                    .toList();
              }

              if (filteredProducts.isEmpty) {
                return Center(child: TextWidget("No similar items found".tr, color: isDark ? Colors.white38 : Colors.grey));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final item = filteredProducts[index];
                  return _buildSimilarProductCard(item.toMap(), isDark, index);
                },
              );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: item),
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
              "\$${ProductModel.fromMap(item).price.toStringAsFixed(2)}",
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
                        cartItem['selectedSize'] = sizes[selectedSize];
                        
                        // Get the color name from the product colors list
                        String selectedColorName = product.colors.isNotEmpty 
                            ? product.colors[selectedColor] 
                            : 'Default';
                        cartItem['selectedColor'] = selectedColorName;
                        cartItem['selectedColorIndex'] = selectedColor;
                        
                        CartManager().addToCart(cartItem);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: TextWidget(
                                "${'Added to Cart'.tr}: ${product.title}",
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
                        cartItem['selectedSize'] = sizes[selectedSize];
                        
                        // Get the color name from the product colors list
                        String selectedColorName = product.colors.isNotEmpty 
                            ? product.colors[selectedColor] 
                            : 'Default';
                        cartItem['selectedColor'] = selectedColorName;
                        cartItem['selectedColorIndex'] = selectedColor;

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
