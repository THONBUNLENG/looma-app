import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';

import 'package:flutter/material.dart';



import 'package:shopping_app/constants/app_color.dart';



import 'package:shopping_app/constants/string_extension.dart';



import 'package:shopping_app/src/screen/home_screen/product_detail/product_clothes_screen.dart';



import 'package:shopping_app/src/widget/text_widget.dart';




import '../list_url.dart';



import 'flash_sale/flash_sale_discount_screen.dart';




class TopSaleScreen extends StatelessWidget {
  const TopSaleScreen({super.key});

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
              TextWidget(
                "Top Sale".tr,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColor.white : AppColor.black,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FlashSaleDiscountScreen(imageUrl: flashSaleImages[0]),
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: jackets.length,
            itemBuilder: (context, index) {
              final item = jackets[index];

              return TopSaleItemCard(jackets: item, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class TopSaleItemCard extends StatelessWidget {
  final Map<String, dynamic> jackets;
  final int index;

  const TopSaleItemCard({
    super.key,
    required this.jackets,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dynamic images = jackets['images'];
    final String imageUrl = images is List && images.isNotEmpty
        ? images.first.toString()
        : (jackets['image'] ?? '').toString();

    final String title = (jackets['title'] ?? 'Product Item').toString();
    final String price = (jackets['price'] ?? '\$0.00').toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: jackets),
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
                                tag: 'top_sale_item_$index',
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
                            color: AppColor.saleRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextWidget(
                            "-50%",
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
                        child: GestureDetector(
                      onTap: () async {
                        if (await AuthService.isLoggedIn()) {
                          // Toggle wishlist logic here
                        } else {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          }
                        }
                      },
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 19,
                          color: Colors.black45,
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
            TextWidget(
              "LOOMA".tr.toUpperCase(),
              fontSize: 13,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            const SizedBox(height: 4),
            TextWidget(
              title.tr,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            TextWidget(
              price,
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




