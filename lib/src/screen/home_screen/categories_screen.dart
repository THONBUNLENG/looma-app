import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/all_categories_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/bag_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/gift.dart';
import 'package:shopping_app/src/screen/home_screen/categories/lingerie_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/toys.dart';
import 'package:shopping_app/src/screen/home_screen/categories/watch_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../list_url.dart';
import 'categories/accessories_screen.dart';
import 'categories/clothes_screen.dart';
import 'categories/cosmetics_screen.dart';
import 'categories/perfumes_screen.dart';
import 'categories/shoes_screen.dart';

class CategoryItem {
  final String title;
  final String asset;
  final Widget screen;
  CategoryItem({
    required this.title,
    required this.asset,
    required this.screen,
  });
}

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}
class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<CategoryItem> categories = [
      CategoryItem(
        title: 'Clothes',
        asset: 'assets/icon/i_color/clothes.png',
        screen: const ClothesScreen(
          categoryName: 'LOOMA CLOTHES',
        ),
      ),
      CategoryItem(
        title: 'Shoes',
        asset: 'assets/icon/i_color/shoes.png',
        screen: const ShoesScreen(
          categoryName: 'LOOMA SHOES',
        ),
      ),
      CategoryItem(
        title: 'Bags',
        asset: 'assets/icon/i_color/pag.png',
        screen: const BagesScreen(
          categoryName: 'LOOMA BAGS',
        ),
      ),
      CategoryItem(
        title: 'Watch',
        asset: 'assets/icon/i_color/watch.png',
        screen: const WatchScreen(categoryName: 'LOOMA WATCH'),
      ),
      CategoryItem(
        title: 'Accessories',
        asset: 'assets/icon/i_color/jewelry.png',
        screen: const AccessoriesScreen(
          categoryName: 'LOOMA ACCESSORIES',
        ),
      ),
      CategoryItem(
        title: 'Toys',
        asset: 'assets/icon/i_color/toys.png',
        screen: const ToysScreen(categoryName: 'LOOMA TOYS'),
      ),
      CategoryItem(
        title: 'Lingerie',
        asset: 'assets/icon/i_color/lingerie.png',
        screen: const LingerieScreen(
          categoryName: 'LOOMA LINGERIE',
        ),
      ),
      CategoryItem(
        title: 'Gift',
        asset: 'assets/icon/i_color/gift.png',
        screen: const GiftScreen(
          categoryName: 'LOOMA GIFT',
        ),
      ),
      CategoryItem(
        title: 'Perfumes',
        asset: 'assets/icon/perfumes.png',
        screen: const PerfumesScreen(
          categoryName: 'LOOMA  PERFUMES',
        ),
      ),
      CategoryItem(
        title: 'Cosmetics',
        asset: 'assets/icon/cosmetic.png',
        screen: const CosmeticsScreen(
          categoryName: 'LOOMA  COSMETICS',
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextWidget(
                "Categories".tr,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome,
                color: Colors.orangeAccent,
                size: 20,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllCategoriesScreen(),
                    ),
                  );
                },
                child: TextWidget(
                  "SEE MORE".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final item = categories[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item.screen),
                    );
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white10 : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                item.asset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          item.title.tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
