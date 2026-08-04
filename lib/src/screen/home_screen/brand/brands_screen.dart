import 'package:shopping_app/src/widget/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/model/brand_model.dart';
import 'package:shopping_app/src/screen/home_screen/universal_product_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'all_brands_screen.dart';
import 'bloc/brand_bloc.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      BrandBloc()
        ..add(LoadBrands()),
      child: const BrandsView(),
    );
  }
}

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Featured Brands",
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllBrandsScreen(),
                    ),
                  );
                },
                child: TextWidget(
                  "SEE MORE",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 125,
          child: BlocBuilder<BrandBloc, BrandState>(
            builder: (context, state) {
              if (state is BrandLoading) {
                return LoadingWidget.loadingCenterWidget();
              } else if (state is BrandLoaded) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.brands.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final brand = state.brands[index];
                    return BrandsCircle(
                      brand: brand,
                    );
                  },
                );
              } else if (state is BrandError) {
                return Center(
                    child: TextWidget(state.message, color: Colors.red));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class BrandsCircle extends StatelessWidget {
  final BrandModel brand;

  const BrandsCircle({
    super.key,
    required this.brand,
  });

  void _showBrandDetails(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white10 : Colors.grey[100],
                  ),
                  child: brand.logo.startsWith('http')
                      ? CachedNetworkImage(
                    imageUrl: brand.logo,
                    fit: BoxFit.contain,
                    color: isDark ? Colors.white : Colors.black,
                  )
                      : Image.asset(
                    brand.logo,
                    fit: BoxFit.contain,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextWidget(
                  brand.name,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 12),
                TextWidget(
                  brand.description,
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  lineHeight: 1.5,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UniversalProductScreen(
                                title: brand.name,
                                brandName: brand.name,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: TextWidget("VIEW PRODUCTS", color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => _showBrandDetails(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors
                    .white,
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: brand.logo.startsWith('http')
                      ? CachedNetworkImage(
                    imageUrl: brand.logo,
                    width: 40,
                    height: 40,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fit: BoxFit.contain,
                    placeholder: (context,
                        url) => const CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  )
                      : Image.asset(
                    brand.logo,
                    width: 40,
                    height: 40,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 75,
              child: TextWidget(
                brand.name,
                textAlign: TextAlign.center,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
