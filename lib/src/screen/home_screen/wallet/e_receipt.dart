import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/wallet/t_history.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../constants/app_color.dart';
import 'more.dart';

class EReceiptScreen extends StatelessWidget {
  final TransactionModel transaction;

  const EReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTopUp = transaction.type == TransactionType.topUp;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: TextWidget(
          isTopUp ? 'Transaction Details'.tr : 'E-Receipt'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/more.png',
              fit: BoxFit.fill,
              height: 20,
              width: 20,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => EReceiptActionsWidget(
                  onShare: () => Navigator.pop(context),
                  onDownload: () => Navigator.pop(context),
                  onPrint: () => Navigator.pop(context),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: isTopUp ? _buildBankStyleContent(context) : _buildProductStyleContent(context),
      ),
    );
  }

  Widget _buildProductStyleContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildBarcodeSection(context),
        const SizedBox(height: 30),
        _buildInfoCard(
          context,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  transaction.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image),
                ),
              ),
            ),
            title: TextWidget(
              transaction.title.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: TextWidget(
              '${"Qty".tr} = 1',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      '${"Color".tr} ',
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8D6E63),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                TextWidget(
                  '${"Size".tr} = 40',
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ),
        _buildInfoCard(
          context,
          child: Column(
            children: [
              _buildRow(context, 'Amount'.tr, transaction.amount),
              const SizedBox(height: 12),
              _buildRow(
                context,
                'Promo'.tr,
                '- \$112.50',
                valueColor: Colors.red,
              ),
              Divider(
                height: 30,
                color: isDark
                    ? Colors.white10
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              _buildRow(
                context,
                'Total'.tr,
                transaction.amount,
                isBold: true,
              ),
            ],
          ),
        ),
        _buildInfoCard(
          context,
          child: Column(
            children: [
              _buildRow(context, 'Payment Methods'.tr, 'My E-Wallet'.tr),
              const SizedBox(height: 12),
              _buildRow(context, 'Date'.tr, transaction.date),
              const SizedBox(height: 12),
              _buildTransactionIdRow(
                context,
                'Transaction ID'.tr,
                'SK7263727399',
              ),
              const SizedBox(height: 12),
              _buildStatusRow(context, 'Status'.tr, 'Paid'.tr),
            ],
          ),
        ),
        _buildInfoCard(
          context,
          child: _buildRow(context, 'Category'.tr, 'Orders'.tr),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBankStyleContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white;

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            border: isDark ? Border.all(color: Colors.white10) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildBankHeader(context),
              const SizedBox(height: 20),
              _buildDashedLine(context),
              const SizedBox(height: 20),
              _buildBankDetails(context),
              const SizedBox(height: 25),
            ],
          ),
        ),
        const SizedBox(height: 25),
        _buildBankActions(context),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBankHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 1.5),
          ),
          child: const Icon(Icons.call_made_rounded, color: Colors.redAccent, size: 30),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              '-${transaction.amount}',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            TextWidget(
              'USD',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextWidget(
          "Transfer to ${transaction.title}",
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildBankDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildBankDetailRow("Trx. ID:", "9062141757"),
          _buildBankDetailRow("Original amount:", transaction.amount),
          _buildBankDetailRow("From account:", "PHEAP NIY SEAN (000 536 181)"),
          _buildBankDetailRow("Reference #:", "100FT30591363035"),
          _buildBankDetailRow("Transaction date:", transaction.date),
          _buildBankDetailRow("To account:", "001212518", isLast: true),
        ],
      ),
    );
  }

  Widget _buildBankDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextWidget(
              label.tr,
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            flex: 3,
            child: TextWidget(
              value,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: DashedLinePainter(
        color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildBankActions(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(
          context,
          icon: Icons.file_download_outlined,
          title: "Download as PDF",
          subtitle: "Save these transaction details as PDF.",
          onTap: () {},
        ),
        _buildActionTile(
          context,
          icon: Icons.refresh_rounded,
          title: "Repeat transaction",
          subtitle: "Make another transaction by repeating the sending info.",
          onTap: () {},
        ),
        _buildActionTile(
          context,
          icon: Icons.star_border_rounded,
          title: "Save to Template",
          subtitle: "Save this receiver to a Quick Template.",
          onTap: () {},
        ),
        _buildActionTile(
          context,
          icon: Icons.history_rounded,
          title: "View transaction history",
          subtitle: "See all transaction history of this receiver.",
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Icon(icon, color: const Color(0xFF004D8C), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title.tr,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF004D8C),
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    subtitle.tr,
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Image.asset(
          'assets/icon/i_color/receipt.png',
          height: 180,
          color: isDark ? Colors.white : Colors.black,
        ),
        const SizedBox(height: 10),
        TextWidget(
          '273628           837279',
          letterSpacing: 2,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey, fontSize: 14),
        TextWidget(
          value,
          fontSize: 14,
          color: valueColor ?? (isDark ? Colors.white : Colors.black),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildTransactionIdRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey, fontSize: 14),
        Row(
          children: [
            TextWidget(
              value,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icon/i_color/copy.png',
              height: 16,
              width: 16,
              color: AppColor.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(label, color: Colors.grey, fontSize: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextWidget(
            status,
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
