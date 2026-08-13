import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class PaymentDetails extends StatefulWidget {
  final Map<String, dynamic> order;
  const PaymentDetails({super.key, required this.order});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: TextWidget(
          "Payment Details".tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _buildHandle(context),
            const SizedBox(height: 20),
            _buildBankHeader(context),
            const SizedBox(height: 24),
            _buildDashedLine(context),
            const SizedBox(height: 24),
            _buildBankDetails(context),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 1),
            ),
            const SizedBox(height: 8),
            _buildBankActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildBankHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalAmount = widget.order['totalAmount'] ?? '0.00 USD';
    final paymentMethod = widget.order['paymentMethod'] ?? 'Unknown';
    final amountParts = totalAmount.split(' ');
    final amountValue = amountParts[0];
    final currency = amountParts.length > 1 ? amountParts[1] : 'USD';

    final bool isBank = paymentMethod.toString().toLowerCase().contains('bank');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isBank
                  ? Colors.redAccent.withValues(alpha: 0.5)
                  : Colors.greenAccent.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            isBank ? Icons.call_made_rounded : Icons.check_circle_outline,
            color: isBank ? Colors.redAccent : Colors.greenAccent,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              isBank ? '-$amountValue' : amountValue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            TextWidget(
              currency,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextWidget(
          isBank ? "Transfer to PHEAP NIY SEAN" : paymentMethod.toString().tr,
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: DashedLinePainter(
          color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildBankDetails(BuildContext context) {
    final paymentMethod = widget.order['paymentMethod'] ?? 'N/A';
    final bool isBank = paymentMethod.toString().toLowerCase().contains('bank');
    final pointsRedeemed = widget.order['pointsRedeemed'];
    final pointsRewarded = widget.order['pointsRewarded'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildBankDetailRow("Trx. ID:", widget.order['id'] ?? 'N/A'),
          _buildBankDetailRow("Payment Method:", paymentMethod.toString().tr),
          _buildBankDetailRow("Delivery Method:", (widget.order['deliveryMethod'] ?? 'Standard').toString().tr),
          if (pointsRedeemed != null && pointsRedeemed > 0)
            _buildBankDetailRow("Points Redeemed:", "$pointsRedeemed pts"),
          if (pointsRewarded != null && pointsRewarded > 0)
            _buildBankDetailRow("Points Received:", "+$pointsRewarded pts"),
          
          _buildBankDetailRow("Original amount:", widget.order['total'] ?? 'N/A'),
          if (isBank) ...[
            _buildBankDetailRow("From account:", "PHEAP NIY SEAN (000 536 181)"),
            _buildBankDetailRow("Reference #:", "100FT30591363035"),
            _buildBankDetailRow("To account:", "001212518"),
          ],
          _buildBankDetailRow("Transaction date:", widget.order['date'] ?? 'N/A', isLast: true),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(icon, color: Colors.blue[800], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    title.tr,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.blue[900],
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    subtitle.tr,
                    fontSize: 12,
                    color: Colors.grey,
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