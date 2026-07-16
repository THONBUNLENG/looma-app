import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../constants/app_color.dart';
import '../list_url.dart';
import 'all_popular_items_screen.dart';

class MostPopularSection extends StatelessWidget {
  const MostPopularSection({super.key});

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
                      builder: (context) => AllPopularItemsScreen(
                        items: popularItems,
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 4),
            itemCount: popularItems.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return PopularCard(
                imageUrl: popularItems[index]['image']!,
                likes: popularItems[index]['likes']!,
                tag: popularItems[index]['tag']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class PopularCard extends StatelessWidget {
  final String imageUrl;
  final String likes;
  final String tag;

  const PopularCard({
    super.key,
    required this.imageUrl,
    required this.likes,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      tag.toUpperCase(),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icon/like1.png',
                          color: AppColor.buttonColor,
                          height: 12,
                          width: 12,
                        ),
                        const SizedBox(width: 4),
                        TextWidget(
                          likes,
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
                  "Premium Item",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
