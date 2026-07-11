import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/screen/wallet/transaction_screen.dart';

import 'e_receipt.dart';


enum TransactionType {
  order(
    label: 'Orders',
    iconPath:'assets/icon/i_color/south_west.png',
    color: Colors.redAccent,
  ),
  topUp(
    label: 'Top Up',
    iconPath: 'assets/icon/i_color/arrow_outward.png',
    color: Colors.blueAccent,
  );

  final String label;
  final String? iconPath;
  final Color color;


  const TransactionType({
    required this.label,
    this.iconPath,
    required this.color,
  });

  Widget buildIcon({double size = 12, Color color = Colors.white}) {
    if (iconPath != null) {
      return Image.asset(
        iconPath!,
        width: size,
        height: size,
        color: color,
      );
    }
    return Icon(iconPath as IconData?, size: size, color: color);
  }
}

class TransactionModel {
  final String title;
  final String date;
  final String amount;
  final String imageUrl;
  final TransactionType type;

  TransactionModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.imageUrl,
    required this.type,
  });
}

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransactionModel> transactions = mockTransactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return _TransactionItemTile(
                transaction: tx,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EReceiptScreen(transaction: tx),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transaction History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionHistorySection(),
                ),
              );
            },
            child: const Text('See All', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
class _TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const _TransactionItemTile({
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: transaction.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildErrorWidget(),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _buildTypeBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          transaction.type.label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: transaction.type.color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: transaction.type.buildIcon(size: 12, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.broken_image_outlined, color: Colors.grey[400]),
    );
  }
}