import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';


import '../../../model/wallet_card_model.dart';
import '../../../widget/text_widget.dart';
import 'more.dart';


class WalletHeader extends StatelessWidget implements PreferredSizeWidget {
  final Function(WalletCardModel)? onAddCard;

  const WalletHeader({super.key, this.onAddCard});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 12),
              TextWidget(
                'My Wallet'.tr,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),

              const Spacer(),

              IconButton(
                onPressed: () => _handleTopUp(context),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
                color: iconColor,
                tooltip: 'Top Up'.tr,
              ),

              IconButton(
                onPressed: () async {
                },
                icon: const Icon(Icons.credit_card_rounded, size: 24),
                color: iconColor,
                tooltip: 'Add Card'.tr,
              ),

              IconButton(
                onPressed: () => _showMoreOptions(context),
                icon: Image.asset(
                  'assets/icon/more.png',
                  height: 20,
                  width: 20,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTopUp(BuildContext context) {
    debugPrint("Top-up clicked");
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => EReceiptActionsWidget(
        onShare: () => Navigator.pop(context),
        onDownload: () => Navigator.pop(context),
        onPrint: () => Navigator.pop(context),
      ),
    );
  }
}

