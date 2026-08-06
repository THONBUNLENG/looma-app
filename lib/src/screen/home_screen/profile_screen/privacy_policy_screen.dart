import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Privacy Policy'.tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.security_outlined, size: 50, color: Colors.blue),
                  const SizedBox(height: 15),
                  TextWidget(
                    "Your privacy is important to us".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    "Please read our policy to understand how we protect your personal data.".tr,
                    fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSection(
              context,
              "1. Types of Data We Collect",
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
            ),
            _buildSection(
              context,
              "2. Use of Your Personal Data",
              "Magna etiam tempor orci eu lobortis elementum nibh. Vulputate enim nulla aliquet porttitor lacus. Orci sagittis eu volutpat odio. Cras semper auctor neque vitae tempus quam pellentesque nec. Non quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor. Commodo elit at imperdiet dui.",
            ),
            _buildSection(
              context,
              "3. Disclosure of Your Personal Data",
              "Consequat id porta nibh venenatis cras sed. Ipsum nunc aliquet bibendum enim facilisis gravida neque. Nibh tellus molestie nunc non blandit massa. Quam pellentesque nec nam aliquam sem et tortor consequat id. Faucibus vitae aliquet nec ullamcorper sit amet risus. Nunc consequat interdum varius sit amet.",
            ),
            _buildSection(
              context,
              "4. Data Retention Policy",
              "Amet cursus sit amet dictum sit amet justo donec enim. Metus vulputate eu scelerisque felis imperdiet proin fermentum. Elit ut aliquam purus sit amet luctus venenatis lectus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames.",
            ),
            _buildSection(
              context,
              "5. Your Rights and Choices",
              "Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. Platea dictumst quisque sagittis purus sit amet volutpat. Turpis egestas pretium aenean pharetra magna ac placerat vestibulum. Id velit ut tortor pretium viverra suspendisse.",
            ),
            _buildSection(
              context,
              "6. Updates to This Policy",
              "Ultrices eros in cursus turpis massa tincidunt dui ut ornare. Risus feugiat in ante metus dictum at tempor commodo. Convallis a cras semper auctor neque vitae tempus quam. Porttitor leo a diam sollicitudin tempor id eu nisl nunc mi ipsum faucibus.",
            ),
            const SizedBox(height: 20),
            Center(
              child: TextWidget(
                "Last updated: October 2023".tr,
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextWidget(
                  title.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: TextWidget(
              content.tr,
              textAlign: TextAlign.justify,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
