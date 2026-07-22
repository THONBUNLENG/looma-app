import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../../constants/string_extension.dart';
import '../../../widget/button.dart';
import '../../../widget/show_dialog.dart';
import 'bloc/address_bloc.dart';
import 'edit_address.dart';
import 'new_address.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressBloc()..add(LoadAddresses()),
      child: const AddressView(),
    );
  }
}

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: TextWidget(
          "Address".tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoaded) {
            final addresses = state.addresses;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 100),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];
                return Dismissible(
                  key: Key(item['address'] + index.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => StatusDialog(
                        title: "Delete Address".tr,
                        message:
                            "${"Are you sure you want to delete".tr} '${item['title']}'?",
                        btn1Text: "Cancel".tr,
                        btn2Text: "Delete".tr,
                        icon: Icons.delete_sweep_rounded,
                        iconColor: AppColor.mutedRed,
                        onBtn1Pressed: () => Navigator.of(dialogContext).pop(false),
                        onBtn2Pressed: () => Navigator.of(dialogContext).pop(true),
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    context.read<AddressBloc>().add(DeleteAddress(index));
                    _showSuccessSnackBar(context, item['title']);
                  },
                  background: _buildDeleteBackground(),
                  child: _buildAddressCard(context, item, index),
                );
              },
            );
          } else if (state is AddressError) {
            return Center(child: TextWidget(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _buildAddButton(context),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    bool isDefault = item['isDefault'] ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.read<AddressBloc>().add(SetDefaultAddress(index));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDefault
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? Colors.white10 : Colors.transparent),
            width: 1.5,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: isDefault
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? Colors.white10 : const Color(0xFFF5F5F5)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: isDefault
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white70 : Colors.black54),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        (item['title'] as String).tr,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      if (isDefault) _buildDefaultBadge(context),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    item['address'],
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    fontSize: 13,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAddressScreen(addressData: item),
                      ),
                    );
                    if (result != null && context.mounted) {
                      if (result == "deleted") {
                        context.read<AddressBloc>().add(DeleteAddress(index));
                      } else if (result is Map<String, dynamic>) {
                        context.read<AddressBloc>().add(UpdateAddress(index, result));
                      }
                    }
                  },
                  icon: Icon(
                    Icons.edit_location_alt_outlined,
                    color: isDark ? Colors.white70 : Colors.black54,
                    size: 20,
                  ),
                ),
                Radio<bool>(
                  value: true,
                  groupValue: isDefault,
                  onChanged: (val) {
                    context.read<AddressBloc>().add(SetDefaultAddress(index));
                  },
                  activeColor: isDark ? Colors.white : Colors.black,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? Colors.white24 : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextWidget(
        "Default".tr,
        fontSize: 10,
        color: isDark ? Colors.white : Colors.black54,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(right: 25),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppColor.mutedRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: MyCustomButton(
        text: 'Add New Address'.tr,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewAddressScreen(),
            ),
          );

          if (result != null && result is Map<String, dynamic> && context.mounted) {
            context.read<AddressBloc>().add(AddAddress(result));
          }
        },
        width: double.infinity,
        height: 56,
        borderRadius: 16,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          "${"Address".tr} '${title.tr}' ${"deleted".tr}",
          color: isDark ? Colors.black : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
