import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/boots_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/flats_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/heels_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/loafers_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/sandals_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/slippers_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/sneakers_screen.dart';
import 'package:shopping_app/src/screen/home_screen/all_categories/shoes_products/sports_screen.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';
import '../../list_url.dart';
import 'accessories_products/belts_screen.dart';
import 'accessories_products/gloves_screen.dart';
import 'accessories_products/hair_screen.dart';
import 'accessories_products/hats_screen.dart';
import 'accessories_products/jewelry_screen.dart';
import 'accessories_products/scarves_screen.dart';
import 'accessories_products/sunglasses_screen.dart';
import 'accessories_products/watches_screen.dart';
import 'bags_products/backpacks_screen.dart';
import 'bags_products/clutches_screen.dart';
import 'bags_products/handbags_screen.dart';
import 'bags_products/messenger_screen.dart';
import 'bags_products/tote_bags_screen.dart';
import 'bags_products/travel_bags_screen.dart';
import 'bags_products/wallets_screen.dart';
import 'clothing_products/activewear_screen.dart';
import 'clothing_products/blouses_screen.dart';
import 'clothing_products/cardigans_screen.dart';
import 'clothing_products/coats_screen.dart';
import 'clothing_products/dresse_screen.dart';
import 'clothing_products/hoodies_screen.dart';
import 'clothing_products/jackets_screen.dart';
import 'clothing_products/jeans_screen.dart';
import 'clothing_products/joggers_screen.dart';
import 'clothing_products/leggings_screen.dart';
import 'clothing_products/pants_products_screen.dart';
import 'clothing_products/polo_screen.dart';
import 'clothing_products/shirts_screen.dart';
import 'clothing_products/shorts_screen.dart';
import 'clothing_products/skirts_screen.dart';
import 'clothing_products/suits_screen.dart';
import 'clothing_products/sweatshirts_screen.dart';

