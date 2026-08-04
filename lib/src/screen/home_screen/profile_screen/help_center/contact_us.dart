import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class ContactUsTabContent extends StatelessWidget {
  const ContactUsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildContactCard(
          context,
          "assets/icon/i_color/customer_service.png",
          "Customer Service".tr,
          () {},
        ),
        _buildContactCard(
          context,
          "assets/icon/i_color/website.png",
          "Website".tr,
          () {},
        ),
        _buildContactCard(
          context,
          "assets/icon/i_color/fb.png",
          "Facebook".tr,
          () {},
        ),
        _buildContactCard(
          context,
          "assets/icon/i_color/telegram.png",
          "Telegram".tr,
          () {},
        ),
        _buildContactCard(
          context,
          "assets/icon/i_color/instagram.png",
          "Instagram".tr,
          () {},
        ),
      ],
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    String imagePath,
    String title,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Image.asset(
          imagePath,
          width: 28,
          height: 28,
          color: isDark ? Colors.white : Colors.black,
          colorBlendMode: BlendMode.srcIn,
        ),
        title: TextWidget(
          title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.white24 : Colors.black12,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
