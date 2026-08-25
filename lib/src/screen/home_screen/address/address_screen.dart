import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../../../constants/string_extension.dart';
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          "Address book".tr,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoaded) {
            final addresses = state.addresses;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _buildAddButton(context),
                const SizedBox(height: 20),
                ...List.generate(addresses.length, (index) {
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
                }),
              ],
            );
          } else if (state is AddressError) {
            return Center(child: TextWidget(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isDefault ? Icons.check_circle : Icons.circle_outlined,
              color: isDefault ? AppColor.pink100Color : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        (item['label'] ?? "Address").toString().tr,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        _buildDefaultBadge(context),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextWidget(
                    item['title'] ?? "",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    item['address'],
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        "Edit".tr,
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit_outlined,
                        color: isDark ? Colors.white70 : Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextWidget(
        "Default".tr,
        fontSize: 12,
        color: isDark ? Colors.white : Colors.black,
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColor.pink100Color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.pink100Color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
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
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_location_alt_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              TextWidget(
                'Add new address'.tr,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          ),
        ),
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
