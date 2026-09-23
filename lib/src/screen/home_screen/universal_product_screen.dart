import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
import 'package:shopping_app/src/widget/favorite_button.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'filter/filter_screen.dart';

class UniversalProductScreen extends StatefulWidget {
  final String title;
  final String? category;
  final String? subCategory;
  final String? brandName;
  final String? initialGender;

  const UniversalProductScreen({
    super.key,
    required this.title,
    this.category,
    this.subCategory,
    this.brandName,
    this.initialGender,
  });

  @override
  State<UniversalProductScreen> createState() => _UniversalProductScreenState();
}

class _UniversalProductScreenState extends State<UniversalProductScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _selectedSubCategory;
  String _selectedGenderFilter = "All";
  String? _selectedBrandFilter;
  String _selectedSort = "Recommend";
  RangeValues _priceRange = const RangeValues(0, 2800);
  String? _selectedSize;
  String? _selectedColor;
  int _productCount = 0;
  bool _showSearchBar = false;
  late Stream<List<ProductModel>> _productStream;

  Future<List<String>>? _subCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _selectedSubCategory = widget.subCategory;
    _selectedGenderFilter = widget.initialGender ?? "All";
    _updateStream();
    if (widget.category != null) {
      _subCategoriesFuture = _firestoreService.getSubCategories(
        widget.category!,
      );
    }
  }

  void _updateStream() {
    _productStream = _firestoreService.getProducts(
      category: widget.category,
      subCategory: _selectedSubCategory,
      brandName: widget.brandName,
    );
  }

  Color _parseColor(String colorName) {
    colorName = colorName.toLowerCase().trim().replaceAll(' ', '');
    switch (colorName) {
      case 'pink':
        return AppColor.pink;
      case 'salered':
        return AppColor.saleRed;
      case 'successgreen':
        return AppColor.successGreen;
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'blue':
      case 'skyblue':
        return Colors.blue;
      case 'navy':
      case 'darkblue':
        return const Color(0xFF000080);
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'purple':
        return Colors.purple;
      case 'tan':
        return const Color(0xFFD2B48C);
      case 'beige':
        return const Color(0xFFF5F5DC);
      case 'khaki':
        return const Color(0xFFC3B091);
      case 'mint':
        return const Color(0xFF98FF98);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      default:
        if (colorName.startsWith('#')) {
          try {
            return Color(int.parse(colorName.replaceFirst('#', '0xFF')));
          } catch (_) {}
        }
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        toolbarHeight: 90,
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: !_showSearchBar,
        titleSpacing: _showSearchBar ? 0 : NavigationToolbar.kMiddleSpacing,
        title: _showSearchBar
            ? _buildSearchField(isDark)
            : ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.white, Colors.white70]
                      : [Colors.black, Colors.black54],
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
          IconButton(
            icon: Icon(
              _showSearchBar ? Icons.close_rounded : Icons.search_rounded,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                if (!_showSearchBar) {
                  _searchController.clear();
                  _searchQuery = "";
                }
              });
            },
          ),
          const CartBadge(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFF1F1F1),
            ),
            child: TextWidget(
              "Spend \$160+ and enjoy Discount 15% + FREE Delivery!".tr,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(isDark),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                TextWidget(
                  "$_productCount items found",
                  color: isDark ? Colors.white54 : Colors.black54,
                  fontSize: 14,
                ),
                const Spacer(),
                _buildSortDropdown(isDark),
              ],
            ),
          ),
          if (widget.category != null) _buildSubCategorySelector(isDark),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final isPermissionDenied =
                    snapshot.hasError &&
                    snapshot.error.toString().contains("permission-denied");

                if (snapshot.hasError && !isPermissionDenied) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/lottie/not-found.json',
                            height: 200,
                            repeat: true,
                          ),
                          const SizedBox(height: 16),
                          TextWidget(
                            "Oops! Something went wrong".tr,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          const SizedBox(height: 8),
                          TextWidget(
                            "We're having trouble reaching our database. Please check your connection or try again later.",
                            textAlign: TextAlign.center,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          if (kDebugMode) ...[
                            const SizedBox(height: 16),
                            TextWidget(
                              snapshot.error.toString(),
                              fontSize: 10,
                              color: Colors.grey,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                var products = snapshot.data ?? [];
                if (isPermissionDenied || products.isEmpty) {
                  products = _getLocalProducts();
                }

                if (_selectedGenderFilter != "All") {
                  products = products
                      .where(
                        (p) =>
                            p.gender?.toLowerCase() ==
                            _selectedGenderFilter.toLowerCase(),
                      )
                      .toList();
                }

                if (_selectedBrandFilter != null) {
                  products = products
                      .where(
                        (p) =>
                            (p.brandName?.toLowerCase() ==
                                _selectedBrandFilter!.toLowerCase()) ||
                            (p.title.toLowerCase().contains(
                              _selectedBrandFilter!.toLowerCase(),
                            )),
                      )
                      .toList();
                }

                products = products
                    .where(
                      (p) =>
                          p.price >= _priceRange.start &&
                          p.price <= _priceRange.end,
                    )
                    .toList();

                if (_selectedSize != null) {
                  products = products
                      .where((p) => p.sizes.contains(_selectedSize))
                      .toList();
                }

                if (_selectedColor != null) {
                  products = products
                      .where((p) => p.colors.contains(_selectedColor))
                      .toList();
                }

                if (_searchQuery.isNotEmpty) {
                  products = products
                      .where(
                        (p) => p.title.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                _applySorting(products);

                if (_productCount != products.length) {
                  final newCount = products.length;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _productCount != newCount) {
                      setState(() => _productCount = newCount);
                    }
                  });
                }

                if (products.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      context,
                      products[index],
                      isDark,
                      index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        cursorColor: isDark ? Colors.white : Colors.black,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          hintText: "Search products".tr,
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  List<ProductModel> _getLocalProducts() {
    List<Map<String, dynamic>> localData = [];

    final cat = widget.category?.toUpperCase();
    final subCat =
        _selectedSubCategory?.toUpperCase() ??
        widget.subCategory?.toUpperCase();

    if (subCat == 'POLOS') {
      localData = polos;
    } else if (subCat == 'JEANS') {
      localData = jeans;
    } else if (subCat == 'DRESSES') {
      localData = dresses;
    } else if (subCat == 'JACKETS') {
      localData = jackets;
    } else if (subCat == 'VESTS') {
      localData = vests;
    } else if (subCat == 'SKIRT' || subCat == 'SKIRTS') {
      localData = skirt;
    } else if (subCat == 'SHORTS') {
      localData = shorts;
    } else if (subCat == 'HOODIES') {
      localData = hoodies;
    } else if (subCat == 'T-SHIRTS' ||
        subCat == 'TSHIRTS' ||
        subCat == 'TSHIRT') {
      localData = tShirts;
    } else if (subCat == 'SWEATSHIRTS') {
      localData = sweatshirts;
    } else if (subCat == 'ACTIVEWEAR') {
      localData = activewear;
    } else if (subCat == 'PANTS') {
      localData = pants;
    } else if (subCat == 'SKINCARE') {
      localData = skincare;
    } else if (subCat == 'MAKEUP') {
      localData = makeup;
    } else if (subCat == 'SNEAKERS') {
      localData = sneakers;
    } else if (subCat == 'HEELS') {
      localData = heeled;
    } else if (subCat == 'SANDALS') {
      localData = sandals;
    } else if (subCat == 'BOOTS') {
      localData = shoesBoots;
    } else if (subCat == 'FLATS') {
      localData = flats;
    } else if (subCat == 'LOAFERS') {
      localData = loafers;
    } else if (subCat == 'SLIPPERS') {
      localData = slippers;
    } else if (subCat == 'SPORTS') {
      localData = sportsShoes;
    } else if (subCat == 'HANDBAGS') {
      localData = handbags;
    } else if (subCat == 'BACKPACKS') {
      localData = backpacks;
    } else if (subCat == 'CLUTCHES') {
      localData = clutches;
    } else if (subCat == 'WALLETS') {
      localData = wallets;
    } else if (subCat == 'TOTEBAGS') {
      localData = toteBags;
    } else if (subCat == 'MESSENGER') {
      localData = messengerBags;
    } else if (subCat == 'TRAVELBAGS') {
      localData = travelBags;
    } else if (subCat == 'BRAS' ||
        subCat == 'PANTIES' ||
        subCat == 'NIGHTWEAR' ||
        subCat == 'BODYSUIT' ||
        subCat == 'SHAPEWEAR') {
      localData = lingerie;
    } else if (subCat == 'JEWELRY') {
      localData = jewelry;
    } else if (subCat == 'WATCHES') {
      localData = watches;
    } else if (subCat == 'SUNGLASSES') {
      localData = sunglasses;
    } else if (subCat == 'HATS') {
      localData = hats;
    } else if (subCat == 'BELTS') {
      localData = belts;
    } else if (subCat == 'SCARVES') {
      localData = scarves;
    } else if (subCat == 'HAIR') {
      localData = hairAccessories;
    } else if (subCat == 'GLOVES') {
      localData = gloves;
    } else if (subCat == 'TOYS') {
      localData = toys;
    }

    if (localData.isEmpty) {
      if (cat == 'CLOTHING') {
        localData = clothes;
      } else if (cat == 'SHOES') {
        localData = shoes;
      } else if (cat == 'BAGS') {
        localData = bags;     } else if (cat == 'ACCESSORIES') {
        localData = accessories;
      } else if (cat == 'BEAUTY') {
        localData = beauty;
      } else if (cat == 'GIFTS') {
        localData = gift;
      } else if (cat == 'TRENDING') {
        localData = onTrend;
      } else {
        localData = allItems;

      }
    }

    return localData.map((m) => ProductModel.fromMap(m)).toList();
  }

  Widget _buildSubCategorySelector(bool isDark) {
    return FutureBuilder<List<String>>(
      future: _subCategoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return const SizedBox.shrink();
        }

        final subCategories = ["All", ...snapshot.data!];

        return Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final name = subCategories[index];
              final isSelected =
                  (name == "All" && _selectedSubCategory == null) ||
                  (_selectedSubCategory == name);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: TextWidget(name.tr),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedSubCategory = (name == "All") ? null : name;
                      _updateStream();
                    });
                  },
                  selectedColor: AppColor.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                  showCheckmark: false,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    bool isDark,
    int index,
  ) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product.toMap()),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColor.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag:
                            'product_${product.id ?? product.title}_${index}_${widget.category ?? ""}',
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? Colors.white24 : Colors.grey[300],
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    if (product.discount != null &&
                        product.discount!.isNotEmpty &&
                        product.discount != "0%")
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.saleRed,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextWidget(
                            product.discount!.tr,
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: FavoriteButton(product: product.toMap(), size: 24),
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
                  "LOOMA".tr.toUpperCase(),
                  fontSize: 16,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  product.title.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColor.black,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    TextWidget(
                      product.rating.toString(),
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextWidget(
                        "|",
                        color: subTextColor.withValues(alpha: 0.3),
                      ),
                    ),
                    Expanded(
                      child: TextWidget(
                        '%a sold'.trArgs([product.sold ?? '0']),
                        color: subTextColor,
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextWidget(
                  "\$${product.price.toStringAsFixed(2)}",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.saleRed,
                ),
                if (product.colors.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: product.colors.take(4).map((colorName) {
                      return Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: _parseColor(colorName),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applySorting(List<ProductModel> products) {
    switch (_selectedSort) {
      case 'New items':
        products.sort(
          (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
            a.createdAt ?? DateTime(0),
          ),
        );
        break;
      case 'Price (High First)':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Price (Low First)':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Discount (High First)':
        products.sort((a, b) {
          final d1 =
              double.tryParse(a.discount?.replaceAll('%', '') ?? '0') ?? 0;
          final d2 =
              double.tryParse(b.discount?.replaceAll('%', '') ?? '0') ?? 0;
          return d2.compareTo(d1);
        });
        break;
      case 'Discount (Low First)':
        products.sort((a, b) {
          final d1 =
              double.tryParse(a.discount?.replaceAll('%', '') ?? '0') ?? 0;
          final d2 =
              double.tryParse(b.discount?.replaceAll('%', '') ?? '0') ?? 0;
          return d1.compareTo(d2);
        });
        break;
      default:
        break;
    }
  }

  Widget _buildFilterBar(bool isDark) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterIconButton(isDark),
              const SizedBox(width: 8),
              _buildFilterChip(
                "Products/Gender",
                isDark,
                () => _showGenderFilter(isDark),
              ),
              const SizedBox(width: 8),
              _buildFilterChip("Price", isDark, () => _showPriceFilter(isDark)),
              const SizedBox(width: 8),
              _buildFilterChip("Size", isDark, () => _showSizeFilter(isDark)),
              const SizedBox(width: 8),
              _buildFilterChip("Color", isDark, () => _showColorFilter(isDark)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterIconButton(bool isDark) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FilterScreen()),
        );
        if (!mounted) return;
        if (result != null && result is Map<String, dynamic>) {
          setState(() {
            _selectedSort = result['sort'] ?? _selectedSort;
            _priceRange = result['priceRange'] ?? _priceRange;
            _selectedSize = result['size'];
            _selectedColor = result['color'];
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.tune_rounded,
          size: 20,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            TextWidget(
              label.tr,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown(bool isDark) {
    return PopupMenuButton<String>(
      onSelected: (val) => setState(() => _selectedSort = val),
      itemBuilder: (context) {
        return [
          'Recommend',
          'New items',
          'Discount (High First)',
          'Discount (Low First)',
          'Price (High First)',
          'Price (Low First)',
        ].map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: TextWidget(
              option.tr,
              color: isDark ? Colors.white : Colors.black,
            ),
          );
        }).toList();
      },
      child: Row(
        children: [
          TextWidget(
            _selectedSort.tr,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSheetShell({
    required bool isDark,
    required String title,
    required Widget content,
    required VoidCallback onApply,
  }) {
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            TextWidget(
              title,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 10),
            Flexible(child: SingleChildScrollView(child: content)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: TextWidget(
                    "Apply".tr,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showGenderFilter(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return _buildFilterSheetShell(
          isDark: isDark,
          title: "Products/Gender".tr,
          onApply: () => Navigator.pop(context),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["All", "Man", "Woman"].map((gender) {
              final isSelected = _selectedGenderFilter == gender;
              return ListTile(
                title: TextWidget(
                  gender.tr,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() => _selectedGenderFilter = gender);
                  Navigator.pop(context);
                },
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: isDark ? Colors.white : Colors.black,
                      )
                    : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showPriceFilter(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildFilterSheetShell(
              isDark: isDark,
              title: "Price Range".tr,
              onApply: () => Navigator.pop(context),
              content: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 2800,
                  divisions: 28,
                  activeColor: Colors.deepPurple[400],
                  inactiveColor: isDark ? Colors.white10 : Colors.grey[200],
                  labels: RangeLabels(
                    "\$${_priceRange.start.round()}",
                    "\$${_priceRange.end.round()}",
                  ),
                  onChanged: (val) {
                    setModalState(() => _priceRange = val);
                    setState(() => _priceRange = val);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSizeFilter(bool isDark) {
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'Free size'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return _buildFilterSheetShell(
          isDark: isDark,
          title: "Size".tr,
          onApply: () => Navigator.pop(context),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: sizes.map((size) {
              final isSelected = _selectedSize == size;
              return ListTile(
                title: TextWidget(
                  size,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() => _selectedSize = size);
                  Navigator.pop(context);
                },
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: isDark ? Colors.white : Colors.black,
                      )
                    : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showColorFilter(bool isDark) {
    final colors = [
      'Black',
      'White',
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Pink',
      'Brown',
      'Grey',
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return _buildFilterSheetShell(
          isDark: isDark,
          title: "Color".tr,
          onApply: () => Navigator.pop(context),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: colors.map((color) {
              final isSelected = _selectedColor == color;
              return ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _parseColor(color),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                title: TextWidget(
                  color.tr,
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onTap: () {
                  setState(() => _selectedColor = color);
                  Navigator.pop(context);
                },
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: isDark ? Colors.white : Colors.black,
                      )
                    : null,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty
                ? Icons.inventory_2_outlined
                : Icons.search_off_rounded,
            size: 70,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          TextWidget(
            _searchQuery.isEmpty
                ? "No products found".tr
                : "No results found for '%a'".trArgs([_searchQuery]),
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
