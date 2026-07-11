
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/home_screen/categories/bag_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/gift.dart';
import 'package:shopping_app/src/screen/home_screen/categories/lingerie_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/toys.dart';
import 'package:shopping_app/src/screen/home_screen/categories/watch_screen.dart';
import 'package:shopping_app/src/screen/home_screen/style_product/style_product_screen.dart';
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
        screen: ClothesScreen(
          categoryName: 'LOOMA CLOTHES',
          clothes: clothes,
          polos: polos,
          activewear: activewear,
          jackets: jackets,
          jeans: jeans,
          joggers: joggers,
          leggings: leggings,
          pants: pants,
          shirts: shirts,
          skirt: skirt,
          suits: suits,
          sweatshirts: sweatshirts,
          tShirts: tShirts,
          blouses: blouses,
          cardigans: cardigans,
          coats: coats,
          dresses: dresses,
          essentialHoodies: hoodies,
          shorts: shorts,
          skirts: skirt,
        ),
      ),
      CategoryItem(
        title: 'Shoes',
        asset: 'assets/icon/i_color/shoes.png',
        screen: ShoesScreen(
          categoryName: 'LOOMA SHOES',
          shoes: shoes,
          shoesBoots: shoesBoots,
          heeled: heeled,
          flats: flats,
          loafers: loafers,
          sandals: sandals,
          slippers: slippers,
          sneakers: sneakers,
          sportsShoes: sportsShoes,
        ),
      ),
      CategoryItem(
        title: 'Bags',
        asset: 'assets/icon/i_color/pag.png',
        screen: BagesScreen(
          categoryName: 'LOOMA BAGS',
          bags: bags,
          backpacks: backpacks,
          clutches: clutches,
          handbags: handbags,
          messengerBags: messengerBags,
          toteBags: toteBags,
          travelBags: travelBags,
          wallets: wallets,
        ),
      ),
      CategoryItem(
        title: 'Watch',
        asset: 'assets/icon/i_color/watch.png',
        screen: WatchScreen(categoryName: 'LOOMA WATCH', watch: watch),
      ),
      CategoryItem(
        title: 'Accessories',
        asset: 'assets/icon/i_color/jewelry.png',
        screen: AccessoriesScreen(
          categoryName: 'LOOMA ACCESSORIES',
          accessories: accessories,
          jewelry: jewelry,
          sunglasses: sunglasses,
          hats: hats,
          belts: belts,
          scarves: scarves,
          hairAccessories: hairAccessories,
          gloves: gloves,
          watches: watches,
        ),
      ),
      CategoryItem(
        title: 'Toys',
        asset: 'assets/icon/i_color/toys.png',
        screen: ToysScreen(categoryName: 'LOOMA TOYS', toys: toys),
      ),
      CategoryItem(
        title: 'Lingerie',
        asset: 'assets/icon/i_color/lingerie.png',
        screen: LingerieScreen(
          categoryName: 'LOOMA LINGERIE',
          lingerie: lingerie,
          bodysuitProduct: bodysuitProduct,
          nightwearProducts:nightwearProducts,
          pantyProducts: pantyProducts,
          shapewearProducts: shapewearProducts,
          sockProducts: sockProducts,
          tightsProducts: tightsProducts,
          braProducts: [],
          bridalLingerieProducts:[],
        ),
      ),
      CategoryItem(
        title: 'Gift',
        asset: 'assets/icon/i_color/gift.png',
        screen: GiftScreen(
          categoryName: 'LOOMA GIFT',
          gift: gift,
          birthdayGifts: birthdayGift ,
          anniversaryGifts: [],
          weddingGifts: [],
          babyGifts: [],
          valentineGifts: [],
          graduationGifts: [],
          personalizedGifts: [],
        ),
      ),
      CategoryItem(
        title: 'Perfumes',
        asset: 'assets/icon/perfumes.png',
        screen: PerfumesScreen(
          categoryName: 'LOOMA  PERFUMES',
          perfumesData: perfumesData,
          womenPerfumes: [],
          menPerfumes: [],
          unisexPerfumes: [],
          bodyMist: [],
          perfumeSets: [],
          deodorants: [],
          luxuryPerfumes: [],
        ),
      ),
      CategoryItem(
        title: 'Cosmetics',
        asset: 'assets/icon/cosmetic.png',
        screen: CosmeticsScreen(
          categoryName: 'LOOMA  COSMETICS',
          cosmeticsData: cosmeticsData,
          skincare: skincare,
          makeup: makeup,
          haircare: haircare,
          fragrances: fragrances,
          nailCare: nailCare,
          beautyTools:beautyTools,
          personalCare: [],
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
                "Categories",
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
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StyleProductScreen(imageUrl: ''),
                    ),
                  );
                },
                icon: Icon(
                  Icons.dashboard_rounded,
                  size: 20,
                  color: isDark ? Colors.white : Colors.black,
                ),
                label: TextWidget(
                  "Style",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 125,
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
                          item.title.toUpperCase(),
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
