import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/clothing_products/dresse_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/clothing_products/hoodies_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/clothing_products/jackets_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/clothing_products/jeans_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/clothing_products/polo_screen.dart';
import 'package:shopping_app/src/screen/list_url.dart';
import 'package:shopping_app/src/screen/main_screen/main_holder.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import 'all_categories/clothing_products/shorts_screen.dart';
import 'all_categories/clothing_products/skirts_screen.dart';
import 'all_categories/clothing_products/vest_screen.dart';
import 'categories/shoes_screen.dart';

class ShopBuyItemScreen extends StatelessWidget {
  const ShopBuyItemScreen({super.key, required this.categoryName});

  final String categoryName;

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Polo', 'image': 'assets/icon/i_buy_item/tops.png'},
    {'title': 'Jeans', 'image': 'assets/icon/i_buy_item/jeans.png'},
    {'title': 'Dresses', 'image': 'assets/icon/i_buy_item/dresses.png'},
    {'title': 'Shoes', 'image': 'assets/icon/i_buy_item/shoes.png'},
    {'title': 'Jackets', 'image': 'assets/icon/i_buy_item/jackets.png'},
    {'title': 'Vests', 'image': 'assets/icon/i_buy_item/vests.png'},
    {'title': 'Skirts', 'image': 'assets/icon/i_buy_item/skirts.png'},
    {'title': 'Shorts', 'image': 'assets/icon/i_buy_item/shorts.png'},
    {'title': 'Hoodies', 'image': 'assets/icon/i_buy_item/hoodies.png'},
    {'title': 'More', 'image': 'assets/icon/more.png', 'isMore': true},
  ];

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
                "Shop by items".tr,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColor.white : AppColor.black,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => (),
              //       ),
              //     );
              //   },
              //   child: TextWidget(
              //     "SEE MORE",
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: isDark ? Colors.white70 : Colors.black54,
              //   ),
              // ),
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
                Widget? targetScreen;
                final String title = item['title'].toString().toLowerCase();

                switch (title) {
                  case 'polo':
                    targetScreen = PoloScreen(
                      categoryName: categoryName,
                      polos: polos,
                    );
                    break;
                  case 'jeans':
                    targetScreen = JeansScreen(
                      categoryName: categoryName,
                      jeans: jeans,
                    );
                    break;
                  case 'dresses':
                    targetScreen = DresseScreen(
                      categoryName: categoryName,
                      dresses: dresses,
                    );
                    break;
                  case 'shoes':
                    targetScreen = ShoesScreen(
                      categoryName: 'LOOMA SHOES',
                      // shoes: shoes,
                      // shoesBoots: shoesBoots,
                      // heeled: heeled,
                      // flats: flats,
                      // loafers: loafers,
                      // sandals: sandals,
                      // slippers: slippers,
                      // sneakers: sneakers,
                      // sportsShoes: sportsShoes,
                    );
                    break;
                  case 'jackets':
                    targetScreen = JacketsScreen(
                      categoryName: categoryName,
                      jackets: jackets,
                    );
                    break;
                  case 'vests':
                    targetScreen = VestScreen(
                      categoryName: categoryName, vests: vests,
                    );
                    break;
                  case 'skirts':
                    targetScreen = SkirtsScreen(
                      categoryName: categoryName,
                      skirts: skirt,
                    );
                    break;
                  case 'shorts':
                    targetScreen = ShortsScreen(
                      categoryName: categoryName,
                      shorts: shorts,
                    );
                    break;
                  case 'hoodies':
                    targetScreen = HoodiesScreen(
                      categoryName: categoryName,
                      essentialHoodies: hoodies,
                    );
                    break;
                  default:
                    debugPrint("No screen defined for: $title");
                }

                if (targetScreen != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen!),
                  );
                }
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

        // Promotion Banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 20),
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
        const SizedBox(height: 20),
      ],
    );
  }
}
