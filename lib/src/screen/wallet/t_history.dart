import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/src/screen/wallet/transaction_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import 'e_receipt.dart';

enum TransactionType {
  order(
    label: 'Orders',
    iconPath: 'assets/icon/i_color/south_west.png',
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
      return Image.asset(iconPath!, width: size, height: size, color: color);
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
            separatorBuilder: (_, _) => const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return TransactionItemTile(
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
          TextWidget(
            'Transaction History',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
            child: TextWidget('See All', color: Colors.blue),
          ),
        ],
      ),
    );
  }
}

class TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionItemTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F3F3),
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
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    transaction.title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    transaction.date,
                    fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextWidget(
                    transaction.amount,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == TransactionType.topUp
                        ? Colors.green
                        : (isDark ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 6),
                  _buildTypeBadge(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          transaction.type.label,
          fontSize: 12,
          color: isDark ? Colors.white54 : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: transaction.type.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: transaction.type.buildIcon(
            size: 10,
            color: transaction.type.color,
          ),
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

final List<TransactionModel> mockTransactions = [
  TransactionModel(
    title: 'Suga Leather Shoes',
    date: 'Dec 15, 2024 | 10:00 AM',
    amount: '\$262.5',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRztGaV0swXFptukOwXmVGq4WSZTDi8GXdCvA&s',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Dec 14, 2024 | 16:42 PM',
    amount: '\$500.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: 'Werolla Cardigans',
    date: 'Dec 14, 2024 | 11:39 AM',
    amount: '\$385.0',
    imageUrl:
        'https://shop.greekstylecouncil.com/cdn/shop/products/ioannakourbela2550-VerdiGris_1400x1400.jpg?v=1612145939',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Mini Leather Bag',
    date: 'Dec 13, 2024 | 14:46 PM',
    amount: '\$540.0',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPcS4cAclDFFKsWHvLOeAoR8emqBSRpL-l0A&s',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Dec 12, 2024 | 09:27 AM',
    amount: '\$550.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: 'Gaming Headset',
    date: 'Dec 11, 2024 | 18:15 PM',
    amount: '\$120.0',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw8RJQOOJ1ewqC1foGysc_6cygj5PC6v8FYw&s',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Women V-neck ',
    date: 'Dec 10, 2024 | 20:30 PM',
    amount: '\$85.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/e3/e3f47077a5657b3ecbd3f0f303df2ef54941097d.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Dec 09, 2024 | 12:00 PM',
    amount: '\$100.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: 'Smart Watch Pro',
    date: 'Dec 08, 2024 | 08:45 AM',
    amount: '\$299.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/34/345b3ecf6b8a09c56ba82b4867bdfcafcf0b1a36.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Women Short Skirts',
    date: 'Dec 07, 2024 | 14:20 PM',
    amount: '\$35.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/6a/6a3489614a97a0146be3566287aeb15d86584968.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Dec 06, 2024 | 10:10 AM',
    amount: '\$200.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: 'Polo Shirt',
    date: 'Dec 05, 2024 | 16:00 PM',
    amount: '\$45.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/ed/ed13e6241f9c1dcfcbf5d2a3cf75cd6644475167.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Long Pants',
    date: 'Dec 04, 2024 | 11:30 AM',
    amount: '\$75.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=600,h=600,fit=cover/b8/b86720a9c9b8fb0fdc768f4baf038c7a21d6ac6c.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Dec 03, 2024 | 15:55 PM',
    amount: '\$1000.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: ' Sleeve Shirt',
    date: 'Dec 02, 2024 | 13:12 PM',
    amount: '\$22.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=600,h=600,fit=cover/43/43dbed3533f7326e35b5ff8a8a424bfaa1c22dab.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Canvas Backpack',
    date: 'Dec 01, 2024 | 09:05 AM',
    amount: '\$65.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/4b/4bef4f7453b88ebdf08ea93078ef4b1aea8b2919.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Nov 30, 2024 | 19:40 PM',
    amount: '\$300.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
  TransactionModel(
    title: 'Winter Parka Coat',
    date: 'Nov 29, 2024 | 12:30 PM',
    amount: '\$180.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=600,h=600,fit=cover/79/79f0377669d7937bf73242aa8c0cf69d3928c100.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Men Long Sleeve Shirt',
    date: 'Nov 28, 2024 | 07:15 AM',
    amount: '\$110.0',
    imageUrl:
        'https://s9.kh1.co/__image/w=300,h=300,fit=contain/ce/cea765f5e73f3a84cb0f2cb93569b69c8a496d66.jpg',
    type: TransactionType.order,
  ),
  TransactionModel(
    title: 'Top Up Wallet',
    date: 'Nov 27, 2024 | 16:00 PM',
    amount: '\$50.0',
    imageUrl:
        'https://www.electronicpaymentsinternational.com/wp-content/uploads/sites/4/2024/12/mcard-feat-image.jpg',
    type: TransactionType.topUp,
  ),
];
