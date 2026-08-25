import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class FullImageGallery extends StatelessWidget {
  final List<String> images;
  final String title;
  final String productId;
  final int initialIndex;
  const FullImageGallery({
    super.key,
    required this.images,
    required this.title,
    required this.productId,
    this.initialIndex = 0,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (initialIndex > 0 && initialIndex < images.length) {
        scrollController.jumpTo(initialIndex * 420.0);
      }
    });
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: TextWidget(
          title.tr.toUpperCase(),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: textColor, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Hero(
                tag: images[index] + productId,
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => Container(
                    height: 400,
                    color: isDark ? Colors.white10 : AppColor.grey100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 400,
                    color: isDark ? Colors.white10 : AppColor.grey100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_outlined, size: 40),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
