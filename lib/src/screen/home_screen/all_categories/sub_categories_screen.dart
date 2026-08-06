import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final List<Map<String, dynamic>> _gridCategories = [
    // --- CLOTHING ---
    {
      'title': 'Pants',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-tapered-balloon-jeans--FVPO09E2X704_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'PANTS',
    },
    {
      'title': 'Skirts',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-woven-effect-tweed-mini-skirt--FVSJ13KWQ107_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'SKIRT',
      'gender': 'Woman',
    },
    {
      'title': 'Shorts',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-needle-punched-tailored-denim-shorts--HVD77WD9X531_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'SHORTS',
    },
    {
      'title': 'Jackets',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-leather-parka--HVL91EE0I900_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'JACKETS',
    },
    {
      'title': 'Hoodies',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-graphic-jacquard-hoodie--HSN83WSDL610_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'HOODIES',
    },
    {
      'title': 'Shirts',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-embellished-short-sleeved-shirt--HVS72WIKE4M8_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'SHIRTS',
    },
    {
      'title': 'Polo',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-signature-silk-blend-short-sleeved--polo-shirt--HUFN5WUTX6C3_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'POLOS',
    },
    {
      'title': 'T-Shirt',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-long-sleeved-technical-t-shirt-with-reflective-details--HVY68WZ3891F_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'TSHIRTS',
    },
    {
      'title': 'Jean',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-contrast-stitch-utility-jeans--FVPA13BT9001_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'JEANS',
    },
    {
      'title': 'Blouses',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lavalliere-blouse--FUTP14AKM601_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'BLOUSES',
      'gender': 'Woman',
    },
    {
      'title': 'Coats',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-double-face-cashmere-vicuna-coat-with-monogram-leather-details--HUC64E312867_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'COATS',
    },
    {
      'title': 'Activewear',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTudxAzCNMXoS1durGuu61ij-G0CAkNzuJIoNHMWfoXBA&s=10',
      'category': 'CLOTHING',
      'subCategory': 'ACTIVEWEAR',
    },
    {
      'title': 'Suits',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-blason-pont-neuf-suit---HTCF4EOQC900_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'CLOTHING',
      'subCategory': 'SUITS',
    },
    {
      'title': 'Sweatshirt',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-ribbed-knit-zip-up-cardigan--FVKC15499512_PM1_Cropped%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'SWEATSHIRTS',
    },
    {
      'title': 'Cardigans',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-signature-jewel-button-cardigan--FVKG10C7B167_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'CARDIGANS',
    },
    {
      'title': 'Leggings',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-monogram-accent-leggings--FVPA24G72900_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'LEGGINGS',
      'gender': 'Woman',
    },
    {
      'title': 'Joggers',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-leather-tie-mikado-pants--FVPT29B7T900_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'JOGGERS',
    },
    {
      'title': 'Vests',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-tailored-vest--HUE01WBG4739_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'VESTS',
    },
    {
      'title': 'Kids',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-poche-toilette---N40929_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'gender': 'Kids',
    },
    {
      'title': 'Dresses',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-twist-belt-pleated-dress--FVKD08393650_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'CLOTHING',
      'subCategory': 'DRESSES',
      'gender': 'Woman',
    },
    // --- SHOES ---
    {
      'title': 'Sneakers',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-trainer-sneaker--A1UT1CMI54_PM2_Front%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'SNEAKERS',
    },
    {
      'title': 'Heels',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-cube-mule--AWH059SS02_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'HEELS',
      'gender': 'Woman',
    },
    {
      'title': 'Sandals',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-mare-comfort-sandal--AWS069RA95_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'SANDALS',
    },
    {
      'title': 'Boots',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-city-lace-up-boot--BVR008PC02_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'SHOES',
      'subCategory': 'BOOTS',
    },
    {
      'title': 'Flats',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-bella-ballerina--AWP016NM92_PM1_Worn%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'FLATS',
      'gender': 'Woman',
    },
    {
      'title': 'Loafers',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-major-loafer--BWL03SPC02_PM2_Front%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'LOAFERS',
    },
    {
      'title': 'Slippers',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-horizon-slipper--BWL002NA02_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'SLIPPERS',
    },
    {
      'title': 'Sports',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-padel-racket--GI1639_PM1_Cropped%20worn%20view.png?wid=1300&hei=1300',
      'category': 'SHOES',
      'subCategory': 'SPORTS',
    },
    // --- BAGS ---
    {
      'title': 'Handbags',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-vendome-mm--M26501_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'HANDBAGS',
      'gender': 'Woman',
    },
    {
      'title': 'Backpacks',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-discovery-work-backpack--M15259_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'BACKPACKS',
    },
    {
      'title': 'Clutches',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-side-trunk-mm--M24309_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'CLUTCHES',
      'gender': 'Woman',
    },
    {
      'title': 'Wallets',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-pocket-organizer--M14928_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'WALLETS',
    },
    {
      'title': 'Tote Bags',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-multipass-mini--M2A840_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'TOTEBAGS',
    },
    {
      'title': 'Messenger',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-trio-messenger--M28601_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'MESSENGER',
    },
    {
      'title': 'Travel Bags',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-express-travel-gm--M3A362_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'BAGS',
      'subCategory': 'TRAVELBAGS',
    },
    // --- LINGERIE ---
    {
      'title': 'Bras',
      // NOTE: source data had "hhttps://" (double h) here, which would fail
      // to load. Fixed to "https://" below.
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-damier-triangle-bikini-top--FVSW04527004_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'LINGERIE',
      'subCategory': 'BRAS',
      'gender': 'Woman',
    },
    {
      'title': 'Panties',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'PANTIES',
      'gender': 'Woman',
    },
    {
      'title': 'Nightwear',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'NIGHTWEAR',
      'gender': 'Woman',
    },
    {
      'title': 'Bodysuit',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'BODYSUIT',
      'gender': 'Woman',
    },
    {
      'title': 'Shapewear',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'SHAPEWEAR',
      'gender': 'Woman',
    },
    {
      'title': 'Socks',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'SOCKS',
    },
    {
      'title': 'Tights',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnLksFJSE4-Rdp3LlSbqvk-XONebGGzjqwuA&s',
      'category': 'LINGERIE',
      'subCategory': 'TIGHTS',
      'gender': 'Woman',
    },
    // --- ACCESSORIES ---
    {
      'title': 'Jewelry',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-pearl-constellations-bracelet--M03498_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'JEWELRY',
    },
    {
      'title': 'Watches',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-tambour-convergence-automatic-37mm-platinum-and-diamonds--W9PT11_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'WATCHES',
    },
    {
      'title': 'Sunglasses',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-attitude-pilot-sunglasses--Z3302U_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'SUNGLASSES',
    },
    {
      'title': 'Hats',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton--lv-x-tm-cerise-charms-hat--M5086S_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'HATS',
    },
    {
      'title': 'Belts',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-light-pont-neuf-35mm-belt--M4734V_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'BELTS',
    },
    {
      'title': 'Scarves',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-damier-snug-scarf--M96959_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'SCARVES',
    },
    {
      'title': 'Hair',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-mng-resin-headband--M03539_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'HAIR',
      'gender': 'Woman',
    },
    {
      'title': 'Gloves',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-damier-heritage-gloves--M7824I_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'GLOVES',
    },
    {
      'title': 'Clock',
      'image':
      'https://www.bedbathntable.com.au/media/catalog/product/2/1/21706801-P.jpg?optimize=high&fit=bounds&height=&width=',
      'category': 'ACCESSORIES',
      'subCategory': 'CLOCK',
    },
    {
      'title': 'Keychain',
      'image':
      'https://media.gucci.com/style/HEXFBFBFB_South_0_160_640x640/1783421108/838492_JAAJC_8075_001_100_0000_Light.jpg',
      'category': 'ACCESSORIES',
      'subCategory': 'KEYCHAIN',
    },
    {
      'title': 'Sport acc',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-golf-bag--M13925_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'ACCESSORIES',
      'subCategory': 'SPORT',
    },
    // --- OTHERS ---
    {
      'title': 'Gifts',
      'image':
      'https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lip-pencils-and-case--LBE002_PM2_Front%20view.png?wid=730&hei=730',
      'category': 'GIFTS',
    },
    {
      'title': 'Toys',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQXR0FXC2kz0NDHKyABGcecPgKVKtkwQgBhNTiLhlKwuQ&s=10',
      'category': 'GIFTS',
      'subCategory': 'TOYS',
      'gender': 'Kids',
    },
    {
      'title': 'Bedding',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvCa4YNSS6eIYRDDTtLv_osjrwnwWvwtx02rdhBDTAXg&s=10',
      'category': 'HOME',
      'subCategory': 'BEDDING',
    },
    {
      'title': 'Lamp',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRtXhJjESn_82BGdW8RRqpCeLQEUm5z7BwPusMcjU6XQ&s=10',
      'category': 'HOME',
      'subCategory': 'LAMP',
    },
    {
      'title': 'Kitchen',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzwO1ZAydey_Z8gt9dAUJ_F_7uFAa0GJL2Xm_rkIyD-g&s=10',
      'category': 'HOME',
      'subCategory': 'KITCHEN',
    },
    {
      'title': 'Thumbler',
      'image':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQH23s_SzKYzP3G9RHuCye7eodxWANN0RaxziUncPPBUA&s=10',
      'category': 'HOME',
      'subCategory': 'THUMBLER',
    },
  ];
  void _navigateToSubCategory({
    required BuildContext context,
    required String title,
    String? category,
    String? subCategory,
    String? gender,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversalProductScreen(
          title: title,
          category: category,
          subCategory: subCategory,
          initialGender: gender,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: TextWidget(
          'All Categories'.tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColor.black,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: CartBadge(),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _gridCategories.length,
        itemBuilder: (context, index) {
          return _buildGridCategoryItem(_gridCategories[index], isDark, index);
        },
      ),
    );
  }

  Widget _buildGridCategoryItem(
      Map<String, dynamic> item,
      bool isDark,
      int index,
      ) {
    final String? gender = item['gender'] as String?;
    final String title = item['title'] as String;
    final String imageUrl = item['image'] as String;

    return GestureDetector(
      onTap: () => _navigateToSubCategory(
        context: context,
        title: title,
        category: item['category'] as String?,
        subCategory: item['subCategory'] as String?,
        gender: gender,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? Colors.white10 : Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: isDark ? Colors.white10 : Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_outlined,
                          color: isDark ? Colors.white24 : Colors.grey[400],
                          size: 30,
                        ),
                        const SizedBox(height: 4),
                        TextWidget(
                          "Image Error",
                          fontSize: 8,
                          color: isDark ? Colors.white24 : Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: TextWidget(
                    title.tr, // title is now a real String, .tr resolves fine
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}