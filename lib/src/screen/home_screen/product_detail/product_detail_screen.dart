import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_review_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/full_image_gallery.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/widget/favorite_button.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/widget/product_detail_widgets.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/manager/review_manager.dart';
import 'package:shopping_app/src/model/review_model.dart';
import 'dart:io';
import '../../../../constants/navigator_extension.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductModel product;
  late PageController _pageController;
  late Stream<List<ProductModel>> _similarProductsStream;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  int selectedSize = 0;
  int selectedColor = 0;
  int quantity = 1;

  List<String> get sizes =>
      product.sizes.isNotEmpty ? product.sizes : ['S', 'M', 'L', 'XL'];

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

  @override
  void initState() {
    super.initState();
    product = ProductModel.fromMap(widget.product);
    _pageController = PageController(initialPage: 0);
    _similarProductsStream = FirestoreService().getProducts(
      category: product.category,
    );
    _startAutoScroll();
    ReviewManager().addListener(_onReviewsChanged);
  }

  void _onReviewsChanged() {
    if (mounted) setState(() {});
  }

  void _shareProduct() {
    final String shareText =
        'Check out this product on LOOMA: ${product.title}\nPrice: \$${product.price.toStringAsFixed(2)}\n\nDownload the app to see more!';
    Share.share(shareText, subject: 'Check out ${product.title}');
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        List<String> images = List.from(product.images);
        if (images.isEmpty) return;

        int nextPage = (_currentPage + 1) % images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    ReviewManager().removeListener(_onReviewsChanged);
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
    if (product.imageColor.length > selectedColor &&
        product.imageColor[selectedColor].isNotEmpty) {
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
                  height: MediaQuery.of(context).size.height * 0.7,
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
                      return GestureDetector(
                        onTap: () {
                          Go.to(
                            FullImageGallery(
                              images: images,
                              title: product.title,
                              productId:
                                  (widget.product['id'] ??
                                          widget.product['title'] ??
                                          '')
                                      .toString(),
                            ),
                          );
                        },
                        child: Hero(
                          tag:
                              images[index] +
                              (widget.product['id'] ??
                                      widget.product['title'] ??
                                      '')
                                  .toString(),
                          child: CachedNetworkImage(
                            imageUrl: images[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? Colors.white10 : AppColor.grey100,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                              ),
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
                          icon: CircleAvatar(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.15,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: _shareProduct,
                              icon: const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.black26,
                                child: Icon(
                                  Icons.share_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const CartBadge(
                              showBackground: true,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            if (images.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: _buildImageThumbnails(images, isDark),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildPriceSection(isDark),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildBadge(
                        "${product.sold ?? '0'} ${'sold'.tr}",
                        isDark,
                      ),
                      if (product.gender != null &&
                          product.gender!.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        _buildBadge(
                          product.gender!.tr.toUpperCase(),
                          isDark,
                          icon: Icons.person_outline,
                        ),
                      ],
                      if (product.discount != null &&
                          product.discount != '0%' &&
                          product.discount != '0') ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
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
                  const SizedBox(height: 20),
                  _buildSizeSelector(isDark),
                  const SizedBox(height: 20),
                  _buildColorSelector(isDark),
                  const SizedBox(height: 20),
                  _buildExpansionTiles(isDark),
                  const SizedBox(height: 30),
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

  Widget _buildPriceSection(bool isDark) {
    final currentPrice = product.price;
    final discountStr = product.discount;

    double? originalPrice;
    if (discountStr != null && discountStr.contains('%')) {
      final discountPercent =
          double.tryParse(discountStr.replaceAll('%', '')) ?? 0;
      if (discountPercent > 0) {
        originalPrice = currentPrice / (1 - (discountPercent / 100));
      }
    }

    return Row(
      children: [
        TextWidget(
          "\$${currentPrice.toStringAsFixed(2)}",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: originalPrice != null ? AppColor.saleRed : null,
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 8),
          TextWidget(
            "\$${originalPrice.toStringAsFixed(2)}",
            fontSize: 18,
            color: isDark ? Colors.white38 : Colors.grey,
            textDecoration: TextDecoration.lineThrough,
          ),
        ],
      ],
    );
  }

  Widget _buildReviewSection(bool isDark) {
    final productId = (widget.product['id'] ?? widget.product['title'] ?? '')
        .toString();
    final localReviews = ReviewManager().getReviews(productId);
    final List<ReviewModel> dummyReviews = [];
    final allReviews = [...localReviews, ...dummyReviews];
    if (allReviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            TextWidget(
              "No reviews yet".tr,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Go.to(ProductReviewScreen(product: widget.product));
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColor.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextWidget(
                "Write a Review".tr,
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              "${allReviews.length} ${'Reviews'.tr}",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            TextButton(
              onPressed: () {
                Go.to(ProductReviewScreen(product: widget.product));
              },
              child: TextWidget(
                "Add".tr,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...List.generate(
          allReviews.length > 3 ? 3 : allReviews.length,
          (index) => _buildLocalReviewCard(allReviews[index], isDark),
        ),
        if (allReviews.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                Go.to(ProductReviewScreen(product: widget.product));
              },
              child: TextWidget(
                "See all reviews".tr,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocalReviewCard(ReviewModel review, bool isDark) {
    final subTextColor = isDark ? Colors.white54 : Colors.black54;
    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildUserAvatar(review.userImage, review.userName, isDark),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        review.userName,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(height: 2),
                      TextWidget(
                        "${review.date.day}/${review.date.month}/${review.date.year}",
                        fontSize: 11,
                        color: subTextColor,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color: index < review.rating
                        ? Colors.orange
                        : Colors.grey[200],
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 12),
            TextWidget(
              review.comment,
              fontSize: 13,
              lineHeight: 1.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ],
          if (review.images != null && review.images!.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images!.length,
                itemBuilder: (context, index) {
                  final imagePath = review.images![index];
                  final isLocal = !imagePath.startsWith('http');
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: isLocal
                            ? FileImage(File(imagePath)) as ImageProvider
                            : NetworkImage(imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String url, String name, bool isDark) {
    final bool hasImage = url.isNotEmpty && url.startsWith('http');
    return CircleAvatar(
      radius: 16,
      backgroundColor: hasImage
          ? Colors.transparent
          : (isDark ? Colors.white10 : Colors.grey[200]),
      backgroundImage: hasImage ? NetworkImage(url) : null,
      child: !hasImage
          ? TextWidget(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            )
          : null,
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
            Icon(
              icon,
              size: 14,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
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

  Widget _buildImageThumbnails(List<String> images, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double navButtonsWidth = 40 + 12 + 40 + 8;
        const double thumbSlot = 45 + 4;
        const double containerPadding = 8;

        final double availableForThumbs =
            constraints.maxWidth - 40 - navButtonsWidth - containerPadding;

        int maxVisible = (availableForThumbs / thumbSlot).floor();
        if (maxVisible < 1) maxVisible = 1;
        final bool hasMore = images.length > maxVisible;
        final int displayCount = hasMore
            ? (maxVisible - 1).clamp(1, images.length)
            : images.length;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(displayCount, (index) {
                        final bool isSelected = _currentPage == index;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.primaryColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: isDark
                                      ? Colors.white10
                                      : Colors.grey[200],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      if (hasMore)
                        GestureDetector(
                          onTap: () {
                            if (_currentPage < images.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: TextWidget(
                              "+${images.length - displayCount}",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildNavButton(Icons.chevron_left, () {
                if (_currentPage > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }, isDark),
              const SizedBox(width: 8),
              _buildNavButton(Icons.chevron_right, () {
                if (_currentPage < images.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isDark ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildSizeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget("Size".tr, fontSize: 18, fontWeight: FontWeight.bold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(sizes.length, (index) {
            bool isSelected = selectedSize == index;
            return GestureDetector(
              onTap: () => setState(() => selectedSize = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 70,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: TextWidget(
                    sizes[index],
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16,
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
    String selectedColorName = product.colors.isNotEmpty
        ? product.colors[selectedColor]
        : 'Default';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget("Color".tr, fontSize: 18, fontWeight: FontWeight.bold),
            TextWidget(
              selectedColorName.tr,
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedColor == index;
              String? imageUrl;
              if (product.imageColor.length > index &&
                  product.imageColor[index].isNotEmpty) {
                imageUrl = product.imageColor[index];
              } else if (product.imageColor.isEmpty &&
                  product.images.length > index) {
                imageUrl = product.images[index];
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = index;
                    if (_pageController.hasClients) {
                      int targetPage =
                          (product.imageColor.length > index &&
                              product.imageColor[index].isNotEmpty)
                          ? 0
                          : index;

                      if (targetPage < product.images.length ||
                          targetPage == 0) {
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
                  width: 74,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: imageUrl != null
                        ? BoxShape.rectangle
                        : BoxShape.circle,
                    borderRadius: imageUrl != null
                        ? BorderRadius.circular(12)
                        : null,
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: imageUrl != null
                        ? BorderRadius.circular(9)
                        : BorderRadius.circular(35),
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? Colors.white10 : Colors.grey[100],
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image, size: 20),
                          )
                        : Container(
                            color: colors[index],
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTiles(bool isDark) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: TextWidget(
              "Description".tr,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextWidget(
                  (product.description ??
                          "Premium quality clothing designed for style and comfort.")
                      .tr,
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 15,
                  lineHeight: 1.5,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: TextWidget(
              "Service".tr,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            children: [_buildServiceGrid(isDark), const SizedBox(height: 16)],
          ),
        ),
        const Divider(height: 1),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: TextWidget(
              "Model info".tr,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextWidget(
                  "Model is 178 cm tall / 68 kg weight and is wearing size M."
                      .tr,
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: TextWidget(
              "Reviews".tr,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            children: [_buildReviewSection(isDark), const SizedBox(height: 16)],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildServiceGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 4.5,
      children: [
        _buildServiceItem(
          Icons.local_shipping_outlined,
          "Global Shipping".tr,
          isDark,
        ),
        _buildServiceItem(
          Icons.assignment_return_outlined,
          "14-Day Return Policy".tr,
          isDark,
        ),
        _buildServiceItem(
          Icons.chat_bubble_outline,
          "Customer Service".tr,
          isDark,
        ),
        _buildServiceItem(Icons.lock_outline, "Secure Payment".tr, isDark),
        _buildServiceItem(
          Icons.card_membership_outlined,
          "Perks and Membership".tr,
          isDark,
        ),
      ],
    );
  }

  Widget _buildServiceItem(IconData icon, String title, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 24, color: isDark ? Colors.white70 : Colors.black87),
        const SizedBox(width: 12),
        Expanded(
          child: TextWidget(
            title,
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  List<ProductModel>? _cachedFallbackProducts;

  List<ProductModel> _getFallbackProducts() {
    if (_cachedFallbackProducts != null) return _cachedFallbackProducts!;

    final String cat = product.category.toUpperCase();
    final String? subCat = product.subCategory?.toUpperCase();

    List<Map<String, dynamic>> localSource = [];
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
    } else if (cat == 'CLOTHING') {
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

    final mapped = localSource.map((m) => ProductModel.fromMap(m)).toList()
      ..shuffle();

    _cachedFallbackProducts = mapped
        .where((p) => p.title != product.title)
        .take(10)
        .toList();

    return _cachedFallbackProducts!;
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

              if (snapshot.hasError) {
                final fallback = _getFallbackProducts();
                if (fallback.isEmpty) {
                  return Center(
                    child: TextWidget(
                      "No similar items found".tr,
                      color: isDark ? Colors.white38 : Colors.grey,
                    ),
                  );
                }
                return _buildSimilarList(fallback, isDark);
              }
              final products = snapshot.data ?? [];
              var filteredProducts = products
                  .where((p) => p.title != product.title)
                  .toList();

              if (filteredProducts.isEmpty) {
                filteredProducts = _getFallbackProducts();
              }

              if (filteredProducts.isEmpty) {
                return Center(
                  child: TextWidget(
                    "No similar items found".tr,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                );
              }

              return _buildSimilarList(filteredProducts, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarList(List<ProductModel> filteredProducts, bool isDark) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final item = filteredProducts[index];
        return _buildSimilarProductCard(item.toMap(), isDark, index);
      },
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

    final String title = (item['title'] ?? 'Product').toString();
    final double price = _parsePrice(item['price']);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: item),
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
              title,
              fontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 4),
            TextWidget(
              "\$${price.toStringAsFixed(2)}",
              fontSize: 14,
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  double _parsePrice(dynamic raw) {
    if (raw == null) return 0.0;
    if (raw is num) return raw.toDouble();
    final cleaned = raw.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
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
            Expanded(
              flex: 4,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 20,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                    const SizedBox(width: 8),
                    TextWidget(
                      "Add to bag".tr,
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: FavoriteButton(product: product.toMap(), size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
