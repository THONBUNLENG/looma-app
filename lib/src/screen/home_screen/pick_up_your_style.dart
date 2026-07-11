import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class PickStyleSection extends StatelessWidget {
  const PickStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    final List<Map<String, String>> styleBanners = [
      {
        "title": "TAG SPACE",
        "subtitle": "DISCOVER ASIA'S TRENDIEST BRANDS",
        "image": "https://images2.alphacoders.com/133/1331577.jpeg",
      },
      {
        "title": "OLD MONEY",
        "subtitle": "LUXURY MINIMAL FASHION",
        "image": "https://media.gettyimages.com/id/2061901079/video/paris-france-a-model-walks-the-runway-during-the-saint-laurent-men-collection-fall-winter.jpg?s=640x640&k=20&c=TRDCy-ioWbl4Z2Uw73iBDuiq_UUMAgDdHmuxPopfmRI=",
      },
      {
        "title": "STREETWEAR",
        "subtitle": "URBAN STYLE COLLECTION",
        "image": "https://images.pexels.com/photos/28773269/pexels-photo-28773269/free-photo-of-stylish-urban-fashion-portrait-of-young-adults.jpeg",
      },
      {
        "title": "NORDIC ESSENCE",
        "subtitle": "CLEAN LINES & NEUTRAL TONES",
        "image": "https://static.vecteezy.com/system/resources/thumbnails/047/885/544/small/korean-stylish-young-woman-in-a-casual-outfit-holds-shopping-bags-while-smiling-sale-black-friday-photo.jpg",
      },
      {
        "title": "AVANT GARDE",
        "subtitle": "REDEFINING MODERN SILHOUETTES",
        "image": "https://img.freepik.com/free-photo/portrait-young-beautiful-brunette-girl-black-hat_176420-8486.jpg",
      },
      {
        "title": "CORE CLASSICS",
        "subtitle": "TIMELESS PIECES FOR EVERYDAY",
        "image": "https://p16-capcut-sign-useast5.capcutcdn-us.com/tos-useast5-v-3741c799-tx/ogmX4TEJQJrSKXAlf86qqgR4NeAKfMTqVAQgHC~tplv-4d650qgzx3-1:250:0.webp?lk3s=44acef4b&x-expires=1808466249&x-signature=Wm4kdQwe9t9z60nXHUdM8FlIwQU%3D",
      },
      {
        "title": "RETRO WAVE",
        "subtitle": "VINTAGE INSPIRED STYLES",
        "image": "https://img.freepik.com/free-photo/fashionable-boutique-owner-measures-dress-black-white-studio-generated-by-ai_188544-11428.jpg?semt=ais_hybrid&w=740&q=80",
      },
      {
        "title": "EVENING NOIR",
        "subtitle": "ELEGANT NIGHTLIFE ATTIRE",
        "image": "https://images.pexels.com/photos/8427644/pexels-photo-8427644.jpeg?cs=srgb&dl=pexels-cottonbro-8427644.jpg&fm=jpg",
      },
      {
        "title": "TECHWEAR",
        "subtitle": "FUNCTIONAL MEETS FASHION",
        "image": "https://img.magnific.com/free-photo/graceful-fashion-model-trendy-hat-autumn-white-jacket-posing_273443-3847.jpg?semt=ais_hybrid&w=740&q=80",
      },
      {
        "title": "ZEN MINIMALISM",
        "subtitle": "PEACEFUL & ETHICAL APPAREL",
        "image": "https://www.shutterstock.com/image-photo/fulllength-portrait-glamorous-female-model-600nw-2667737659.jpg",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextWidget(
            "Pick Up Your Style",
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 420,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 20, right: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: styleBanners.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = styleBanners[index];

              return _StyleCard(
                title: item['title']!,
                subtitle: item['subtitle']!,
                image: item['image']!,
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StyleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool isDark;

  const _StyleCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(imageUrl: image, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                        const SizedBox(height: 6),
                        TextWidget(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
