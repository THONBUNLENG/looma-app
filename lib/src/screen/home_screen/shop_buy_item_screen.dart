import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:shopping_app/src/screen/main_screen/main_holder.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class ShopBuyItemScreen extends StatelessWidget {
  const ShopBuyItemScreen({super.key, required this.categoryName});

  final String categoryName;

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Tops', 'image': 'assets/icon/i_buy_item/tops.png', 'category': 'CLOTHING', 'subCategory': 'POLOS'},
    {'title': 'Jeans', 'image': 'assets/icon/i_buy_item/jeans.png', 'category': 'CLOTHING', 'subCategory': 'JEANS'},
    {'title': 'Dresses', 'image': 'assets/icon/i_buy_item/dresses.png', 'category': 'CLOTHING', 'subCategory': 'DRESSES'},
    {'title': 'Shoes', 'image': 'assets/icon/i_buy_item/shoes.png', 'category': 'SHOES'},
    {'title': 'Jackets', 'image': 'assets/icon/i_buy_item/jackets.png', 'category': 'CLOTHING', 'subCategory': 'JACKETS'},
    {'title': 'Vests', 'image': 'assets/icon/i_buy_item/vests.png', 'category': 'CLOTHING', 'subCategory': 'VESTS'},
    {'title': 'Skirts', 'image': 'assets/icon/i_buy_item/skirts.png', 'category': 'CLOTHING', 'subCategory': 'SKIRT'},
    {'title': 'Shorts', 'image': 'assets/icon/i_buy_item/shorts.png', 'category': 'CLOTHING', 'subCategory': 'SHORTS'},
    {'title': 'Hoodies', 'image': 'assets/icon/i_buy_item/hoodies.png', 'category': 'CLOTHING', 'subCategory': 'HOODIES'},
    {'title': 'More', 'image': 'assets/icon/more.png', 'isMore': true},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Promotion Banner
        Container(
          width: double.infinity,
          height: 160,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : const Color(0xFFE0F7FA),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      'FREE DELIVERY\nON ORDERS\nOVER \$160+'.tr.toUpperCase(),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                      'T&Cs APPLY'.tr.toUpperCase(),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -10,
                bottom: 0,
                child: Image.asset(
                  'assets/image/delivery.png',
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.local_shipping,
                      size: 60,
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Shop by items".tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColor.white : AppColor.black,
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            final bool isMore = item['isMore'] ?? false;

            return InkWell(
              onTap: () {
                if (isMore) {
                  MainHolder.of(context)?.setSelectedIndex(4);
                  return;
                }
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversalProductScreen(
                      title: item['title'].toString(),
                      category: item['category'],
                      subCategory: item['subCategory'],
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : AppColor.grey100,
                      shape: isMore ? BoxShape.circle : BoxShape.rectangle,
                      borderRadius: isMore ? null : BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        item['image'],
                        height: isMore ? 24 : 36,
                        width: isMore ? 24 : 36,
                        fit: BoxFit.contain,
                        color: isDark ? Colors.white : null,
                        colorBlendMode: isDark ? BlendMode.srcIn : BlendMode.dst,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          isMore ? Icons.more_horiz : Icons.category_outlined,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    item['title'].toString().tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
