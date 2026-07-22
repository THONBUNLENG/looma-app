import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/screen/home_screen/wallet/t_history.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'e_receipt.dart';

class TransactionHistorySection extends StatefulWidget {
  const TransactionHistorySection({super.key});

  @override
  State<TransactionHistorySection> createState() =>
      _TransactionHistorySectionState();
}

class _TransactionHistorySectionState extends State<TransactionHistorySection> {
  final TextEditingController _searchController = TextEditingController();
  List<TransactionModel> _filteredTransactions = mockTransactions;
  bool _isSearching = false;

  void _filterTransactions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTransactions = mockTransactions;
      } else {
        _filteredTransactions = mockTransactions
            .where(
              (tx) =>
                  tx.title.toLowerCase().contains(query.toLowerCase()) ||
                  tx.type.label.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search transactions...'.tr,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey,
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onChanged: _filterTransactions,
              )
            : TextWidget(
                'Transaction History'.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filteredTransactions = mockTransactions;
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _filteredTransactions.isEmpty
          ? Center(
              child: TextWidget(
                'No transactions found'.tr,
                color: isDark ? Colors.white60 : Colors.grey,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _filteredTransactions.length,
              separatorBuilder: (_, _) => Divider(
                height: 20,
                color: isDark
                    ? Colors.white10
                    : Colors.grey.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return TransactionItemTile(
                  transaction: transaction,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EReceiptScreen(transaction: transaction),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
