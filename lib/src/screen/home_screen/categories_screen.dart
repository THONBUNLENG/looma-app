import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/sub_categories_screen.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextWidget(
                  "Categories".tr,
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
                      builder: (context) => const SubCategoriesScreen(),
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
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.62, // Slightly taller for better proportions
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversalProductScreen(
                      title: item['title'],
                      category: item['category'],
                      subCategory: item['subCategory'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item['image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDark ? Colors.white10 : Colors.grey[200],
                          child: LoadingWidget.loadingCenterWidget(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image, size: 24, color: Colors.black45),
                              const SizedBox(height: 4),
                              TextWidget(
                                item['title'],
                                fontSize: 8, color: Colors.black45,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Background Gradient for text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Category Title Overlay (Pill Design)
                      Positioned(
                        bottom: 12,
                        left: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                          child: TextWidget(
                            item['title'].toString().tr.toUpperCase(),
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

final List<Map<String, dynamic>> categories = [
  {
    'title': 'LIFESTYLE',
    'image': 'https://en.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-poker-case--M20077_PM2_Front%20view.png?wid=1300&hei=1300',
    'category': 'CLOTHING',
  },
  {
    'title': 'SPORTLIFE',
    'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5u9dEatZqB1-Rl778qKNCBSpZ98QAier5VYKN9neqmg&s=10',
    'category': 'CLOTHING',
    'subCategory': 'ACTIVEWEAR',
  },
  {
    'title': 'SMART CASUAL',
    'image': 'https://en.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-damier-classic-denim-jacket---HSA41WGRT650_PM1_Cropped%20view.png?wid=1300&hei=1300',
    'category': 'CLOTHING',
  },
  {
    'title': 'BAGS',
    'image': 'https://en.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-all-in-one-mm--M25860_PM1_Worn%20view.png?wid=1300&hei=1300',
    'category': 'BAGS',
  },
  {
    'title': 'SOFT LIVING',
    'image': 'https://en.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-mini-dopp-kit--M29547_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
    'category': 'ACCESSORIES',
  },
  {
    'title': 'SHOES',
    'image': 'https://en.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-trainer-sneaker--AQ9U2ADN02_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
    'category': 'SHOES',
  },
];