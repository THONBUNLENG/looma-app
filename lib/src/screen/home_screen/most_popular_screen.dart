import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
import 'package:shopping_app/src/widget/favorite_button.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class MostPopularSection extends StatefulWidget {
  const MostPopularSection({super.key});

  @override
  State<MostPopularSection> createState() => _MostPopularSectionState();
}

class _MostPopularSectionState extends State<MostPopularSection> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = _firestoreService.getProducts(category: 'POPULAR');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Most Popular".tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UniversalProductScreen(
                        title: 'Most Popular',
                        category: 'POPULAR',
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
          height: 250,
          child: StreamBuilder<List<ProductModel>>(
            stream: _productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget.loadingCenterWidget();
              }
              
              var products = snapshot.data ?? [];
              
              // Fallback to local data if Firestore is empty or has error
              if (products.isEmpty) {
                // Mix of popular items from different categories
                final List<Map<String, dynamic>> mixedPopular = [
                  if (clothes.isNotEmpty) clothes[5],
                  if (shoes.isNotEmpty) shoes[3],
                  if (bags.isNotEmpty) bags[2],
                  if (beauty.isNotEmpty) beauty[0],
                  if (clothes.length > 10) clothes[10],
                  if (shoes.length > 5) shoes[5],
                  if (bags.length > 4) bags[4],
                  if (gift.isNotEmpty) gift[0],
                ];
                products = mixedPopular.map((m) => ProductModel.fromMap(m)).toList();
              }

              if (products.isEmpty) {
                return Center(child: TextWidget("No popular items found".tr, color: isDark ? Colors.white38 : Colors.grey));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 4),
                itemCount: products.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return PopularCard(
                    product: product,
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

class PopularCard extends StatelessWidget {
  final ProductModel product;

  const PopularCard({
    super.key,
    required this.product,
  });

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
        width: 165,
        margin: const EdgeInsets.only(right: 16, bottom: 15, top: 5),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black45
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey[50],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      color: isDark ? Colors.white10 : Colors.grey[100],
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 20),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          (product.subCategory ?? product.category).toString().tr.toUpperCase(),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: isDark ? Colors.white54 : Colors.black45,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FavoriteButton(
                            product: product.toMap(),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          TextWidget(
                            product.sold ?? '0',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    product.title.tr,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
