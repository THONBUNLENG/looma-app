import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Membership & Benefits'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  "PLATINUM",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:  Colors.black,
                ),
                InkWell(
                  onTap: () {},
                  child: TextWidget(
                    "Point history",
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextWidget(
              "You haven't made any success purchase yet.",
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            
            _buildMemberLevelSection(context, isDark),
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            
            _buildBenefitsSection(context, isDark),
            
            const SizedBox(height: 40),
            
            _buildInfoSection(context, isDark),
            
            const SizedBox(height: 30),
            TextWidget(
              "Terms & Conditions:",
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberLevelSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextWidget(
                "Member Level",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildLevelHeader("ONLINE", const Color(0xFFD9904D), false),
            _buildLevelHeader("SILVER", Colors.grey, false),
            _buildLevelHeader("GOLD", Colors.yellow[700]!, false),
            _buildLevelHeader("PLATINUM", Colors.black, true),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextWidget(
                "Spend (\$)/bill to unlock",
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            _buildLevelValue("Free!", isPrimary: true),
            _buildLevelValue("\$5000"),
            _buildLevelValue("\$10000", color: Colors.yellow[700]!),
            _buildLevelValue("\$100000"),
          ],
        ),
        const SizedBox(height: 8),
        TextWidget(
          "Point to unlock next member",
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      ],
    );
  }

  Widget _buildLevelHeader(String label, Color color, bool isSelected) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          TextWidget(
            label,
            fontSize: 10,
            color: color.withValues(alpha: isSelected ? 1.0 : 0.5),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          Icon(
            isSelected ? Icons.check_circle : Icons.circle,
            color: color.withValues(alpha: isSelected ? 1.0 : 0.3),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelValue(String value, {bool isPrimary = false, Color? color}) {
    return Expanded(
      flex: 2,
      child: Center(
        child: TextWidget(
          value,
          fontSize: 12,
          color: color ?? (isPrimary ? const Color(0xFFD9904D) : Colors.black26),
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Benefits",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        _buildBenefitRow("Apparel", "0", "10%", "15%", "20%"),
        _buildBenefitRow("Accessories", "0", "10%", "15%", "15%"),
        _buildBenefitRow("Shoes", "0", "10%", "15%", "15%"),
        _buildBenefitRow("Bag & Suitcase", "0", "10%", "15%", "15%"),
        _buildBenefitRow("Free delivery", "0", "0", "0", "0"),
      ],
    );
  }

  Widget _buildBenefitRow(String label, String v1, String v2, String v3, String v4) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextWidget(label, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          _buildBenefitValue(v1, isPrimary: true),
          _buildBenefitValue(v2),
          _buildBenefitValue(v3, color: Colors.yellow[700]!),
          _buildBenefitValue(v4),
        ],
      ),
    );
  }

  Widget _buildBenefitValue(String value, {bool isPrimary = false, Color? color}) {
    return Expanded(
      flex: 2,
      child: Center(
        child: TextWidget(
          value,
          fontSize: 14,
          color: color ?? (isPrimary ? const Color(0xFFD9904D) : Colors.black26),
          fontWeight: isPrimary ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, bool isDark) {
    const double lineSpacing = 8.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText("Point Earning: Earn 1 (Point) in every 10\$ spent at online & in-store of LOOMA Group."),
        const SizedBox(height: lineSpacing),
        _buildInfoText("Point Redemption: What's New!"),
        const SizedBox(height: lineSpacing),
        _buildInfoText("- 1 (Point) = 0.15\$ cash voucher which you can redeem online and in-store of LOOMA Group."),
        const SizedBox(height: lineSpacing),
        _buildInfoText("- Eligible with Sale and Non-Sale items."),
        const SizedBox(height: lineSpacing),
        _buildInfoText("- Can apply with your membership discount."),
        const SizedBox(height: lineSpacing),
        _buildInfoText("Point Expiration: Point will be expired when your profile isn't active (No Purchase) for one year."),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return TextWidget(
      text,
      fontSize: 14,
      lineHeight: 1.4,
      fontWeight: FontWeight.w500,
    );
  }
}
