import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/screen/home_screen/search/visual_search_screen.dart' hide allItems;
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../widget/show_dialog.dart';
import '../../list_url.dart';
import '../product_detail/product_shoes_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> searchHistory = [
    "Socks",
    "Red Dress",
    "Sunglasses",
    "Mustard Pants",
    "80-s Skirt",
  ];


  List<Map<String, dynamic>> filteredProducts = [

  ];
  bool isSearching = false;

  final List<String> recommendations = [
    "Skirt",
    "Accessories",
    "Black T-Shirt",
    "Jeans",
    "White Shoes",
  ];

  void _onSearchAction(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredProducts = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredProducts = allItems.where((item) {
        final title = (item['title'] ?? '').toString().toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  void _addToHistory(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      if (searchHistory.contains(query)) {
        searchHistory.remove(query);
      }
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory.removeLast();
      }
    });
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Clear History?",
        message: "Are you sure you want to delete all search history?",
        btn1Text: "Clear All",
        btn2Text: "Cancel",
        imagePath: 'assets/icon/delete.png',
        iconColor: AppColor.saleRed,
        onBtn1Pressed: () {
          setState(() => searchHistory.clear());
          Navigator.pop(context);
        },
        onBtn2Pressed: () => Navigator.pop(context),
      ),
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(isDark),
              const SizedBox(height: 35),

              if (!isSearching) ...[
                if (searchHistory.isNotEmpty) ...[
                  _buildSectionTitle(
                    "Search history",
                    isDark,
                    onClear: _showClearDialog,
                  ),
                  const SizedBox(height: 15),
                  _buildChipWrap(searchHistory, true, isDark),
                  const SizedBox(height: 40),
                ],
                _buildSectionTitle("Recommendations", isDark),
                const SizedBox(height: 15),
                _buildChipWrap(recommendations, false, isDark),
                const SizedBox(height: 40),
                _buildSectionTitle("Discover", isDark),
                const SizedBox(height: 20),
                _buildDiscoverList(isDark),
              ],

              if (isSearching) ...[
                TextWidget(
                  'Results for "${_searchController.text}"',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 20),
                filteredProducts.isEmpty
                    ? _buildNotFound()
                    : _buildResultGrid(isDark),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchAction,
              onSubmitted: _addToHistory,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 20,
                ),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black26,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF0055FF),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VisualSearchScreen(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () {
            if (isSearching) {
              _searchController.clear();
              _onSearchAction("");
            } else {
              Navigator.pop(context);
            }
          },
          child: TextWidget(
            "Cancel",
            color: AppColor.saleRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    bool isDark, {
    VoidCallback? onClear,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        if (onClear != null)
          GestureDetector(
            onTap: onClear,
            child: TextWidget(
              "Clear all",
              color: AppColor.saleRed,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Widget _buildChipWrap(List<String> list, bool isHistory, bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: list
          .map(
            (tag) => _buildChip(
              label: tag,
              isHistory: isHistory,
              isDark: isDark,
              onTap: () {
                _searchController.text = tag;
                _onSearchAction(tag);
              },
              onDelete: () => setState(() => searchHistory.remove(tag)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildResultGrid(bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) =>
          _buildItemCard(filteredProducts[index], isDark, index),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> product, bool isDark, int index) {
    final String imageUrl =
        (product['images'] != null && (product['images'] as List).isNotEmpty)
        ? product['images'][0]
        : (product['image'] ?? '');

    return GestureDetector(
      onTap: () {
        _addToHistory(_searchController.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductShoesScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: imageUrl + index.toString(),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: isDark ? Colors.white10 : Colors.grey[100],
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextWidget(
            product['title'] ?? '',
            maxLines: 1,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          TextWidget(
            product['price'] ?? '',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColor.primaryColor : Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverList(bool isDark) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: discoverProducts.length,
        itemBuilder: (context, index) =>
            _buildItemCard(discoverProducts[index], isDark, index),
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Lottie.asset('assets/lottie/not-found.json', width: 180, height: 180),
          const SizedBox(height: 10),
          TextWidget("No products found", fontSize: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isHistory = false,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              label,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            if (isHistory) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.close, size: 14, color: AppColor.saleRed),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

