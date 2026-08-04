import 'dart:async';
import 'package:shopping_app/src/network/crud_firebase/all_product.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/model/product_model.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';
import 'package:shopping_app/src/screen/home_screen/flash_sale/flash_sale_discount_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class TopSaleScreen extends StatefulWidget {
  const TopSaleScreen({super.key});

  @override
  State<TopSaleScreen> createState() => _TopSaleScreenState();
}

class _TopSaleScreenState extends State<TopSaleScreen> {
  late Timer _timer;
  Duration _timeLeft = const Duration(hours: 12, minutes: 4, seconds: 55);
  late Stream<List<ProductModel>> _productStream;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _productStream = _firestoreService.getProducts(category: 'FLASH_SALE');
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours : $minutes : $seconds";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<List<ProductModel>>(
      stream: _productStream,
      builder: (context, snapshot) {
        var products = snapshot.data ?? [];
        
        if (products.isEmpty && snapshot.connectionState != ConnectionState.waiting) {
           if (allItems.isNotEmpty) {
             products = [ProductModel.fromMap(allItems[0])];
           }
        }

        if (products.isEmpty) return const SizedBox.shrink();

        final imageUrl = products[0].images.isNotEmpty
            ? products[0].images[0]
            : '';

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Top Sale".tr,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FlashSaleDiscountScreen(imageUrl: imageUrl),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/image/bg_top_sale.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.3, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4B4B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextWidget(
                            "UP TO 70% OFF",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Flash Sale Ending In:".tr,
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  _formatDuration(_timeLeft),
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        "SHOP NOW".tr,
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