import 'clothing_products/t_shirts_screen.dart';
import 'clothing_products/vest_screen.dart';
import 'just_for_you_all.dart';
import 'lingerie_products/bodysuits_screen.dart';
import 'lingerie_products/bras_screen.dart';
import 'lingerie_products/nightwear_screen.dart';
import 'lingerie_products/panties_screen.dart';
import 'lingerie_products/shapewear_screen.dart';
import 'lingerie_products/socks_screen.dart';
import 'lingerie_products/tights_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  int selectedGenderIndex = 0;

  void _navigateToSubCategory(BuildContext context, String subName) {
    final String key = subName
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('-', '');

    final Map<String, Widget Function(String)> routes = {
      'dresses': (name) => DresseScreen(categoryName: name, dresses: dresses),
      'pants': (name) => PantsProductsScreen(categoryName: name, pants: pants),
      "skirts": (name) => SkirtsScreen(categoryName: name, skirts: skirt),
      'shorts': (name) => ShortsScreen(categoryName: name, shorts: shorts),
      'jackets': (name) => JacketsScreen(categoryName: name, jackets: jackets),
      'hoodies': (name) =>
          HoodiesScreen(categoryName: name, essentialHoodies: hoodies),
      'shirts': (name) => ShirtsScreen(categoryName: name, shirts: shirts),
      'polo': (name) => PoloScreen(categoryName: name, polos: polos),
      'tshirt': (name) => TshirtsScreen(categoryName: name, tShirts: tShirts),
      'jean': (name) => JeansScreen(categoryName: name, jeans: jeans),
      'blouses': (name) => BlousesScreen(categoryName: name, blouses: blouses),
      'coats': (name) => CoatsScreen(categoryName: name, coats: coats),
      'activewear': (name) =>
          ActivewearScreen(categoryName: name, activewear: activewear),
      'suits': (name) => SuitsScreen(categoryName: name, suits: suits),
      'sweatshirt': (name) =>
          SweatshirtsScreen(categoryName: name, sweatshirts: sweatshirts),
      'cardigans': (name) =>
          CardigansScreen(categoryName: name, cardigans: cardigans),
      'leggings': (name) =>
          LeggingsScreen(categoryName: name, leggings: leggings),
      'joggers': (name) => JoggersScreen(categoryName: name, joggers: joggers),
      'vests': (name) => VestScreen(categoryName: name, vests: vests),



      // --- Shoes ---
      'sneakers': (name) =>
          SneakersScreen(categoryName: name, sneakers: sneakers),
      'heels': (name) => HeelsScreen(categoryName: name, heels: heeled),
      'sandals': (name) => SandalsScreen(categoryName: name, sandals: sandals),
      'boots': (name) =>
          BootsScreen(categoryName: name, shoesBoots: shoesBoots),
      'flats': (name) => FlatsScreen(categoryName: name, flats: flats),
      'loafers': (name) => LoafersScreen(categoryName: name, loafers: loafers),
      'slippers': (name) =>
          SlippersScreen(categoryName: name, slippers: slippers),
      'sports': (name) =>
          SportsScreen(categoryName: name, sportsShoes: sportsShoes),

      // --- Bags ---
      'handbags': (name) =>
          HandbagsScreen(categoryName: name, handbags: handbags),
      'backpacks': (name) =>
          BackpacksScreen(categoryName: name, backpacks: backpacks),
      'clutches': (name) =>
          ClutchesScreen(categoryName: name, clutches: clutches),
      'wallets': (name) => WalletsScreen(categoryName: name, wallets: wallets),
      'totebags': (name) =>
          ToteBagsScreen(categoryName: name, toteBags: toteBags),
      'messenger': (name) =>
          MessengerScreen(categoryName: name, messengerBags: messengerBags),
      'travelbags': (name) =>
          TravelBagsScreen(categoryName: name, travelBags: travelBags),

      // --- Lingerie ---
      'bras': (name) =>
          BrasScreen(categoryName: name, braProducts: braProducts),
      'panties': (name) =>
          PantiesScreen(categoryName: name, pantyProducts: pantyProducts),
      'nightwear': (name) => NightwearScreen(
        categoryName: name,
        nightwearProducts: nightwearProducts,
      ),
      'bodysuit': (name) =>
          BodysuitsScreen(categoryName: name, bodysuitProduct: bodysuitProduct),
      'shapewear': (name) => ShapewearScreen(
        categoryName: name,
        shapewearProducts: shapewearProducts,
      ),
      'socks': (name) =>
          SocksScreen(categoryName: name, sockProducts: sockProducts),
      'tights': (name) =>
          TightsScreen(categoryName: name, tightsProducts: tightsProducts),
      // --- Accessories ---
      'jewelry': (name) =>
          JewelryScreen(categoryName: name, accessories: jewelry),
      'watches': (name) => WatchesScreen(categoryName: name, watches: watches),
      'sunglasses': (name) =>
          SunglassesScreen(categoryName: name, sunglasses: sunglasses),
      'hats': (name) => HatsScreen(categoryName: name, hats: hats),
      'belts': (name) => BeltsScreen(categoryName: name, belts: belts),
      'scarves': (name) => ScarvesScreen(categoryName: name, scarves: scarves),
      'hair': (name) =>
          HairScreen(categoryName: name, hairAccessories: hairAccessories),
      'gloves': (name) => GlovesScreen(categoryName: name, gloves: gloves),
    };

    if (routes.containsKey(key)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => routes[key]!(subName)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            'Category "$subName" is coming soon!'.tr,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColor.white,

      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: isDark ? Colors.white : AppColor.black),
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? const Color(0xFF121212) : AppColor.white,
        elevation: 0,
        title: TextWidget(
          'All CATEGORIES'.tr.toUpperCase(),
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColor.black,
        ),
        actions: const [
          CartBadge(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryItem(
                  title: 'Clothing',
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdyeTpQSldzsxE4nmXiwTxiaAILU3bMLFRsA&s',
                  isDark: isDark,
                  subCategories: [
                    'Dresses',
                    'Pants',
                    'Skirts',
                    'Shorts',
                    'Jackets',
                    'Hoodies',
                    'Shirts',
                    'Polo',
                    'T-Shirt',
                    'Jean',
                    'Blouses',
                    'Coats',
                    'Activewear',
                    'Suits',
                    'Sweatshirt',
                    'Cardigans',
                    'Leggings',
                    'Joggers',
                    'Vests'
                  ],
                ),
                _buildCategoryItem(
                  title: 'Shoes',
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmY-rIrR7sHvXlDii4hQfkRmlOJKIMbLehaQ&s',
                  isDark: isDark,
                  subCategories: [
                    'Sneakers',
                    'Heels',
                    'Sandals',
                    'Boots',
                    'Flats',
                    'Loafers',
                    'Slippers',
                    'Sports',
                  ],
                ),
                _buildCategoryItem(
                  title: 'Bags',
                  image:
                      'https://image.shutterstock.com/image-photo/purple-color-luxury-womens-bag-250nw-2415657003.jpg',
                  isDark: isDark,
                  subCategories: [
                    'Handbags',
                    'Backpacks',
                    'Clutches',
                    'Wallets',
                    'Tote Bags',
                    'Messenger',
                    'Travel Bags',
                  ],
                ),
                _buildCategoryItem(
                  title: 'Lingerie',
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
                  isDark: isDark,
                  subCategories: [
                    'Bras',
                    'Panties',
                    'Nightwear',
                    'Bodysuit',
                    'Shapewear',
                    'Socks',
                    'Tights',
                  ],
                ),
                _buildCategoryItem(
                  title: 'Accessories',
                  image:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhvfVGkQjek3qd605V9KvpK54eR-tGKdznlg&s',
                  isDark: isDark,
                  subCategories: [
                    'Jewelry',
                    'Watches',
                    'Sunglasses',
                    'Hats',
                    'Belts',
                    'Scarves',
                    'Hair',
                    'Gloves',
                  ],
                ),
                _buildJustForYou(context, isDark),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCategoryItem({
    required String title,
    required String image,
    required bool isDark,
    List<String>? subCategories,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          title: TextWidget(
            title.tr,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColor.black,
          ),
          iconColor: AppColor.primaryColor,
          collapsedIconColor: isDark ? Colors.white54 : Colors.grey,
          children: [
            if (subCategories != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: subCategories.length,
                  itemBuilder: (context, index) {
                    final subName = subCategories[index];
                    return InkWell(
                      onTap: () => _navigateToSubCategory(context, subName),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : AppColor.grey100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextWidget(
                          subName.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : AppColor.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJustForYou(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                JustForYouAll(justForYouData: justForYouData, categoryName: ''),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl:
                    'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=1000&auto=format&fit=crop',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  TextWidget(
                    'Just for You'.tr,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColor.black,
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.stars,
                    color: AppColor.primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColor.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
