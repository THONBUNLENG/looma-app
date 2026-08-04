import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class JustForYouSection extends StatefulWidget {
  const JustForYouSection({super.key});

  @override
  State<JustForYouSection> createState() => _JustForYouSectionState();
}

class _JustForYouSectionState extends State<JustForYouSection> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = _firestoreService.getProducts(category: 'JUST_FOR_YOU');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              TextWidget(
                "Just For You".tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.auto_awesome,
                color: Colors.orangeAccent,
                size: 22,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<List<ProductModel>>(
            stream: _productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget.loadingCenterWidget();
              }
              
              var products = snapshot.data ?? [];
              
              // Fallback to local data if Firestore is empty or has error
              if (products.isEmpty) {
                products = justForYouData.take(10).map((m) => ProductModel.fromMap(m)).toList();
              }

              if (products.isEmpty) {
                return Center(child: TextWidget("No recommendations yet".tr, color: isDark ? Colors.white38 : Colors.grey));
              }
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 25,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) {
                  return JustForYouCard(product: products[index], isDark: isDark);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class JustForYouCard extends StatelessWidget {
  final ProductModel product;
  final bool isDark;

  const JustForYouCard({
    super.key,
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColor.grey100,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black45
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: imageUrl + (product.id ?? product.title),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDark ? Colors.white10 : Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: isDark ? Colors.white10 : Colors.white,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () async {
                          if (await AuthService.isLoggedIn()) {
                            // Wishlist logic
                          } else {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            }
                          }
                        },
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: isDark
                              ? Colors.black38
                              : Colors.white.withValues(alpha: 0.8),
                          child: Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "LOOMA PREMIUM".tr,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                const SizedBox(height: 2),
                TextWidget(
                  product.title.tr,
                  fontSize: 15,
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    TextWidget(
                      product.rating.toString(),
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextWidget(
                        "|",
                        color: subTextColor.withValues(alpha: 0.2),
                      ),
                    ),
                    TextWidget(
                      "${product.sold ?? '0'} ${'sold'.tr}",
                      color: subTextColor,
                      fontSize: 11,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextWidget(
                  "\$${product.price.toStringAsFixed(2)}",
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
