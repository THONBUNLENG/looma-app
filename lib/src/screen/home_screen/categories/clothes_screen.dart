import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/app_color.dart';
import '../../../logic/bloc/product/product_bloc.dart';
import '../../../model/product_model.dart';
import '../../../network/repository/product_repository.dart';
import '../filter/filter_screen.dart';
import '../product_detail/product_clothes_screen.dart';

class ClothesScreen extends StatefulWidget {
  final String categoryName;

  const ClothesScreen({
    super.key,
    this.categoryName = "Clothes",
  });

  @override
  State<ClothesScreen> createState() => _ClothesScreenState();
}

class _ClothesScreenState extends State<ClothesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  late ProductBloc _productBloc;
  String _searchQuery = "";

  // Map tab index to Firestore category names
  final List<String> _categoryMap = [
    'activewear', // Using first category as "All" for now or specifically 'activewear'
    'polos',
    'activewear',
    'jackets',
    'jeans',
    'joggers',
    'leggings',
    'pants',
    'shirts',
    'skirt',
    'suits',
    'sweatshirts',
    'tShirts',
    'blouses',
    'cardigans',
    'coats',
    'dresses',
    'hoodies',
    'shorts',
    'skirts',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categoryMap.length, vsync: this);
    _searchController = TextEditingController();
    _productBloc = ProductBloc(ProductRepository());
    
    // Initial fetch
    _fetchProducts();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchProducts();
      }
    });
  }

  void _fetchProducts() {
    final category = _categoryMap[_tabController.index];
    _productBloc.add(FetchProductsByCategory(category));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColor.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return BlocProvider.value(
      value: _productBloc,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: textColor),
          title: TextWidget(
            widget.categoryName.tr.toUpperCase(),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: textColor,
            letterSpacing: 1.2,
          ),
          actions: [
            const CartBadge(),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(115),
            child: Column(
              children: [
                _buildSearchBar(context, isDark),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: textColor,
                  labelColor: textColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: [
                    Tab(text: "All".tr),
                    Tab(text: "Polos".tr),
                    Tab(text: "Activewear".tr),
                    Tab(text: "Jackets".tr),
                    Tab(text: "Jeans".tr),
                    Tab(text: "Joggers".tr),
                    Tab(text: "Leggings".tr),
                    Tab(text: "Pants".tr),
                    Tab(text: "Shirts".tr),
                    Tab(text: "Skirt".tr),
                    Tab(text: "Suits".tr),
                    Tab(text: "Sweatshirts".tr),
                    Tab(text: "T-Shirts".tr),
                    Tab(text: "Blouses".tr),
                    Tab(text: "Cardigans".tr),
                    Tab(text: "Coats".tr),
                    Tab(text: "Dresses".tr),
                    Tab(text: "Essential Hoodies".tr),
                    Tab(text: "Shorts".tr),
                    Tab(text: "Skirts".tr),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                int count = 0;
                if (state is ProductLoaded) {
                  count = state.products.length;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextWidget(
                    '{0} items found'.trArgs([count.toString()]),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    return _buildProductGrid(state.products, isDark);
                  } else if (state is ProductError) {
                    return Center(child: TextWidget(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _searchQuery = value;
                  _productBloc.add(SearchProducts(value, _categoryMap[_tabController.index]));
                },
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search in {0}...".trArgs([widget.categoryName.tr]),
                  hintStyle: TextStyle(color: hintColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, size: 22, color: hintColor),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.cancel_rounded, size: 20, color: hintColor),
                          onPressed: () {
                            _searchController.clear();
                            _searchQuery = "";
                            _fetchProducts();
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilterScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  TextWidget(
                    "filter".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> items, bool isDark) {
    if (items.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildProductCard(context, item, isDark, index);
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel item,
    bool isDark,
    int index,
  ) {
    final String imageUrl = item.images.isNotEmpty ? item.images.first : '';
    final String title = item.title;
    final String price = "\$${item.price.toStringAsFixed(2)}";
    final bool isFavorite = false; // Add state management for favorites later

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductClothesScreen(product: item.toMap()),
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
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColor.grey100,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl.isNotEmpty
                          ? Hero(
                              tag: 'clothes_${item.id ?? index}',
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.grey[300],
                                  ),
                                ),
                                errorWidget: (_, _, _) => Container(
                                  color: isDark
                                      ? Colors.white10
                                      : AppColor.grey100,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: isDark ? Colors.white10 : AppColor.grey100,
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://www.pngitem.com/pimgs/m/255-2550411_no-image-available-png-transparent-no-image-available.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFavorite
                              ? Colors.redAccent
                              : Colors.black26,
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
                  fontSize: 16,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  title.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColor.black,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  price,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
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
          const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          TextWidget(
            _searchQuery.isEmpty
                ? "No clothes found in this category".tr
                : "${"No items found for".tr} '$_searchQuery'",
            color: isDark ? Colors.white38 : Colors.grey,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
