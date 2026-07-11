import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../list_url.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextWidget(
            "Brands",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: brandData.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return BrandsCircle(
                imagePath: brandData[index]['image']!,
                brandName: brandData[index]['name']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class BrandsCircle extends StatelessWidget {
  final String imagePath;
  final String brandName;

  const BrandsCircle({
    super.key,
    required this.imagePath,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white,
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
                child: Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, color: Colors.grey);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 75,
            child: TextWidget(
              brandName,
              textAlign: TextAlign.center,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
