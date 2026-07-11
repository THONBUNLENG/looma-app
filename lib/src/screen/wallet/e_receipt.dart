import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/wallet/t_history.dart';

import '../../../constants/app_color.dart';
import 'more.dart';

class EReceiptScreen extends StatelessWidget {
  final TransactionModel transaction;

  const EReceiptScreen({super.key, required this.transaction});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'E-Receipt',
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
        child: Column(
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
                title: Text(
                  transaction.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Qty = 1', style: theme.textTheme.bodySmall),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Color ',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
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
                    const Text(
                      'Size = 40',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            _buildInfoCard(
              context,
              child: Column(
                children: [
                  _buildRow(context, 'Amount', transaction.amount),
                  const SizedBox(height: 12),
                  _buildRow(
                    context,
                    'Promo',
                    '- \$112.50',
                    valueColor: Colors.red,
                  ),
                  Divider(
                    height: 30,
                    color: isDark
                        ? Colors.white10
                        : Colors.grey.withValues(alpha: 0.1),
                  ),
                  _buildRow(context, 'Total', transaction.amount, isBold: true),
                ],
              ),
            ),
            _buildInfoCard(
              context,
              child: Column(
                children: [
                  _buildRow(context, 'Payment Methods', 'My E-Wallet'),
                  const SizedBox(height: 12),
                  _buildRow(context, 'Date', transaction.date),
                  const SizedBox(height: 12),
                  _buildTransactionIdRow(
                    context,
                    'Transaction ID',
                    'SK7263727399',
                  ),
                  const SizedBox(height: 12),
                  _buildStatusRow(context, 'Status', 'Paid'),
                ],
              ),
            ),

            _buildInfoCard(
              context,
              child: _buildRow(context, 'Category', 'Orders'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
         Image.asset('assets/icon/i_color/receipt.png', height: 180,
           color: isDark ? Colors.white : Colors.black,),
        const SizedBox(height: 10),
        Text(
          '273628           837279',
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? (isDark ? Colors.white : Colors.black),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
