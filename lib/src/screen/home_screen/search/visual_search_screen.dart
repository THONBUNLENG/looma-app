import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';

final List<Map<String, String>> allItems = [];

enum SearchStatus { capturing, processing, recognized }

class VisualSearchScreen extends StatefulWidget {
  const VisualSearchScreen({super.key});

  @override
  State<VisualSearchScreen> createState() => _VisualSearchScreenState();
}

class _VisualSearchScreenState extends State<VisualSearchScreen> {
  SearchStatus status = SearchStatus.capturing;
  File? _imageFile;
  List<Map<String, String>> visualSearchResults = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: _imageFile != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      ),
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Center(
                        child: Hero(
                          tag: 'search_image',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(_imageFile!, fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ],
                  )
                : _buildEmptyState(),
          ),


          if (status == SearchStatus.processing)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.3)),
              ),
            ),


          if (status == SearchStatus.recognized)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8 * value,
                    height: MediaQuery.of(context).size.width * 0.7 * value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppColor.primaryColor,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status != SearchStatus.capturing) _buildScanningIndicator(),
                const SizedBox(height: 30),
                _buildActionButtons(isDark),
                const SizedBox(height: 50),
              ],
            ),
          ),


          if (status == SearchStatus.recognized) _buildProductResults(isDark),


          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Color(0xFF121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            TextWidget(
              "Point at an item to search",
              color: Colors.white38,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          TextWidget(
            status == SearchStatus.processing
                ? "Analyzing Image..."
                : "AI Recognition Complete",
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          const LinearProgressIndicator(
            backgroundColor: Colors.white10,
            color: AppColor.primaryColor,
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    if (status == SearchStatus.capturing) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallIcon(
              'Gallery',
              Icons.photo_library_outlined,
              _handlePickImage,
            ),
            _buildLargeCameraButton(),
            _buildSmallIcon('Flash', Icons.flash_on_outlined, () {}),
          ],
        ),
      );
    } else {
      return IconButton(
        onPressed: () => setState(() {
          status = SearchStatus.capturing;
          _imageFile = null;
        }),
        icon: const Icon(Icons.refresh, size: 30, color: Colors.black),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildLargeCameraButton() {
    final isEnabled = _imageFile != null;
    return GestureDetector(
      onTap: isEnabled ? _startSearch : null,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: isEnabled ? AppColor.primaryColor : Colors.white24,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.search, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildSmallIcon(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white12,
            radius: 25,
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          TextWidget(label, color: Colors.white, fontSize: 12),
        ],
      ),
    );
  }

  Future<void> _handlePickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        status = SearchStatus.capturing;
      });
      _startSearch();
    }
  }

  void _startSearch() {
    HapticFeedback.heavyImpact();
    setState(() => status = SearchStatus.processing);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Mock data logic
        setState(() {
          visualSearchResults = List.generate(
            10,
            (index) => {
              'title': 'Detected Item ${index + 1}',
              'price': '\$${(index + 1) * 25}.00',
              'image': 'https://picsum.photos/200/200?random=$index',
            },
          );
          status = SearchStatus.recognized;
        });
      }
    });
  }

  Widget _buildProductResults(bool isDark) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    TextWidget(
                      "AI Matches Found",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    const Spacer(),
                    TextWidget(
                      "${visualSearchResults.length} items",
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: visualSearchResults.length,
                  itemBuilder: (context, index) => _buildResultItem(
                    visualSearchResults[index],
                    index,
                    isDark,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultItem(Map<String, String> item, int index, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item['image'] ?? "",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  item['title'] ?? "",
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  item['price'] ?? "",
                  color: AppColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: isDark ? Colors.white24 : Colors.black12,
          ),
        ],
      ),
    );
  }
}
