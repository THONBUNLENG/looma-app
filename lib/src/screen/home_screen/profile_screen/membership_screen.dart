import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';
import 'qr_scanner_screen.dart';
import 'souvenir_redemption_screen.dart';
import '../../../network/datastor/membership_service.dart';
import '../../../model/order_model.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: isDark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: MembershipService.getOrdersStream(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? [];
          final totalSpent = MembershipService.calculateTotalSpent(orders);
          final points = MembershipService.calculateAvailablePoints(orders);
          final level = MembershipService.getLevel(totalSpent);
          final membershipId = MembershipService.getMembershipId();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          level.label,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        TextWidget(
                          "ID: $membershipId",
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: TextWidget(
                        "Points: $points",
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextWidget(
                  totalSpent > 0
                      ? "Total spent: \$${totalSpent.toStringAsFixed(2)}"
                      : "You haven't made any success purchase yet.",
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),

                _buildMemberLevelSection(context, isDark, level),

                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 20),

                _buildBenefitsSection(context, isDark, level),

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
          );
        },
      ),
    );
  }

  Widget _buildMemberLevelSection(BuildContext context, bool isDark, MemberLevel currentLevel) {
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
            _buildLevelHeader("ONLINE", const Color(0xFFD9904D), currentLevel == MemberLevel.online),
            _buildLevelHeader("SILVER", Colors.grey, currentLevel == MemberLevel.silver),
            _buildLevelHeader("GOLD", Colors.yellow[700]!, currentLevel == MemberLevel.gold),
            _buildLevelHeader("PLATINUM", Colors.black, currentLevel == MemberLevel.platinum),
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
            _buildLevelValue("Free!", isPrimary: currentLevel == MemberLevel.online),
            _buildLevelValue("\$5000", isPrimary: currentLevel == MemberLevel.silver),
            _buildLevelValue("\$10000", color: Colors.yellow[700]!, isPrimary: currentLevel == MemberLevel.gold),
            _buildLevelValue("\$100000", isPrimary: currentLevel == MemberLevel.platinum),
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

  Widget _buildBenefitsSection(BuildContext context, bool isDark, MemberLevel currentLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          "Benefits",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        _buildBenefitRow("Apparel", "0", "10%", "15%", "20%", currentLevel),
        _buildBenefitRow("Accessories", "0", "10%", "15%", "15%", currentLevel),
        _buildBenefitRow("Shoes", "0", "10%", "15%", "15%", currentLevel),
        _buildBenefitRow("Bag & Suitcase", "0", "10%", "15%", "15%", currentLevel),
        _buildBenefitRow("Free delivery", "0", "0", "0", "0", currentLevel),
      ],
    );
  }

  Widget _buildBenefitRow(String label, String v1, String v2, String v3, String v4, MemberLevel currentLevel) {
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
          _buildBenefitValue(v1, isPrimary: currentLevel == MemberLevel.online),
          _buildBenefitValue(v2, isPrimary: currentLevel == MemberLevel.silver),
          _buildBenefitValue(v3, color: Colors.yellow[700]!, isPrimary: currentLevel == MemberLevel.gold),
          _buildBenefitValue(v4, isPrimary: currentLevel == MemberLevel.platinum),
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
        _buildInfoText("Point Earning: Earn 1 (Point) in every 25\$ spent at online & in-store of LOOMA Group."),
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
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SouvenirRedemptionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white10 : Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: TextWidget(
              "Redeem for Souvenirs".tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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