import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'bloc/brand_bloc.dart';
import '../../../model/brand_model.dart';
import '../universal_product_screen.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F9);

    return BlocProvider(
      create: (context) => BrandBloc()..add(LoadBrands()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: TextWidget("All Brands", fontWeight: FontWeight.bold, fontSize: 18),
          centerTitle: true,
          backgroundColor: backgroundColor,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: BlocBuilder<BrandBloc, BrandState>(
          builder: (context, state) {
            if (state is BrandLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is BrandLoaded) {
              if (state.brands.isEmpty) {
                return Center(
                  child: TextWidget("No brands available", color: Colors.grey),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: state.brands.length,
                itemBuilder: (context, index) {
                  final brand = state.brands[index];
                  return _BrandCard(brand: brand, isDark: isDark);
                },
              );
            } else if (state is BrandError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextWidget(state.message, color: Colors.red, textAlign: TextAlign.center),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final BrandModel brand;
  final bool isDark;

  const _BrandCard({required this.brand, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.grey.shade200;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UniversalProductScreen(
                title: brand.name,
                brandName: brand.name,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : const Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: brand.logo.startsWith('http')
                      ? Image.network(
                          brand.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.storefront_outlined,
                            color: isDark ? Colors.white54 : Colors.grey,
                            size: 28,
                          ),
                        )
                      : Image.asset(
                          brand.logo,
                          fit: BoxFit.contain,
                          color: isDark ? Colors.white : Colors.black,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.storefront_outlined,
                            color: isDark ? Colors.white54 : Colors.grey,
                            size: 28,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              TextWidget(
                brand.name,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
