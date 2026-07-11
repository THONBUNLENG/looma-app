
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';

import 'text_widget.dart';

class LoadImageNetwork extends StatelessWidget {
  const LoadImageNetwork({super.key, required this.imageUrl, this.boxFit});

  final String imageUrl;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        height: 150,
        width: double.infinity,
        color: AppColor.grey200,
      ),
      errorWidget: (context, url, error) => Container(
        height: 150,
        width: double.infinity,
        alignment: Alignment.center,
        color: AppColor.grey100,
        child: TextWidget(
          'No image',
          fontSize: 16.0,
          color: AppColor.grey,
          context: context,
        ),
      ),
      imageBuilder: (context, image) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(fit: boxFit ?? BoxFit.cover, image: image)),
      ),
    );
  }
}

