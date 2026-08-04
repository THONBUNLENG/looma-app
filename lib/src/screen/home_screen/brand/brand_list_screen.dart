import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/cart_badge.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import 'bloc/brand_bloc.dart';
import '../../../model/brand_model.dart';
import '../universal_product_screen.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Man', 'Woman', 'Bag', 'Shoes'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => BrandBloc()..add(LoadBrands()),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF9F9F9),
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) =>
                LinearGradient(
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

          actions: [const CartBadge()],
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
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryTabs(isDark),
            const Divider(height: 1, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: TextWidget(
                "Brands",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Expanded(
              child: BlocBuilder<BrandBloc, BrandState>(
                builder: (context, state) {
                  if (state is BrandLoading) {
                    return LoadingWidget.loadingCenterWidget();
                  } else if (state is BrandLoaded) {
                    final filteredBrands = _filterBrands(state.brands);
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredBrands.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildBrandCard(filteredBrands[index], isDark);
                      },
                    );
                  } else if (state is BrandError) {
                    return Center(child: TextWidget(state.message, color: Colors.red));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BrandModel> _filterBrands(List<BrandModel> brands) {
    if (selectedCategory == 'All') return brands;
    
    return brands.where((brand) {
      return brand.categories.contains(selectedCategory.toUpperCase());
    }).toList();
  }

  Widget _buildCategoryTabs(bool isDark) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected 
                        ? (isDark ? Colors.white : Colors.black) 
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: TextWidget(
                category.tr,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? (isDark ? Colors.white : Colors.black) 
                    : (isDark ? Colors.white38 : Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandCard(BrandModel brand, bool isDark) {
    return GestureDetector(
      onTap: () {
        String? initialGender;
        String? category;

        if (selectedCategory == 'Man') {
          initialGender = 'Man';
        } else if (selectedCategory == 'Woman') {
          initialGender = 'Woman';
        } else if (selectedCategory == 'Bag') {
          category = 'BAGS';
        } else if (selectedCategory == 'Shoes') {
          category = 'SHOES';
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniversalProductScreen(
              title: brand.name,
              brandName: brand.name,
              initialGender: initialGender,
              category: category,
            ),
          ),
        );
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    brand.logo.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: brand.logo,
                            height: 55,
                            fit: BoxFit.contain,
                            color: isDark ? Colors.white : Colors.black,
                          )
                        : Image.asset(
                            brand.logo,
                            height: 55,
                            fit: BoxFit.contain,
                            color: isDark ? Colors.white : Colors.black,
                            errorBuilder: (context, error, stackTrace) => TextWidget(
                              brand.name.toUpperCase(),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: TextWidget(
                brand.name,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: isDark ? Colors.white38 : Colors.black26,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
