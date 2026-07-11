import 'package:flutter/material.dart';
import 'package:shopping_app/src/screen/wallet/savings_account_card.dart';
import 'package:shopping_app/src/screen/wallet/t_history.dart';
import 'package:shopping_app/src/screen/wallet/wallet_card_screen.dart';
import 'package:shopping_app/src/screen/wallet/wallet_screen.dart';



class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}
class _MyWalletPageState extends State<MyWalletPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: WalletHeader(
        onAddCard: (card) {
          setState(() {});
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SavingsAccountCard(),
          const SizedBox(height: 20),
          const WalletCardScreen(cards: []),
          const SizedBox(height: 10),
          const Expanded(
            child: TransactionHistory(),
          ),
        ],
      ),
    );
  }
}

