import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsTabContent extends StatelessWidget {
  const ContactUsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildContactCard(
          context,
          Icons.email_outlined,
          "Email us".tr,
          "customer.care@loomakh.com",
          () => _launchUrl('mailto:customer.care@loomakh.com'),
        ),
        _buildContactCard(
          context,
          Icons.phone_outlined,
          "Phone us".tr,
          "(+855) 011820595",
          () => _launchUrl('tel:+855011820595'),
        ),
        _buildContactCard(
          context,
          Icons.send_outlined,
          "Telegram".tr,
          "https://t.me/Mysupportcare",
          () => _launchUrl('https://t.me/LoomaMysupportcare'),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildContactCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: TextWidget(
          title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: TextWidget(
            value,
            fontSize: 14,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white24 : Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }
}
