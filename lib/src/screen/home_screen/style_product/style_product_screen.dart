import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';

import 'package:flutter/material.dart';



import 'package:shopping_app/src/widget/text_widget.dart';



import '../../../../constants/app_color.dart';



import '../../../../constants/string_extension.dart';




class StyleProductScreen extends StatefulWidget {
  final String imageUrl;

  const StyleProductScreen({super.key, required this.imageUrl});

  @override
  State<StyleProductScreen> createState() => _StyleProductScreenState();
}

class _StyleProductScreenState extends State<StyleProductScreen> {
  String selectedStyle = "ALL";

  List<Map<String, String>> get allProducts {
    final List<Map<String, String>> combined = [];

    styleProduct.forEach((styleName, productList) {
      for (final product in productList) {
        combined.add({...product, 'style': styleName});
      }
    });

    return combined;
  }

  List<Map<String, String>> get currentProducts {
    return selectedStyle == "ALL"
        ? allProducts
        : (styleProduct[selectedStyle] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;
    final textColor = isDark ? Colors.white : AppColor.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
        title: TextWidget(
          "Styles".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(125),
          child: Column(
            children: [
              _buildSearchBar(isDark),
              _buildStyleFilters(isDark),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSectionHeader(isDark),
          Expanded(child: _buildProductGrid(isDark)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.grey[850] : Colors.grey[100];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  TextWidget(
                    "Search style products...".tr,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.tune, size: 20, color: textColor),
          const SizedBox(width: 4),
          TextWidget(
            "filter".tr,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStyleFilters(bool isDark) {
    final filters = [
      "ALL",
      "Old Money",
      "Streetwear",
      "Minimalist",
      "Vintage",
      "Casual",
      "Luxury",
      "Y2K",
    ];

    return SizedBox(
      height: 58,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter == selectedStyle;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStyle = filter;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColor.primaryColor
                    : (isDark ? Colors.white10 : AppColor.grey100),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextWidget(
                filter.tr,
                fontWeight: FontWeight.bold,
                color: selected
                    ? AppColor.white
                    : (isDark ? Colors.white70 : AppColor.black),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          TextWidget(
            selectedStyle == "ALL" ? "All Styles".tr : "$selectedStyle ${'Style'.tr}",
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : AppColor.grey100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextWidget(
              "${currentProducts.length} ${'items'.tr}",
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(bool isDark) {
    final products = currentProducts;

    if (products.isEmpty) {
      return Center(
        child: TextWidget(
          "No items found".tr,
          color: isDark ? Colors.white38 : AppColor.grey,
          fontSize: 16,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        final item = products[index];

        final label = selectedStyle == "ALL"
            ? (item['style'] ?? "New")
            : selectedStyle;

        return StyleProductCard(
          imageUrl: item['image'] ?? '',
          title: item['title'] ?? '',
          price: item['price'] ?? '',
          oldPrice: item['oldPrice'] ?? '',
          styleLabel: label,
          isDark: isDark,
        );
      },
    );
  }
}

class StyleProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String oldPrice;
  final String styleLabel;
  final bool isDark;

  const StyleProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.styleLabel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColor.grey100,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: isDark ? Colors.white10 : AppColor.grey100,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, _, _) => Icon(
                        Icons.broken_image_outlined,
                        color: isDark ? Colors.white24 : AppColor.grey200,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextWidget(
                        styleLabel,
                        color: AppColor.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "LOOMA",
                fontSize: 13,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              const SizedBox(height: 4),
              TextWidget(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColor.black,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  TextWidget(
                    price,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      oldPrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final Map<String, List<Map<String, String>>> styleProduct = {
  "Old Money": [
    {
      'image':
          'https://rokbucket.rokomari.io/ProductNew20190903/260X372/Manfare_Half_Zipper_Old_Money_Sweater_Pr-Manfare-a4ab1-455175.png',
      'title': 'Stone Cotton Sweatshirt',
      'price': '\$46.80',
      'oldPrice': '\$52.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/055/756/338/non_2x/blue-polo-shirt-mockup-isolated-on-transparent-background-free-png.png',
      'title': 'Mercerized Cotton Polo',
      'price': '\$17.82',
      'oldPrice': '\$19.80',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/034/928/384/non_2x/ai-generated-linen-pants-clip-art-free-png.png',
      'title': 'Linen Tailored Trousers',
      'price': '\$85.50',
      'oldPrice': '\$95.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/047/601/587/non_2x/cream-colored-chunky-knit-cable-sweater-with-long-sleeves-cut-out-stock-png.png',
      'title': 'Ivory Cable Knit Sweater',
      'price': '\$112.00',
      'oldPrice': '\$140.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/055/985/382/small_2x/formal-black-loafers-with-subtle-texture-isolated-on-transparent-background-free-png.png',
      'title': 'Classic Leather Loafers',
      'price': '\$150.00',
      'oldPrice': '\$185.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/059/534/981/small/stylish-double-vent-blazer-isolated-on-a-transparent-background-png.png',
      'title': 'Navy Double-Breasted Blazer',
      'price': '\$210.00',
      'oldPrice': '\$250.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/044/607/356/small_2x/classic-oxford-shirt-on-transparent-background-png.png',
      'title': 'Oxford Button-Down Shirt',
      'price': '\$58.50',
      'oldPrice': '\$65.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/059/490/390/small/stylish-beige-chino-shorts-isolated-on-transparent-background-png.png',
      'title': 'Beige Chino Shorts',
      'price': '\$34.20',
      'oldPrice': '\$38.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/036/290/283/non_2x/ai-generated-cardigan-with-transparent-background-ai-png.png',
      'title': 'Cashmere V-Neck Jumper',
      'price': '\$198.00',
      'oldPrice': '\$220.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/059/490/623/small_2x/elegant-red-silk-tie-with-subtle-diagonal-stripes-on-transparent-background-classic-formal-accessory-for-business-and-special-occasions-png.png',
      'title': 'Silk Striped Tie',
      'price': '\$45.00',
      'oldPrice': '\$50.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/055/213/405/small/brown-coat-mockup-for-fashion-presentations-transparent-background-png.png',
      'title': 'Wool Overcoat Camel',
      'price': '\$285.00',
      'oldPrice': '\$320.00',
    },
    {
      'image':
          'https://www.luistrenker.com/media/d7/25/9d/1768309369/K46207-7700-1.png?ts=1768309369',
      'title': 'Slim Fit Herringbone Vest',
      'price': '\$72.00',
      'oldPrice': '\$80.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/060/240/641/small/white-dress-shirt-isolated-classic-button-down-shirt-long-sleeve-formal-top-business-attire-on-transparent-background-clean-apparel-for-professionals-png.png',
      'title': 'White Poplin Shirt',
      'price': '\$49.50',
      'oldPrice': '\$55.00',
    },
    {
      'image':
          'https://cdn.shopify.com/s/files/1/0730/0929/9798/files/SandersPoloSnuffSuedeHiTopBootsFront.png?v=1709646095&width=1200&height=1200&crop=center',
      'title': 'Suede Chelsea Boots',
      'price': '\$162.00',
      'oldPrice': '\$180.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/048/558/754/non_2x/belts-belts-on-a-isolated-background-belts-belts-against-transparent-background-free-png.png',
      'title': 'Leather Dress Belt',
      'price': '\$36.00',
      'oldPrice': '\$40.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/070/921/105/small/premium-black-leather-jacket-for-men-sleek-and-fashionable-design-png.png',
      'title': 'Lightweight Harrington Jacket',
      'price': '\$95.00',
      'oldPrice': '\$115.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/131030119_BKM_1.png?v=1754529826&width=1200',
      'title': 'Breton Striped Longsleeve',
      'price': '\$42.00',
      'oldPrice': '\$48.00',
    },
    {
      'image':
          'https://baudoinlange.com/cdn/shop/files/01-Sagan-Classic-Tassel-Loafers-in-Moyen-Brown-Asteria-Suede.png?v=1759317049',
      'title': 'Tassel Loafers Burgundy',
      'price': '\$175.50',
      'oldPrice': '\$195.00',
    },
    {
      'image':
          'https://assets.digitalcontent.marksandspencer.app/image/upload/w_600,h_780,q_auto,f_auto,e_sharpen/SD_03_T28_5032M_HP_X_EC_94',
      'title': 'Piqué Cotton Polo Grey',
      'price': '\$31.50',
      'oldPrice': '\$35.00',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1516826957135-700dedea698c?q=80&w=600&h=600&fit=crop',
      'title': 'Pleated Wool Trousers',
      'price': '\$108.00',
      'oldPrice': '\$120.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/073/209/451/small/pleated-trousers-gray-herringbone-fabric-front-view-studio-shot-png.png',
      'title': 'Cotton Trench Coat',
      'price': '\$234.00',
      'oldPrice': '\$260.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/057/732/826/small/beautiful-notch-lapel-blazer-isolated-on-transparent-background-png.png',
      'title': 'Checkered Blazer Wool',
      'price': '\$195.00',
      'oldPrice': '\$230.00',
    },
    {
      'image':
          'https://rubynz.com/cdn/shop/files/MERCIJEANWHITEFS.png?v=1698196061&width=1200',
      'title': 'White Denim Jeans',
      'price': '\$76.50',
      'oldPrice': '\$85.00',
    },
    {
      'image':
          'https://yusentrims.com/wp-content/uploads/2025/06/11-300x300.png',
      'title': 'Braided Elastic Belt',
      'price': '\$22.50',
      'oldPrice': '\$25.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/051/715/639/non_2x/brown-knitted-scarf-isolated-on-transparent-background-png.png',
      'title': 'Merino Wool Scarf',
      'price': '\$54.00',
      'oldPrice': '\$60.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/058/695/940/small/gray-dress-shirt-mockup-for-mens-fashion-on-transparent-background-png.png',
      'title': 'Grandad Collar Shirt',
      'price': '\$47.70',
      'oldPrice': '\$53.00',
    },
    {
      'image':
          'https://cdn.sanity.io/images/5l2ep0d7/production/dcdf49f74ee980fa853256eb6e5366c2ae4481a7-500x491.webp?w=3840&q=80&auto=format&fit=max',
      'title': 'Brown Suede Jacket',
      'price': '\$315.00',
      'oldPrice': '\$350.00',
    },
    {
      'image':
          'https://resortfinest.com/cdn/shop/files/2793-1700_05.png?v=1698314560&width=1445',
      'title': 'Turtle Neck Cashmere',
      'price': '\$126.00',
      'oldPrice': '\$140.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/046/592/936/non_2x/watch-isolated-on-transparent-background-free-png.png',
      'title': 'Stainless Steel Watch',
      'price': '\$450.00',
      'oldPrice': '\$500.00',
    },
    {
      'image':
          'https://www.schoffelcountry.com/cdn/shop/files/schoffel-mens-marlow-gilet-20-3016-8880-navy-cutout-01_bd4b99e9-dca6-4c65-8a5a-fd6728f64066.png?v=1774944204&width=2000',
      'title': 'Quilted Gilet Navy',
      'price': '\$88.20',
      'oldPrice': '\$98.00',
    },
    {
      'image':
          'https://www.cloveandtwine.com/cdn/shop/products/cream-custom-canvas-weekend-bag-bags-29878834430040.png?v=1662663302',
      'title': 'Canvas Weekender Bag',
      'price': '\$135.00',
      'oldPrice': '\$150.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/074/533/757/small/classic-round-tortoiseshell-sunglasses-with-dark-lenses-for-eye-protection-isolated-on-transparent-background-png.png',
      'title': 'Tortoiseshell Sunglasses',
      'price': '\$117.00',
      'oldPrice': '\$130.00',
    },
  ],
  "Streetwear": [
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/055/686/717/small/soft-cotton-black-hoodie-isolated-on-transparent-background-free-png.png",
      "title": "Oversized Heavyweight Hoodie",
      "price": "\$35.00",
      "oldPrice": "\$55.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/165264330_BLK_1.png?v=1768495577&width=1200",
      "title": "Cyber-Punk Graphic Tee",
      "price": "\$18.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/068/937/037/small/classic-blue-and-white-letterman-jacket-with-varsity-style-for-sports-fashion-enthusiasts-png.png",
      "title": "Retro Letterman Varsity Jacket",
      "price": "\$65.00",
      "oldPrice": "\$90.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/074/737/880/small/gray-cargo-pants-isolated-on-transparent-background-png.png",
      "title": "Techwear Utility Joggers",
      "price": "\$42.00",
      "oldPrice": "\$60.00",
    },
    {
      "image":
          "https://www.adonieliclothing.com/cdn/shop/files/fisherman-beanie-petrol-blue-front-66feb6751e774.png?v=1727968899&width=1445",
      "title": "Neon Fisherman Beanie",
      "price": "\$12.00",
      "oldPrice": "\$18.00",
    },
    {
      "image":
          "https://www.pngall.com/wp-content/uploads/2/Vest-Transparent.png",
      "title": "Modular Tactical Vest",
      "price": "\$48.00",
      "oldPrice": "\$75.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/172100100_CAN_1_819ee314-ba2c-497d-87b4-6b1a49229c21.png?v=1776198349&width=1200",
      "title": "Pro-Mesh Court Shorts",
      "price": "\$22.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://kizik.com/cdn/shop/files/WVEG2501_Womens_Vegas_2_Bright_White_Lateral-2048x2048-ae00118.png?v=1756926878&width=600",
      "title": "Chunky Platform Sneakers",
      "price": "\$85.00",
      "oldPrice": "\$120.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/121800620_BLK_1_96756bfc-55c3-4505-9bc3-92b495001f85.png?v=1770936535&width=1200",
      "title": "90s Colorblock Windbreaker",
      "price": "\$38.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/168394489S_OBEY_STRETCHED_DLB_VTG.WC_1_d07091fb-d926-4286-b84b-3cd671e31dd7.png?v=1765237581&width=1200",
      "title": "Distressed Flannel Overshirt",
      "price": "\$28.00",
      "oldPrice": "\$40.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/172100107_WBL_1_b211330d-743f-48b3-819f-fe0f29af4bf3.png?v=1773697591&width=1200",
      "title": "Raw Edge Baggy Denim",
      "price": "\$45.00",
      "oldPrice": "\$65.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/047/424/129/small/womens-wallet-isolated-on-transparent-background-free-png.png",
      "title": "Industrial Chain Wallet",
      "price": "\$15.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/068/912/549/small/a-stylish-white-crop-top-with-an-off-shoulder-design-perfect-for-fashion-layouts-and-summer-apparel-mockups-with-transparent-background-free-png.png",
      "title": "Reflective Piping Crop Top",
      "price": "\$20.00",
      "oldPrice": "\$32.00",
    },
    {
      "image":
          "https://alphaindustries.cstatic.io/media/c8/89/0b/1724769899/100101_01_1_flatlay_00001_96606.png?ts=1753948717",
      "title": "Classic MA-1 Bomber Jacket",
      "price": "\$55.00",
      "oldPrice": "\$85.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/066/173/219/small_2x/grey-acid-wash-distressed-gray-t-shirt-mockup-isolated-on-a-transparent-background-png.png",
      "title": "Acid Wash Distressed Tee",
      "price": "\$19.00",
      "oldPrice": "\$28.00",
    },
    {
      "image":
          "https://goiaba-ec.com/cdn/shop/files/bucket-corduroy-LT-brown-2-web.png?v=1696412253&width=1946",
      "title": "Corduroy Bucket Hat",
      "price": "\$14.00",
      "oldPrice": "\$20.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/142020267_MMD_1.png?v=1770744630&width=1200",
      "title": "Velocity Track Pants",
      "price": "\$30.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/163210083S_DTC_1.png?v=1765213997&width=1200",
      "title": "Boxy Full-Zip Hoodie",
      "price": "\$40.00",
      "oldPrice": "\$60.00",
    },
    {
      "image":
          "https://images.ctfassets.net/9hslf09drsil/38TLxozTz4XR7JBuPmB7nW/4f7b0000f237d19dcfcb67af57677a61/UAG_1L_Standard_Issue_Sling_Blk-1.png",
      "title": "Urban Sling Crossbody Bag",
      "price": "\$25.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/100260093_ALB_1.png?v=1770744428&width=1200",
      "title": "Flame Knit Crew Socks",
      "price": "\$8.00",
      "oldPrice": "\$12.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/048/560/034/small/women-grey-hooded-warm-sport-puffer-jacket-isolated-against-transparent-background-png.png",
      "title": "Metallic Silver Puffer",
      "price": "\$75.00",
      "oldPrice": "\$110.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/035/882/721/small/ai-generated-man-long-sleeve-white-tshirt-isolated-on-transparent-background-free-png.png",
      "title": "Faux-Layer Long Sleeve",
      "price": "\$24.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/142020261_BLK_1.png?v=1754529437&width=1200",
      "title": "Duck Canvas Carpenter Pants",
      "price": "\$39.00",
      "oldPrice": "\$55.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/051/956/188/small/black-wraparound-sports-sunglasses-with-polarized-lenses-on-a-transparent-background-png.png",
      "title": "Wraparound Shield Shades",
      "price": "\$16.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-46f7bfc49a784ba08830794b08c4bf07/420/420/SweaterAccessory/Webp/noFilter",
      "title": "Grunge Distressed Knitwear",
      "price": "\$42.00",
      "oldPrice": "\$62.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/121800615_RID_1_10c8f49d-d984-4e99-bd0a-145e0694be2e.png?v=1770935254&width=1200",
      "title": "Sherpa-Lined Denim Trucker",
      "price": "\$58.00",
      "oldPrice": "\$80.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/051/135/341/non_2x/tie-dye-t-shirt-design-free-png.png",
      "title": "Dark Nebula Tie-Dye Tee",
      "price": "\$21.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://www.cmpsport.com/media/catalog/product/cache/8d6a0299217466f33865b9cc5b11e563/3/2/32T7426_P605_A_FOT_ECO_1.png",
      "title": "Baggy Nylon Parachute Pants",
      "price": "\$36.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/100580441_FNC_1.png?v=1770744478&width=1200",
      "title": "Vintage Foam Trucker Cap",
      "price": "\$15.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/118164241_BLK_1.png?v=1754529646&width=1200",
      "title": "Skeleton Glow-in-the-Dark Hoodie",
      "price": "\$44.00",
      "oldPrice": "\$65.00",
    },
  ],
  "Minimalist": [
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/051/956/189/small/black-satin-jogger-pants-with-elastic-waistband-on-a-transparent-background-png.png',
      'title': 'Black Basic Joggers',
      'price': '\$36.45',
      'oldPrice': '\$40.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/060/809/825/non_2x/white-casual-buttoned-linen-shirt-with-collar-and-pockets-on-hanger-free-png.png',
      'title': 'Classic White Linen Shirt',
      'price': '\$45.00',
      'oldPrice': '\$55.00',
    },
    {
      'image':
          'https://images.jackjones.com/12150148/4075166/001/jackjones-jpstmarcobowienoos-beige.png?v=0f3da85c3c8499922f2235feec931186&format=auto&width=700&quality=90&key=productTile_mainImage-DESKTOP&bg-color=%23f5f5f5',
      'title': 'Slim Fit Beige Chinos',
      'price': '\$52.00',
      'oldPrice': '\$60.00',
    },
    {
      'image':
          'https://pjt.com/cdn/shop/files/FL-KTW1737-CASHMERECREWNECK-NAVY-FRONT_21b27e05-6e81-4ea5-b11a-e5f95f52a33c.png?v=1770356288&width=1200',
      'title': 'Navy Cashmere Crewneck',
      'price': '\$89.99',
      'oldPrice': '\$110.00',
    },
    {
      'image':
          'https://dtfcapetown.co.za/cdn/shop/files/PremiumLongSleeveT-Shirtcharcoal.png?v=1751629865&width=1445',
      'title': 'Premium Charcoal Tee',
      'price': '\$24.00',
      'oldPrice': '\$30.00',
    },
    {
      'image':
          'https://cdn.media.amplience.net/i/tom_ford/JDSG01-WHS14_NAA_OS_A?w=400',
      'title': 'Wool Blend Overcoat',
      'price': '\$145.00',
      'oldPrice': '\$180.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/055/392/192/non_2x/a-pair-of-brown-leather-loafers-isolated-on-transparent-background-free-png.png',
      'title': 'Tan Suede Loafers',
      'price': '\$95.00',
      'oldPrice': '\$120.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/112460035_AGRY_1_1bc60632-04c9-40db-87cd-0af9ca3e3186.png?v=1770943328&width=1200',
      'title': 'Heavyweight Grey Hoodie',
      'price': '\$65.00',
      'oldPrice': '\$75.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/163554353_BLK_1.png?v=1768502669&width=1200',
      'title': 'Merino Black Turtleneck',
      'price': '\$58.00',
      'oldPrice': '\$70.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/172100100_CVS_1_d0f4aa34-3e57-4a06-8b79-d60d07d28865.png?v=1776198381&width=1200',
      'title': 'Tailored Canvas Shorts',
      'price': '\$38.00',
      'oldPrice': '\$45.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/IMG_0010.png?v=1771959182&width=1200',
      'title': 'Minimal White Sneakers',
      'price': '\$110.00',
      'oldPrice': '\$140.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/411550135_GMU_1.png?v=1768348327&width=1200',
      'title': 'Leather Chelsea Boots',
      'price': '\$130.00',
      'oldPrice': '\$165.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/221800441_GMU_1.png?v=1754529009&width=1200',
      'title': 'Sand Satin Bomber',
      'price': '\$78.00',
      'oldPrice': '\$95.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/121800615_RID_1_10c8f49d-d984-4e99-bd0a-145e0694be2e.png?v=1770935254&width=1200',
      'title': 'Raw Denim Jacket',
      'price': '\$85.00',
      'oldPrice': '\$100.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/100050041_BLK_1.png?v=1770744424&width=1200',
      'title': 'Classic Brown Belt',
      'price': '\$29.00',
      'oldPrice': '\$35.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/049/665/141/small/men-s-black-dial-chronograph-watch-with-transparent-background-silver-stainless-steel-case-leather-strap-and-orange-accents-png.png',
      'title': 'Steel Case Watch',
      'price': '\$195.00',
      'oldPrice': '\$250.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/100010167_BLK_1.png?v=1770744419&width=1200',
      'title': 'Leather Commuter Tote',
      'price': '\$120.00',
      'oldPrice': '\$150.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/221800440_YTW_1.png?v=1754529012&width=1200',
      'title': 'Lightweight Field Jacket',
      'price': '\$88.00',
      'oldPrice': '\$110.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/272100058_CHA_2.png?v=1768416307&width=1200',
      'title': 'Relaxed Fit Trousers',
      'price': '\$62.00',
      'oldPrice': '\$80.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/151010025_BLK_1_3d44ce96-9f05-4f1b-8b5f-7fa7f7aa3bdb.png?v=1755217074&width=1200',
      'title': 'Cable Knit Cardigan',
      'price': '\$75.00',
      'oldPrice': '\$95.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/165264305_WHT_1.png?v=1772474459&width=1200',
      'title': 'Essential Oxford Shirt',
      'price': '\$48.00',
      'oldPrice': '\$55.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/previews/051/337/347/non_2x/soft-woolen-hat-and-warm-scarf-on-a-transparent-background-for-stylish-winter-fashion-accessories-woolen-hat-and-scarf-isolated-on-transparent-background-free-png.png',
      'title': 'Soft Wool Scarf',
      'price': '\$32.00',
      'oldPrice': '\$40.00',
    },
    {
      'image':
          'https://cdn.shopify.com/s/files/1/0078/6825/2273/files/Silver-Pique-Polo_Bright-White-w-True-Navy-Tipping_M01K11-BWTN-260.png?v=1774974766&width=900',
      'title': 'Piqué Cotton Polo',
      'price': '\$35.00',
      'oldPrice': '\$45.00',
    },
    {
      'image':
          'https://braveststudios.com/cdn/shop/files/IMG-7945.png?v=1762283020',
      'title': 'Premium Grey Sweats',
      'price': '\$42.00',
      'oldPrice': '\$50.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/100580441_VPM_1.png?v=1770744479&width=1200',
      'title': 'Plain Cotton Cap',
      'price': '\$18.00',
      'oldPrice': '\$25.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/059/490/627/small/classic-white-tank-top-mockup-isolated-on-transparent-background-png.png',
      'title': 'Ribbed Cotton Tank',
      'price': '\$15.00',
      'oldPrice': '\$20.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/045/831/976/small/gray-blazer-isolated-on-transparent-background-png.png',
      'title': 'Unstructured Blazer',
      'price': '\$160.00',
      'oldPrice': '\$210.00',
    },
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/142020264_SOL_1.png?v=1754529423&width=1200',
      'title': 'Olive Straight Chinos',
      'price': '\$55.00',
      'oldPrice': '\$65.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/050/591/378/small/stylish-black-square-frame-glasses-with-transparent-lenses-on-transparent-background-free-png.png',
      'title': 'Acetate Square Frames',
      'price': '\$85.00',
      'oldPrice': '\$110.00',
    },
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/049/207/326/small/striped-men-s-dress-shirt-isolated-on-transparent-background-free-png.png',
      'title': 'Striped Poplin Shirt',
      'price': '\$50.00',
      'oldPrice': '\$60.00',
    },
  ],
  "Vintage": [
    {
      "image":
          "https://superiorleather.co.uk/cdn/shop/files/Mens_British_Model_Tan_Cow_Real_Leather_Jacket__744_-1-removebg-preview.png?v=1696609070",
      "title": "Aged Cafe Racer Leather Jacket",
      "price": "\$85.00",
      "oldPrice": "\$125.00",
    },
    {
      "image":
          "https://www.insidehook.com/wp-content/uploads/2025/09/Todd-Snyder-Corduroys.png?fit=1200%2C800",
      "title": "Retro Wide-Leg Corduroy Pants",
      "price": "\$38.00",
      "oldPrice": "\$55.00",
    },
    {
      "image":
          "https://store.wagewarband.com/cdn/shop/files/METAL-SKULL-TOUR-TEE.png?v=1744375575",
      "title": "Washed Rock Band Graphic Tee",
      "price": "\$22.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/121800615_HVLI_1.png?v=1770935165&width=1200",
      "title": "1980s Sherpa-Lined Denim Trucker",
      "price": "\$52.00",
      "oldPrice": "\$78.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/151010046_BKM_1_b7972cfe-f1be-436d-9749-47f6b4c0d9fc.png?v=1770934637&width=1200",
      "title": "Classic Argyle Knit Sweater",
      "price": "\$40.00",
      "oldPrice": "\$60.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/181210462_TRR_1_d9139fe2-5774-4d58-9dcd-6c7795f7570a.png?v=1770941836&width=1200",
      "title": "Heritage Plaid Flannel Shirt",
      "price": "\$28.00",
      "oldPrice": "\$42.00",
    },
    {
      "image":
          "https://hufworldwide.co.uk/cdn/shop/files/SONG-VARSITY-JACKET_BLACK_JK00439_BLACK_02_1200x.png?v=1751468021",
      "title": "Collegiate Wool Varsity Jacket",
      "price": "\$70.00",
      "oldPrice": "\$95.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/242010059_HVI_1.png?v=1768427938&width=1200",
      "title": "High-Waist Light Wash Mom Jeans",
      "price": "\$45.00",
      "oldPrice": "\$65.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/181210455_DRS_1_b707d804-7383-4a97-a285-f0f134b6370d.png?v=1770941159&width=1200",
      "title": "50s Style Two-Tone Bowling Shirt",
      "price": "\$32.00",
      "oldPrice": "\$48.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/121810017_BLU_1.png?v=1754529508&width=1200",
      "title": "Bohemian Suede Fringe Vest",
      "price": "\$44.00",
      "oldPrice": "\$62.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/055/926/344/non_2x/classic-aviator-sunglasses-with-gradient-lenses-on-a-transparent-background-perfect-for-sunny-days-sunglasses-on-a-isolated-on-background-file-background-free-png.png",
      "title": "Gold Frame Classic Aviators",
      "price": "\$18.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/151000109_BKM_1_2c199e31-1eba-494c-988d-33185e7fc635.png?v=1754529399&width=1200",
      "title": "Ribbed Merino Wool Turtleneck",
      "price": "\$35.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/055/135/095/non_2x/denim-overalls-for-children-isolated-on-transparent-background-showcasing-stylish-and-durable-clothing-for-kids-in-a-classic-blue-fabric-design-free-png.png",
      "title": "Vintage Relaxed Fit Overalls",
      "price": "\$55.00",
      "oldPrice": "\$80.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/151000114_STR_1.png?v=1754529389&width=1200",
      "title": "Retro Horizontal Striped Polo",
      "price": "\$25.00",
      "oldPrice": "\$38.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/071/672/360/non_2x/classic-beige-trench-coat-with-belt-and-double-breasted-closure-isolated-on-transparent-background-free-png.png",
      "title": "Mid-Century Double Breasted Trench",
      "price": "\$95.00",
      "oldPrice": "\$140.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/055/299/540/non_2x/soft-knit-cardigan-sweater-on-transparent-background-png.png",
      "title": "Chunky Cable-Knit Grandpa Cardigan",
      "price": "\$48.00",
      "oldPrice": "\$68.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/071/315/589/small/bag-mockups-collection-tote-duffel-travel-fashion-branding-packaging-png.png",
      "title": "Sun-Bleached Heavy Canvas Tote",
      "price": "\$15.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/142010087_MSL_1.png?v=1754529476&width=1200",
      "title": "70s Dark Wash Bootcut Denim",
      "price": "\$42.00",
      "oldPrice": "\$60.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/121800618_PDM_1.png?v=1770936114&width=1200",
      "title": "90s Color-Block Windbreaker",
      "price": "\$38.00",
      "oldPrice": "\$52.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/073/324/830/small/classic-navy-blue-wool-beret-hat-isolated-on-transparent-background-for-fashion-and-military-use-free-png.png",
      "title": "Classic French Wool Beret",
      "price": "\$12.00",
      "oldPrice": "\$20.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/047/606/337/small/cotton-printed-scarf-isolated-on-transparent-background-png.png",
      "title": "Ornate Geometric Silk Scarf",
      "price": "\$14.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://www.baracuta.com/cdn/shop/files/CAROSELLO_02_-_G9s_Leather.png?v=1774427444",
      "title": "Heritage Harrington G9 Jacket",
      "price": "\$60.00",
      "oldPrice": "\$85.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/069/802/302/small/newsboy-cap-with-herringbone-pattern-a-classic-vintage-gray-tweed-men-s-fashion-headwear-png.png",
      "title": "Wool Blend Tweed Newsboy Cap",
      "price": "\$20.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/036/084/083/non_2x/ai-generated-couple-leather-boot-isolated-on-transparent-background-free-png.png",
      "title": "Full-Grain Leather Heritage Boots",
      "price": "\$110.00",
      "oldPrice": "\$150.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/100050042_BLK_1.png?v=1770744426&width=700",
      "title": "Embossed Leather Western Belt",
      "price": "\$24.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/181210452_UBL_1.png?v=1770940536&width=1200",
      "title": "Poplin Cotton Safari Shirt",
      "price": "\$30.00",
      "oldPrice": "\$45.00",
    },
  ],
  "Casual": [
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/052/241/416/small_2x/white-pullover-sweatshirt-on-transparent-background-png.png",
      "title": "Daily Essential Crewneck",
      "price": "\$25.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/142020264_SOL_1_337b40e4-864c-406d-9a3e-07b78a5f2b1e.png?v=1754529423&width=1200",
      "title": "Slim-Fit Stretch Chinos",
      "price": "\$32.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/051/494/933/non_2x/blue-trendy-denim-jacket-on-transparent-background-free-png.png",
      "title": "Classic Mid-Wash Denim Jacket",
      "price": "\$48.00",
      "oldPrice": "\$65.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/131080331_BKM_1.png?v=1754529819&width=1200",
      "title": "Breton Striped Long Sleeve",
      "price": "\$18.00",
      "oldPrice": "\$24.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/041/645/441/small/ai-generated-navy-blue-t-shirt-with-v-neck-on-transparent-background-image-free-png.png",
      "title": "Premium Cotton V-Neck Tee",
      "price": "\$14.00",
      "oldPrice": "\$20.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/036/624/241/small/sneakers-adidas-niteball-isolated-on-a-transparent-background-free-png.png",
      "title": "Low-Profile Canvas Sneakers",
      "price": "\$35.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://shopdonni.com/cdn/shop/files/LINENSHIRT-CREME_285e0f26-77a7-4a5b-aef2-111a39224d2d.png?crop=center&height=3012&v=1745275079&width=2010",
      "title": "Breathable Summer Linen Shirt",
      "price": "\$28.00",
      "oldPrice": "\$40.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/172120131_CAN_1_7aca1077-f72e-4e48-af29-7431ec798d13.png?v=1773698796&width=1200",
      "title": "Weekend Drawstring Shorts",
      "price": "\$22.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0078/6825/2273/files/Silver-Pique-Polo_Bright-White-w-True-Navy-Tipping_M01K11-BWTN-260.png?v=1774974766&width=900",
      "title": "Classic Pique Polo Shirt",
      "price": "\$24.00",
      "oldPrice": "\$32.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/066/666/332/small/color-block-satin-bomber-jacket-with-zipper-pockets-and-no-background-png.png",
      "title": "Lightweight Quilted Bomber",
      "price": "\$55.00",
      "oldPrice": "\$75.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0078/6825/2273/files/Warmknit_Henley_TrueNavy_Front_9a488acf-5681-43a0-8eb8-2b2bbd04e5cb.png?v=1764096391&width=900",
      "title": "Waffle Knit Henley",
      "price": "\$20.00",
      "oldPrice": "\$28.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/059/632/018/small/mens-casual-khaki-chino-pants-with-pleats-and-slim-fit-for-everyday-wear-png.png",
      "title": "Relaxed Fit Khaki Trousers",
      "price": "\$30.00",
      "oldPrice": "\$42.00",
    },
    {
      "image":
          "https://www.allbirds.com/cdn/shop/files/A12282_26Q1_Dasher-NZ-Relay-Seagrass-Parchment_PDP_LEFT_9c98cf52-168f-491e-929a-c15070aa628c.png?v=1774484656&width=1024",
      "title": "Easy-On Suede Slip-Ons",
      "price": "\$40.00",
      "oldPrice": "\$58.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/055/075/442/small/black-zippered-hoodie-sweatshirt-on-transparent-background-plain-black-hoodie-front-png.png",
      "title": "Everyday Full-Zip Hoodie",
      "price": "\$34.00",
      "oldPrice": "\$48.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/054/125/697/small/a-product-studio-photograph-of-a-slightly-shorter-dark-forest-green-dad-hat-taken-at-0-degrees-with-a-well-illuminated-plain-transparent-background-png.png",
      "title": "Soft Corduroy Dad Hat",
      "price": "\$12.00",
      "oldPrice": "\$18.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/048/396/137/non_2x/red-and-black-plaid-shirt-mockup-isolated-on-transparent-background-free-png.png",
      "title": "Soft-Touch Plaid Flannel",
      "price": "\$26.00",
      "oldPrice": "\$38.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/054/796/304/small/mustard-yellow-cargo-shorts-summer-fashion-essential-on-transparent-background-png.png",
      "title": "Classic Utility Cargo Shorts",
      "price": "\$24.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/022/695/955/small/beige-snow-hat-isolated-on-a-transparent-background-png.png",
      "title": "Cuffed Rib-Knit Beanie",
      "price": "\$10.00",
      "oldPrice": "\$15.00",
    },
    {
      "image":
          "https://www.underu.com/cdn/shop/files/27752-boss-t-shirt-grey_700x700.png?v=1770825916",
      "title": "3-Pack Essential Crew Tees",
      "price": "\$30.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/056/615/006/small/military-combat-boots-side-view-isolate-on-transparent-background-png.png",
      "title": "Classic Tan Desert Boots",
      "price": "\$60.00",
      "oldPrice": "\$85.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/069/883/594/small_2x/blue-ribbed-turtleneck-sweater-isolated-on-transparent-background-png.png",
      "title": "Relaxed Mock-Neck Sweater",
      "price": "\$38.00",
      "oldPrice": "\$55.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/068/842/442/small/stylish-black-leather-biker-jacket-with-zippers-and-classic-design-perfect-for-bold-fashion-statement-png.png",
      "title": "Minimalist Nylon Track Jacket",
      "price": "\$42.00",
      "oldPrice": "\$60.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-6daef7a71bd5b5d5212b93070b833677/420/420/PantsAccessory/Webp/noFilter",
      "title": "Straight-Leg Dark Wash Jeans",
      "price": "\$36.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://kmmco.com/cdn/shop/files/mediumbrownslimcardwallet.png?v=1747159426&width=1100",
      "title": "Wallet bag",
      "price": "\$18.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1739893078-salomon-bonatti-waterproof-crop-background-removed-67b4a8f02dade.png?crop=1xw:1xh;center,top&resize=980:*",
      "title": "Packable Anorak Windbreaker",
      "price": "\$35.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/060/195/628/small/jogger-pants-with-soft-fabric-elastic-waistband-and-ankle-cuffs-on-a-transparent-background-png.png",
      "title": "Soft Fleece Jogger Pants",
      "price": "\$28.00",
      "oldPrice": "\$40.00",
    },
    {
      "image":
          "https://www.rimowa.com/on/demandware.static/-/Sites-rimowa-master-catalog-final/default/dw7ac37305/images/medium/52500087_1.png",
      "title": "Classic Canvas Daily Backpack",
      "price": "\$32.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/074/533/757/small/classic-round-tortoiseshell-sunglasses-with-dark-lenses-for-eye-protection-isolated-on-transparent-background-png.png",
      "title": "Classic Tortoise Frame Shades",
      "price": "\$15.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/070/237/193/small/white-button-down-shirt-with-pocket-png.png",
      "title": "Casual Button-Down Oxford",
      "price": "\$29.00",
      "oldPrice": "\$42.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/069/040/062/small_2x/black-padded-puffer-vest-sleeveless-fashion-outerwear-on-transparent-background-png.png",
      "title": "Lightweight Puffer Vest",
      "price": "\$40.00",
      "oldPrice": "\$58.00",
    },
  ],
  "Luxury": [
    {
      'image':
          'https://static.vecteezy.com/system/resources/thumbnails/048/783/886/small/gold-watch-on-transparent-background-genereted-ai-free-png.png',
      'title': 'Premium Gold Watch',
      'price': '\$1214.00',
      'oldPrice': '\$1317.50',
    },
    {
      "image":
          "https://julivno.com/cdn/shop/files/julivno_skeleton_watch_18k_gold_plated_41mm_men_copy.webp?v=1768816883&width=1000",
      "title": "Skeleton Dial 18K Gold Watch",
      "price": "\$2,400.00",
      "oldPrice": "\$3,100.00",
    },
    {
      "image":
          "https://images.squarespace-cdn.com/content/v1/59a927d74c0dbfb3d06bad29/1689967073453-2IKLOCVLTOYVX60LJCG8/Camel_Coat_1+copy-1+copy.png?format=1500w",
      "title": "Double-Faced Cashmere Overcoat",
      "price": "\$850.00",
      "oldPrice": "\$1,200.00",
    },
    {
      "image":
          "https://www.shinola.com/cdn/shop/files/c5edf1d7b5e071c9ce791ca3cfd08ed8ed55954880af230f99445c6572ff8846.png?v=1775819565&width=1946",
      "title": "Handcrafted Alligator Briefcase",
      "price": "\$1,500.00",
      "oldPrice": "\$2,100.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/036/007/536/small/ai-generated-man-leather-shoes-on-transparent-background-ai-generated-png.png",
      "title": "Patent Leather Tuxedo Oxfords",
      "price": "\$450.00",
      "oldPrice": "\$600.00",
    },
    {
      "image":
          "https://hespokestyle.com/wp-content/uploads/2023/08/navy-velvet-shawl-collar-dinner-jacket-he-spoke-style-shop.png",
      "title": "Midnight Blue Velvet Dinner Jacket",
      "price": "\$720.00",
      "oldPrice": "\$950.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/054/197/451/small/vintage-aviator-sunglasses-for-stylish-fashion-statements-on-transparent-background-png.png",
      "title": "Ultralight Titanium Aviators",
      "price": "\$310.00",
      "oldPrice": "\$420.00",
    },
    {
      "image":
          "https://cdn.sanity.io/images/v8kybopt/production/ec84e05bdad6d654c53101f5f658e9e4a96fa4c2-2000x2000.png?w=690&fit=max&auto=format",
      "title": "Exotic Ostrich Leather Cardholder",
      "price": "\$180.00",
      "oldPrice": "\$250.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/060/195/697/small_2x/timeless-satin-evening-dress-with-elegant-pleating-and-feminine-cuts-isolated-on-transparent-background-png.png",
      "title": "Bias-Cut Pure Silk Evening Gown",
      "price": "\$580.00",
      "oldPrice": "\$800.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/054/043/965/non_2x/white-diamond-bangles-on-transparent-background-free-png.png",
      "title": "Platinum Diamond-Encrusted Cuff",
      "price": "\$3,200.00",
      "oldPrice": "\$4,500.00",
    },
    {
      "image":
          "https://cdn.media.amplience.net/i/tom_ford/J1574-LCL518N_1N001_OS_B?w=1280",
      "title": "Python Skin Chelsea Boots",
      "price": "\$890.00",
      "oldPrice": "\$1,300.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/051/302/769/small/gray-scarf-folded-neatly-isolated-on-a-transparent-background-png.png",
      "title": "Rare Vicuña Wool Scarf",
      "price": "\$1,100.00",
      "oldPrice": "\$1,500.00",
    },
    {
      "image":
          "https://eu.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-lv-initiales-monogram-shadow-40mm-reversible-belt--M4917U_PM2_Front%20view.jpg",
      "title": "Reversible Monogram Gold Belt",
      "price": "\$380.00",
      "oldPrice": "\$500.00",
    },
    {
      "image":
          "https://ca.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-silk-and-cashmere-blend-turtleneck--HSFN2WCVW900_PM2_Front%20view.jpg",
      "title": "Silk-Cashmere Blend Turtleneck",
      "price": "\$1820.00",
      "oldPrice": "\$1910.00",
    },
    {
      "image":
          "https://img.vitkac.com/uploads/product_thumb/TORBA%20CLOUD%20EXC-CRYSTAL/up/1.png",
      "title": "Crystal-Embellished Minaudière",
      "price": "\$950.00",
      "oldPrice": "\$1,400.00",
    },
    {
      "image":
          "https://www.florislondon.com/cdn/shop/files/Honey_Oud_EDP_100ml_Bottle.png?v=1743678628",
      "title": "Private Reserve Oud Fragrance",
      "price": "\$420.00",
      "oldPrice": "\$550.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0730/0929/9798/files/BaltzarSartorialBlackWoolMohairTuxedoJacketWaistcoat.png?v=1718358665&width=160&height=160&crop=center",
      "title": "Super 150s Wool Tailored Pants",
      "price": "\$290.00",
      "oldPrice": "\$400.00",
    },
    {
      "image":
          "https://us.frauenschuh.com/cdn/shop/products/Luxury_reversible_leather_jacket_from_Kitzb_hel_s_Frauenschuh_in_elefant.png?v=1706088024",
      "title": "Shearling-Lined Nappa Jacket",
      "price": "\$1,800.00",
      "oldPrice": "\$2,500.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0730/0929/9798/files/CarminaTobaccoSuedeLeatherXimHorsebitLoafersTop.png?v=1730116187&width=1200&height=1200&crop=center",
      "title": "Classic Suede Horsebit Loafers",
      "price": "\$480.00",
      "oldPrice": "\$650.00",
    },
    {
      "image":
          "https://rauantiques.com/cdn/shop/files/32-1441_1.png?v=1764592997",
      "title": "South Sea Pearl Necklace",
      "price": "\$2,100.00",
      "oldPrice": "\$2,800.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/059/534/939/non_2x/stylish-tweed-jacket-isolated-on-transparent-background-png.png",
      "title": "Hand-Woven Metallic Tweed Blazer",
      "price": "\$1,200.00",
      "oldPrice": "\$1,750.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/066/636/348/non_2x/closed-wooden-hook-handle-black-umbrella-on-transparent-background-black-umbrella-with-wooden-handle-free-png.png",
      "title": "Polished Chestnut Handle Umbrella",
      "price": "\$150.00",
      "oldPrice": "\$220.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/070/397/153/small/tie-neckwear-formal-accessory-fashion-style-elegant-apparel-clothing-attire-menswear-on-transparent-background-free-png.png",
      "title": "Heavyweight Silk Jacquard Tie",
      "price": "\$120.00",
      "oldPrice": "\$180.00",
    },
    {
      "image":
          "https://hestra-products.imgix.net/images/1050_4d468fd204-1002520-100-1_meta-original.jpg?&fit=clip&w=992&fm=png&auto=compress,format",
      "title": "Cashmere-Lined Deerskin Gloves",
      "price": "\$190.00",
      "oldPrice": "\$280.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/055/613/230/small/blue-crystal-drop-earrings-isolated-on-transparent-background-png.png",
      "title": "Royal Sapphire Drop Earrings",
      "price": "\$4,500.00",
      "oldPrice": "\$6,000.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/037/065/270/small/ai-generated-stylish-vest-on-a-transparent-background-png.png",
      "title": "Down-Filled Tech Satin Vest",
      "price": "\$550.00",
      "oldPrice": "\$750.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/051/148/608/non_2x/chunky-sneakers-isolate-transparency-background-png.png",
      "title": "Limited Edition Sculpted Sneakers",
      "price": "\$690.00",
      "oldPrice": "\$900.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/059/490/639/small/sleek-black-pencil-skirt-with-a-high-waisted-design-isolated-on-transparent-background-png.png",
      "title": "Buttery Lambskin Pencil Skirt",
      "price": "\$620.00",
      "oldPrice": "\$850.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/054/634/013/non_2x/a-gold-flower-brooch-with-diamonds-free-png.png",
      "title": "Art Deco Inspired Gold Brooch",
      "price": "\$800.00",
      "oldPrice": "\$1,100.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/181200423_PEL_1.png?v=1760715889&width=1200",
      "title": "Bespoke Sea Island Cotton Shirt",
      "price": "\$250.00",
      "oldPrice": "\$350.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0549/3800/9848/files/Ivory-Teardrop-Crown-Fedora-Hat-in-Plush-Fur-Felt-The-Galante-Agnoulita-Hats-1_c8524448-b70b-43de-bacb-52ad4aefdbbc.webp?v=1763135486",
      "title": "Rabbit Fur Felt Fedora",
      "price": "\$340.00",
      "oldPrice": "\$480.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/previews/058/667/249/non_2x/elegant-red-embroidered-chinese-style-long-robe-with-sheer-overlay-free-png.png",
      "title": "Personalized Heavy Silk Robe",
      "price": "\$450.00",
      "oldPrice": "\$600.00",
    },
    {
      "image":
          "https://www.thomassabo.com/dw/image/v2/AAQY_PRD/on/demandware.static/-/Sites-ts-master-catalog/default/dw7a82e600/product/H/H/H2311/H2311-643-11.webp?sw=328&sfrm=png",
      "title": "Black Onyx & Sterling Silver Studs",
      "price": "\$280.00",
      "oldPrice": "\$380.00",
    },
    {
      "image":
          "https://cdn.sanity.io/images/v8kybopt/production/6232ea6f3e21fea76c210ef52439133ae26775c6-2000x2500.png?w=690&fit=max&auto=format",
      "title": "Large Grain Leather Weekender",
      "price": "\$1,100.00",
      "oldPrice": "\$1,600.00",
    },
    {
      "image":
          "https://static.vecteezy.com/system/resources/thumbnails/067/529/512/small/elegant-high-heel-shoes-in-vibrant-red-color-for-fashion-lovers-png.png",
      "title": "Iconic Red-Sole Stilettos",
      "price": "\$795.00",
      "oldPrice": "\$950.00",
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0832/5243/files/Misfits-Flat-1_1024x1024.jpg?v=1548366526",
      "title": "Embroidered Silk Bomber Jacket",
      "price": "\$1,400.00",
      "oldPrice": "\$2,000.00",
    },
    {
      "image":
          "https://swanandedgar.com/cdn/shop/files/White-Front_1200x.png?v=1760443403",
      "title": "Moonphase Complication Watch",
      "price": "\$5,500.00",
      "oldPrice": "\$7,200.00",
    },

    {
      "image":
          "https://www.fope.com/wp-content/uploads/2025/02/01M10BX_BB_G_XGX-717x900.png",
      "title": "Solid Gold Chunky Link Bracelet",
      "price": "\$2,800.00",
      "oldPrice": "\$3,500.00",
    },
  ],
  "Y2K": [
    {
      'image':
          'https://obeyclothing.com/cdn/shop/files/242010059_HVI_2.png?v=1768427938&width=1200',
      'title': 'Wide-Leg Cyber Jeans',
      'price': '\$10.50',
      'oldPrice': '\$15.00',
    },
    {
      "image":
          "https://64.media.tumblr.com/90caa2098c258534d603abf395c3ee41/tumblr_put2hjHXal1y7j16eo3_1280.pnj",
      "title": "Velour Rhinestone Zip-Up",
      "price": "\$22.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-2452d41ebeaf77f7241e3de74f1c4aba/420/420/PantsAccessory/Webp/noFilter",
      "title": "Glitter Butterfly Baby Tee",
      "price": "\$12.50",
      "oldPrice": "\$18.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-702c43c87e1e41965293a756007f9b94/420/420/PantsAccessory/Png/noFilter",
      "title": "Rimless Blue Tinted Shades",
      "price": "\$9.00",
      "oldPrice": "\$14.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-743860af790f9605cbc726eff5864661/420/420/PantsAccessory/Webp/noFilter",
      "title": "Cyber-Preppy Pleated Skirt",
      "price": "\$18.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-35583a54bc8c548a3e2a952c6a553f4a/420/420/PantsAccessory/Webp/noFilter",
      "title": "Metallic Space Shoulder Bag",
      "price": "\$24.00",
      "oldPrice": "\$32.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-b33565eaf1b6154daea6e51458dccc07/420/420/PantsAccessory/Webp/noFilter",
      "title": "Low-Rise Distressed Flares",
      "price": "\$28.00",
      "oldPrice": "\$40.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-9d08f58fb38a409ebfe6236cabcd49e7/420/420/PantsAccessory/Webp/noFilter",
      "title": "Contrast Stitch Trucker Cap",
      "price": "\$11.00",
      "oldPrice": "\$16.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-3919fcc0c218bfe142b6d24f44e75d4b/420/420/DressSkirtAccessory/Webp/noFilter",
      "title": "Chunky Platform Sandals",
      "price": "\$20.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-ea87d2a26c2ab765a11142f26ba17122/420/420/DressSkirtAccessory/Webp/noFilter",
      "title": "Sheer Cyber-Print Mesh Top",
      "price": "\$14.00",
      "oldPrice": "\$20.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-0c202ada414002901f56502bc2676892/420/420/WaistAccessory/Png/noFilter",
      "title": "Maxi Denim Cargo Skirt",
      "price": "\$26.00",
      "oldPrice": "\$38.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-cf587db9716d86a2440a09201bd16e86/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Crochet Star-Patch Beanie",
      "price": "\$10.00",
      "oldPrice": "\$15.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-432b21d2280085d7cb3101d2f7fa3377/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Faux-Fur Collar Cardigan",
      "price": "\$32.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-5b5693979dbd201e6f09b55736efaad8/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Candy Beaded Choker Set",
      "price": "\$6.50",
      "oldPrice": "\$10.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-28e83db308321150182a3ba6250640ac/420/420/TshirtAccessory/Webp/noFilter",
      "title": "Iridescent Spandex Tube Top",
      "price": "\$11.50",
      "oldPrice": "\$17.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-15676416b876993a44871e8996f6f875/420/420/DressSkirtAccessory/Webp/noFilter",
      "title": "Liquid Silver Parachute Pants",
      "price": "\$34.00",
      "oldPrice": "\$50.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-75c794c755f56c5115c9d648d408e36a/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Ribbed Knit Bolero Shrug",
      "price": "\$15.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-11cdf6403e87d49597c6d848e2efe249/420/420/TshirtAccessory/Webp/noFilter",
      "title": "Grommet Belt with Heart Buckle",
      "price": "\$8.00",
      "oldPrice": "\$13.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-398605b33fb3ca01c632db80588a1ab8/420/420/JacketAccessory/Webp/noFilter",
      "title": "Lace-Up Satin Corset",
      "price": "\$25.00",
      "oldPrice": "\$36.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-96a2429a73cfa78a7a2a0cf783f5be43/420/420/SweaterAccessory/Webp/noFilter",
      "title": "Multi-Color Butterfly Clips (Set)",
      "price": "\$5.00",
      "oldPrice": "\$8.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-d419daa496d881ef14d1c46122020f4a/420/420/TshirtAccessory/Webp/noFilter",
      "title": "Faux Leather Matrix Trench",
      "price": "\$55.00",
      "oldPrice": "\$80.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-ef2729c19dc80a9221097a8ed3c4e3fd/420/420/JacketAccessory/Webp/noFilter",
      "title": "Angel Wing Full-Zip Hoodie",
      "price": "\$38.00",
      "oldPrice": "\$55.00",
    },
    {
      "image":
          "https://obeyclothing.com/cdn/shop/files/168394484S_OBEY_OVAL_DLB_VTG.WC_1_f43dbd90-c457-4c04-836d-fca58efce1eb.png?v=1765237580&width=700",
      "title": "Micro-Mini Denim Shorts",
      "price": "\$16.00",
      "oldPrice": "\$24.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-0bca0fe1e90d75d87343d6724fd58bea/420/420/JacketAccessory/Webp/noFilter",
      "title": "White Faux-Fur Leg Warmers",
      "price": "\$13.00",
      "oldPrice": "\$19.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-2c510656974637ca4b71037fc9c7d565/420/420/JacketAccessory/Webp/noFilter",
      "title": "Pink Camo Utility Pants",
      "price": "\$29.00",
      "oldPrice": "\$42.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-3ff91be898dd7d349f7b4872d6983146/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Discoball Sequin Mini Bag",
      "price": "\$19.00",
      "oldPrice": "\$28.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-ca656f3913db85892fe1a8fa4b71a9ef/420/420/PantsAccessory/Webp/noFilter",
      "title": "Layered Silver Star Chain",
      "price": "\$10.50",
      "oldPrice": "\$15.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-45550db8bf613874322e23aba5d280de/420/420/JacketAccessory/Webp/noFilter",
      "title": "Rhinestone 'Princess' Tank",
      "price": "\$12.00",
      "oldPrice": "\$18.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-1d63d413de700a579a7550e801d8df8b/420/420/PantsAccessory/Webp/noFilter",
      "title": "Ultra-Platform Tech Sneakers",
      "price": "\$65.00",
      "oldPrice": "\$95.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-5f70a544104d3fec6b5cf881d7f235e2/420/420/PantsAccessory/Webp/noFilter",
      "title": "Striped Punk Arm Warmers",
      "price": "\$9.00",
      "oldPrice": "\$14.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-1f274c44577040c303f676c716b21688/420/420/PantsAccessory/Webp/noFilter",
      "title": "Leopard Print Satin Slip",
      "price": "\$21.00",
      "oldPrice": "\$30.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-47625b7a590e2b8231b054d72af09177/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Low-Rise Cargo Capris",
      "price": "\$24.00",
      "oldPrice": "\$35.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-66a3998587e76d524482f44b8a05d036/420/420/JacketAccessory/Webp/noFilter",
      "title": "Shiny Bubble Puffer Vest",
      "price": "\$30.00",
      "oldPrice": "\$45.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-a38b63fef137ddb98979fdc0a1f0f9f2/420/420/PantsAccessory/Webp/noFilter",
      "title": "Retro Anime Graphic Tee",
      "price": "\$15.50",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-b04008e49b5b7658037907e7dc13afd4/420/420/ShoulderAccessory/Webp/noFilter",
      "title": "Flared Sleeve Tie-Front Top",
      "price": "\$17.00",
      "oldPrice": "\$25.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-3cd62c411103055fb346ddb985676f2f/420/420/FrontAccessory/Webp/noFilter",
      "title": "Baggy Denim Bermuda Shorts",
      "price": "\$22.00",
      "oldPrice": "\$32.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-f375a6f258a453a54bc439096247036f/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Beaded Cherry Drop Earrings",
      "price": "\$7.00",
      "oldPrice": "\$12.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-087bbf8ca82f56bf0e27618251ba01dc/420/420/TshirtAccessory/Webp/noFilter",
      "title": "Cyber Visor Shield Glasses",
      "price": "\$14.00",
      "oldPrice": "\$22.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-cab30c51a8ec23162c2eb1aadb1fc11b/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Velour Low-Rise Mini Skirt",
      "price": "\$18.50",
      "oldPrice": "\$26.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-ede2c88ee463b0683dcc534cb0df004b/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Pixel Heart Crewneck",
      "price": "\$33.00",
      "oldPrice": "\$48.00",
    },
    {
      "image":
          "https://tr.rbxcdn.com/180DAY-9ca887c8eef17f0e5b2c55d9f4d64a1a/420/420/ShirtAccessory/Webp/noFilter",
      "title": "Chunky Lace-Up Combat Boots",
      "price": "\$70.00",
      "oldPrice": "\$100.00",
    },
    {
      'image':
          'https://tr.rbxcdn.com/180DAY-a5dba0bdfc7489a390fdba2fa163007e/420/420/ShirtAccessory/Webp/noFilter',
      'title': 'Wide-Leg Cyber Jeans',
      'price': '\$10.50',
      'oldPrice': '\$15.00',
    },
  ],
};



