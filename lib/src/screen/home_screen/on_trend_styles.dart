import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
import 'package:shopping_app/src/widget/favorite_button.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class OnTrendStylesSection extends StatefulWidget {
  const OnTrendStylesSection({super.key});

  @override
  State<OnTrendStylesSection> createState() => _OnTrendStylesSectionState();
}

class _OnTrendStylesSectionState extends State<OnTrendStylesSection> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = _firestoreService.getProducts(category: 'TRENDING');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextWidget(
                  "On Trend Styles".tr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColor.white : AppColor.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UniversalProductScreen(
                        title: 'On Trend Styles',
                        category: 'TRENDING',
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    TextWidget(
                      "SEE MORE".tr,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 350,
          child: StreamBuilder<List<ProductModel>>(
            stream: _productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget.loadingCenterWidget();
              }
              var products = snapshot.data ?? [];
              if (products.isEmpty) {
                products = onTrend.map((m) => ProductModel.fromMap(m)).toList();
              }

              if (products.isEmpty) {
                return Center(
                  child: TextWidget(
                    "No trend items found".tr,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: products.length > 6 ? 6 : products.length,
                itemBuilder: (context, index) {
                  return TrendItemCard(product: products[index], index: index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrendItemCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const TrendItemCard({super.key, required this.product, required this.index});

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product.toMap()),
          ),
        );
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 18, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColor.grey100,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: imageUrl.isNotEmpty
                            ? Hero(
                                tag: 'trend_item_$index',
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.grey[300],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image_outlined),
                                ),
                              )
                            : const Icon(Icons.image_not_supported_outlined),
                      ),
                      if (product.discount != null &&
                          product.discount!.isNotEmpty &&
                          product.discount != "0%")
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.saleRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextWidget(
                              product.discount!.tr,
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: FavoriteButton(
                          product: product.toMap(),
                          size: 19,
                          showBackground: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextWidget(
              "LOOMA",
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            const SizedBox(height: 4),
            TextWidget(
              product.title.tr,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            TextWidget(
              "\$${product.price.toStringAsFixed(2)}",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
            if (product.colors.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: product.colors.take(4).map((colorName) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: _parseColor(colorName),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
