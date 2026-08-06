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

class NewItemsSection extends StatefulWidget {
  const NewItemsSection({super.key});

  @override
  State<NewItemsSection> createState() => _NewItemsSectionState();
}

class _NewItemsSectionState extends State<NewItemsSection> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = _firestoreService.getProducts(category: 'NEW_ARRIVALS');
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
                  "New Items".tr,
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
                        title: 'New Items',
                        category: 'NEW_ARRIVALS',
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
          height: 315,
          child: StreamBuilder<List<ProductModel>>(
            stream: _productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget.loadingCenterWidget();
              }
              var products = snapshot.data ?? [];
              
              // Fallback to local data if Firestore is empty
              if (products.isEmpty) {
                // Mix of clothes, shoes, and bags
                final List<Map<String, dynamic>> mixedItems = [
                  if (clothes.isNotEmpty) clothes[0],
                  if (shoes.isNotEmpty) shoes[0],
                  if (bags.isNotEmpty) bags[0],
                  if (clothes.length > 1) clothes[1],
                  if (shoes.length > 1) shoes[1],
                  if (bags.length > 1) bags[1],
                  if (clothes.length > 2) clothes[2],
                  if (shoes.length > 2) shoes[2],
                  if (bags.length > 2) bags[2],
                ];
                products = mixedItems.map((m) => ProductModel.fromMap(m)).toList();
              }

              if (products.isEmpty) {
                return Center(child: TextWidget("No new items".tr, color: isDark ? Colors.white38 : Colors.grey));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return NewItemCard(product: products[index], index: index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewItemCard extends StatelessWidget {
  final ProductModel product;
  final int index;

  const NewItemCard({super.key, required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: product.toMap()),
          ),
        );
      },
      child: Container(
        width: 190,
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
                                tag: 'new_item_$index',
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
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextWidget(
                            "NEW",
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
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
          ],
        ),
      ),
    );
  }
}
