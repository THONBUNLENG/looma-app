import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/all_new_item_screen.dart';
import 'package:shopping_app/src/screen/home_screen/categories/accessories_screen.dart';
import 'package:shopping_app/src/screen/home_screen/menu/search_menu_screen.dart';
import '../../../widget/text_widget.dart';
import '../../list_url.dart';
import '../categories/clothes_screen.dart';
import '../categories/shoes_screen.dart';
import '../flash_sale/flash_sale_discount_screen.dart';
import '../notification_page.dart';
import '../shopping_bag/shopping_bag_screen.dart';
import '../style_product/style_product_screen.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.categoryName,
    required this.newItems,
    required this.clothes,
    required this.polos,
    required this.activewear,
    required this.jackets,
    required this.jeans,
    required this.joggers,
    required this.leggings,
    required this.pants,
    required this.shirts,
    required this.skirt,
    required this.suits,
    required this.sweatshirts,
    required this.tShirts,
    required this.blouses,
    required this.cardigans,
    required this.coats,
    required this.dresses,
    required this.hoodies,
    required this.shorts,
    required this.skirts,
  });

  final String categoryName;
  final List<Map<String, dynamic>> newItems;
  final List<Map<String, dynamic>> clothes;
  final List<Map<String, dynamic>> polos;
  final List<Map<String, dynamic>> activewear;
  final List<Map<String, dynamic>> jackets;
  final List<Map<String, dynamic>> jeans;
  final List<Map<String, dynamic>> joggers;
  final List<Map<String, dynamic>> leggings;
  final List<Map<String, dynamic>> pants;
  final List<Map<String, dynamic>> shirts;
  final List<Map<String, dynamic>> skirt;
  final List<Map<String, dynamic>> suits;
  final List<Map<String, dynamic>> sweatshirts;
  final List<Map<String, dynamic>> tShirts;
  final List<Map<String, dynamic>> blouses;
  final List<Map<String, dynamic>> cardigans;
  final List<Map<String, dynamic>> coats;
  final List<Map<String, dynamic>> dresses;
  final List<Map<String, dynamic>> hoodies;
  final List<Map<String, dynamic>> shorts;
  final List<Map<String, dynamic>> skirts;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "WOMEN",
    "MEN",
    "KIDS",
    "L.HOME",
    "LIFESTYLE",
  ];

  final List<String> _menuWoman = [
    "New In",
    "Clothing",
    "Accessories",
    "Shoes",
    "Shop by collection",
    "SALE",
  ];

  final List<String> _menuMan = [
    "New In",
    "Clothing",
    "Accessories",
    "Shoes",
    "Shop by collection",
    "SALE",
  ];

  final List<String> _menuKids = [
    "New In",
    "Girls",
    "Boys",
    "Baby",
    "Toys",
    "SALE",
  ];

  final List<String> _menuHome = [
    "New In",
    "Bedroom",
    "Living Room",
    "Kitchen",
    "Decor",
    "SALE",
  ];

  final List<String> _menuLifestyle = [
    "New In",
    "Beauty",
    "Sport",
    "Tech",
    "Travel",
    "SALE",
  ];

  List<String> get _currentItems {
    switch (_selectedCategoryIndex) {
      case 0:
        return _menuWoman;
      case 1:
        return _menuMan;
      case 2:
        return _menuKids;
      case 3:
        return _menuHome;
      case 4:
        return _menuLifestyle;
      default:
        return _menuWoman;
    }
  }

  void _handleMenuTap(String item) {
    if (item == "SALE") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FlashSaleDiscountScreen(imageUrl: ''),
        ),
      );
    } else if (item == "Shop by collection") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StyleProductScreen(
            imageUrl:
                'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?q=80&w=1000',
          ),
        ),
      );
    } else if (item == "New In") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllNewItemScreen(categoryName: item, newItems: allTabs),
        ),
      );
    } else if (item == "Clothing" ||
        item == "Girls" ||
        item == "Boys" ||
        item == "Baby" ||
        item == "Toys" ||
        item == "Bedroom" ||
        item == "Living Room" ||
        item == "Kitchen" ||
        item == "Decor") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClothesScreen(
            categoryName: item,
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
      );
    } else if (item == "Accessories" ||
        item == "Beauty" ||
        item == "Sport" ||
        item == "Tech" ||
        item == "Travel") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccessoriesScreen(
            categoryName: item,
            accessories: accessories,
            jewelry: jewelry,
            sunglasses: sunglasses,
            watches: watches,
            hats: hats,
            belts: belts,
            scarves: scarves,
            hairAccessories: hairAccessories,
            gloves: gloves,
          ),
        ),
      );
    } else if (item == "Shoes") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShoesScreen(
            categoryName: 'Shoes',
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
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            'Category "$item" is coming soon!',
            color: Colors.white,
          ),
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white38 : Colors.grey[400]!;
    final searchBg = isDark ? Colors.grey[900]! : Colors.grey[100]!;
    final currentItems = _currentItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildUnifiedAppBar(context, isDark),
      body: Column(
        children: [
          _buildSearchBar(searchBg, isDark),
          _buildCategoryTabs(primaryColor, secondaryColor),
          Expanded(
            child: ListView.separated(
              itemCount: currentItems.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.white10 : Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                bool isSale = currentItems[index] == "SALE";
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: TextWidget(
                    currentItems[index].tr,
                    fontSize: 18,
                    fontWeight: isSale ? FontWeight.w900 : FontWeight.bold,
                    color: isSale ? Colors.red : primaryColor,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: primaryColor,
                  ),
                  onTap: () => _handleMenuTap(currentItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildUnifiedAppBar(BuildContext context, bool isDark) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 90,
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF9F9F9),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: IconButton(
          splashRadius: 24,
          icon: ImageIcon(
            const AssetImage('assets/icon/notification.png'),
            color: isDark ? Colors.white : Colors.black,
            size: 26,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: isDark
              ? const [Colors.white, Colors.white70]
              : const [Colors.black, Colors.black54],
        ).createShader(bounds),
        child: TextWidget(
          'LOOMA',
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                splashRadius: 24,
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: isDark ? Colors.white : Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShoppingBagScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 0,
                top: -2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isDark ? const Color(0xFF121212) : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: TextWidget(
                      '0',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(8),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : const Color(0xFFF1F1F1),
          ),
          child: TextWidget(
            "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
            color: isDark ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Color bg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchMenuScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextWidget(
                  "What are you searching for?".tr,
                  color: isDark ? Colors.white38 : Colors.black38,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(Color active, Color inactive) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? active : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: TextWidget(
                  _categories[index].tr,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: isActive ? active : inactive,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
