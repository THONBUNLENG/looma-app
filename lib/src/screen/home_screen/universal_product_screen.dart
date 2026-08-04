import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/network/datastor/auth_service.dart';
import 'package:shopping_app/src/screen/login_screen/login_screen.dart';
import 'package:shopping_app/src/screen/home_screen/product_detail/product_detail_screen.dart';
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
  late Stream<List<ProductModel>> _productStream;

  @override
  void initState() {
    super.initState();
    _selectedSubCategory = widget.subCategory;
    _selectedGenderFilter = widget.initialGender ?? "All";
    _updateStream();
  }

  void _updateStream() {
    _productStream = _firestoreService.getProducts(
      category: widget.category,
      subCategory: _selectedSubCategory,
      brandName: widget.brandName,
    );
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
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isDark ? [Colors.white, Colors.white70] : [Colors.black, Colors.black54],
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
        actions: [const CartBadge()],
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
          _buildSearchBar(context, isDark),
          _buildQuickFilters(isDark),
          if (widget.category != null) _buildSubCategorySelector(isDark),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final isPermissionDenied = snapshot.hasError && snapshot.error.toString().contains("permission-denied");
                
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
                            Text(
                              snapshot.error.toString(),
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
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

                // Apply Gender Filter
                if (_selectedGenderFilter != "All") {
                  products = products.where((p) => 
                    p.gender?.toLowerCase() == _selectedGenderFilter.toLowerCase()
                  ).toList();
                }

                // Apply Brand Filter
                if (_selectedBrandFilter != null) {
                  products = products.where((p) => 
                    (p.brandName?.toLowerCase() == _selectedBrandFilter!.toLowerCase()) ||
                    (p.title.toLowerCase().contains(_selectedBrandFilter!.toLowerCase()))
                  ).toList();
                }
                
                if (_searchQuery.isNotEmpty) {
                  products = products.where((p) => 
                    p.title.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                if (products.isEmpty) {
                  return _buildEmptyState(isDark);
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.60,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(context, products[index], isDark, index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ProductModel> _getLocalProducts() {
    List<Map<String, dynamic>> localData = [];
    
    final cat = widget.category?.toUpperCase();
    final subCat = _selectedSubCategory?.toUpperCase() ?? widget.subCategory?.toUpperCase();

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
    } else if (subCat == 'SKIRT') {
      localData = skirt;
    } else if (subCat == 'SHORTS') {
      localData = shorts;
    } else if (subCat == 'HOODIES') {
      localData = hoodies;
    } else if (subCat == 'T-SHIRTS' || subCat == 'TSHIRTS') {
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
    } 
    

    if (localData.isEmpty) {
      if (cat == 'CLOTHING') {
        localData = clothes;
      } else if (cat == 'SHOES') {
        localData = shoes;
      } else if (cat == 'BAGS') {
        localData = bags;
      } else if (cat == 'ACCESSORIES') {
        localData = accessories;
      } else if (cat == 'BEAUTY') {
        localData = beauty;
      } else if (cat == 'GIFTS') {
        localData = gift;
      } else {
        localData = allItems;
      }
    }

    return localData.map((m) => ProductModel.fromMap(m)).toList();
  }

  Widget _buildQuickFilters(bool isDark) {
    final List<String> brandNames = brandData.map((b) => b['name']!).toList();
    final filters = ["All", "Man", "Woman", ...brandNames];
    
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isBrand = index >= 3;
          
          bool isSelected;
          if (isBrand) {
            isSelected = _selectedBrandFilter == filter;
          } else {
            isSelected = (_selectedGenderFilter == filter && _selectedBrandFilter == null);
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter.tr),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (isBrand) {
                    if (isSelected) {
                      _selectedBrandFilter = null;
                    } else {
                      _selectedBrandFilter = filter;
                    }
                  } else {
                    if (filter == "All") {
                      _selectedGenderFilter = "All";
                      _selectedBrandFilter = null;
                      return;
                    }
                    _selectedGenderFilter = filter;
                    _selectedBrandFilter = null; // Clear brand when selecting gender
                  }
                });
              },
              selectedColor: AppColor.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubCategorySelector(bool isDark) {
    return FutureBuilder<List<String>>(
      future: _firestoreService.getSubCategories(widget.category!),
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
              final isSelected = (name == "All" && _selectedSubCategory == null) || 
                                (_selectedSubCategory == name);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(name.tr),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedSubCategory = (name == "All") ? null : name;
                      _updateStream();
                    });
                  },
                  selectedColor: AppColor.primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final searchBg = isDark ? Colors.white.withValues(alpha: 0.1) : AppColor.grey100;
    final hintColor = isDark ? Colors.white60 : Colors.black45;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Search in %a...".trArgs([widget.title]),
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, size: 22, color: hintColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.cancel_rounded, size: 20, color: hintColor),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilterScreen()),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded, size: 20, color: isDark ? Colors.white : Colors.black),
                  const SizedBox(width: 4),
                  TextWidget(
                    "filter".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product, bool isDark, int index) {
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final imageUrl = product.images.isNotEmpty ? product.images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: product.toMap()),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColor.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Hero(
                        tag: imageUrl + index.toString() + (widget.subCategory ?? widget.category ?? ''),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: isDark ? Colors.white24 : Colors.grey[300],
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          if (await AuthService.isLoggedIn()) {
                            // Wishlist logic
                          } else {
                            if (context.mounted) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                          }
                        },
                        child: Icon(Icons.favorite_border, size: 20, color: isDark ? Colors.white60 : Colors.black26),
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
                    const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    TextWidget(
                      product.rating.toString(),
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextWidget("|", color: subTextColor.withValues(alpha: 0.3)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.inventory_2_outlined : Icons.search_off_rounded,
            size: 70,
            color: isDark ? Colors.white10 : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          TextWidget(
            _searchQuery.isEmpty ? "No products found".tr : "No results found for '%a'".trArgs([_searchQuery]),
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
