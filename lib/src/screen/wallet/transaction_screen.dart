import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/wallet/t_history.dart';
import 'e_receipt.dart';



class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Transaction History',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icon/search.png',
              height: 20,
              width: 20,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: mockTransactions.length,
        separatorBuilder: (_, _) => Divider(
          height: 30,
          color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          return _TransactionItemTile(
            transaction: mockTransactions[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EReceiptScreen(
                    transaction: mockTransactions[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TransactionItemTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const _TransactionItemTile({
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
                  placeholder: (_, _) => const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, _, _) => const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? Colors.white60 : Colors.grey,
                    ),
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
                  Text(
                    transaction.amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: transaction.type == TransactionType.topUp
                          ? Colors.green
                          : (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        transaction.type.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isDark ? Colors.white54 : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: transaction.type.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(

                            Icons.shopping_bag_outlined,
                            size: 10,
                            color: transaction.type.color
                        ),
                      ),
                    ],
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
