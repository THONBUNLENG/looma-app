import 'package:flutter/material.dart';

class EReceiptActionsWidget extends StatelessWidget {
  final void Function()? onShare;
  final void Function()? onDownload;
  final void Function()? onPrint;

  const EReceiptActionsWidget({
    super.key,
    this.onShare,
    this.onDownload,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 12),

          _buildActionItem(
            context,
            iconPath: 'assets/icon/i_color/share.png',
            label: 'Share E-Receipt',
            onTap: onShare,
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),

          _buildActionItem(
            context,
            iconPath: 'assets/icon/i_color/download.png',
            label: 'Download E-Receipt',
            onTap: onDownload,
          ),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1)),

          _buildActionItem(
            context,
            iconPath: 'assets/icon/i_color/print.png',
            label: 'Print',
            onTap: onPrint,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      BuildContext context, {
        required String iconPath,
        required String label,
        VoidCallback? onTap,
        bool showArrow = true,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F3F3),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            if (showArrow)
              Image.asset(
                'assets/icon/go.png',
                width: 16,
                height: 16,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
          ],
        ),
      ),
    );
  }
}