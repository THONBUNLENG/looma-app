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

class AccessorizeSaveSection extends StatefulWidget {
  const AccessorizeSaveSection({super.key});

  @override
  State<AccessorizeSaveSection> createState() =>
      _AccessorizeSaveSectionState();
}

class _AccessorizeSaveSectionState extends State<AccessorizeSaveSection> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream =
        _firestoreService.getProducts(category: 'ACCESSORIZE_SAVE');
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
                  "Accessorize & Save".tr,
                  fontSize: 24,
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
                        title: 'Accessorize & Save',
                        category: 'ACCESSORIZE_SAVE',
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
          height: 380,
          child: StreamBuilder<List<ProductModel>>(
            stream: _productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget.loadingCenterWidget();
              }
              var products = snapshot.data ?? [];
              if (products.isEmpty) {
                products = allItems
                    .map((m) => ProductModel.fromMap(m))
                    .where((p) => p.isDiscounted)
                    .toList();
              }
              if (products.isEmpty) {
                return Center(
                  child: TextWidget(
                    "No items found".tr,
                    color: isDark ? Colors.white38 : Colors.grey,
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return AccessorizeSaveCard(
                    product: products[index],
                    index: index,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class AccessorizeSaveCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const AccessorizeSaveCard({
    super.key,
    required this.product,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl = product.images.isNotEmpty ? product.images[0] : '';
    final double? oldPrice = product.effectiveOldPrice;

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
        width: 180,
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
                  borderRadius: BorderRadius.zero,
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: imageUrl.isNotEmpty
                            ? Hero(
                          tag: 'accessorize_save_$index',
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
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
                      if (product.isDiscounted)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.saleRed,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextWidget(
                              product.formattedDiscountLabel,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      // Favorite Button
                      Positioned(
                        bottom: 10,
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
              product.brandName ?? "LOOMA",
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
            const SizedBox(height: 6),
            Row(
              children: [
                TextWidget(
                  "\$${product.price.toStringAsFixed(2)}",
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: product.isDiscounted
                      ? AppColor.saleRed
                      : (isDark ? Colors.white : Colors.black),
                ),
                if (oldPrice != null && oldPrice > product.price) ...[
                  const SizedBox(width: 8),
                  Text(
                    "\$${oldPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}