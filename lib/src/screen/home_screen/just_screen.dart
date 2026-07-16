import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import 'card_detail/product_clothes_screen.dart';

class JustForYouSection extends StatelessWidget {
  final List<Map<String, dynamic>> justForYouData;

  const JustForYouSection({super.key, required this.justForYouData});

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
          child: GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: justForYouData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 16,
              childAspectRatio: 0.60,
            ),
            itemBuilder: (context, index) {
              final item = justForYouData[index];
              return JustForYouCard(justForYouData: item, isDark: isDark);
            },
          ),
        ),
      ],
    );
  }
}

class JustForYouCard extends StatelessWidget {
  final Map<String, dynamic> justForYouData;
  final bool isDark;

  const JustForYouCard({
    super.key,
    required this.justForYouData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final String imageUrl =
        (justForYouData['images'] != null &&
            (justForYouData['images'] as List).isNotEmpty)
        ? justForYouData['images'][0]
        : (justForYouData['image'] ?? '');

    final title = justForYouData['title'] ?? 'Product Name';
    final price = justForYouData['price'] ?? '\$0.00';
    final rating = justForYouData['rating'] ?? '4.8';
    final sold = justForYouData['sold'] ?? '0';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: justForYouData),
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
                        tag: imageUrl.isNotEmpty
                            ? imageUrl
                            : 'product_${title}_$price',
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
                  title.toString().tr,
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
                      rating.toString(),
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
                    TextWidget("${sold.toString()} ${'sold'.tr}", color: subTextColor, fontSize: 11),
                  ],
                ),
                const SizedBox(height: 6),
                TextWidget(
                  price,
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

