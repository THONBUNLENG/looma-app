import 'package:flutter/material.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

import '../../../widget/button.dart';
import '../../../widget/show_dialog.dart';
import 'edit_address.dart';
import 'new_address.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<Map<String, dynamic>> addresses = [
    {
      "title": "Home",
      "address": "61480 Sunbrook Park, PC 5679",
      "isDefault": true,
    },
    {
      "title": "Office",
      "address": "6993 Meadow Valley Terra, PC 3637",
      "isDefault": false,
    },
    {
      "title": "Apartment",
      "address": "21833 Clyde Gallagher, PC 4662",
      "isDefault": false,
    },
    {
      "title": "Parent's House",
      "address": "5259 Blue Bill Park, PC 4627",
      "isDefault": false,
    },
  ];

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
          "Address",
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: ListView.builder(
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
                builder: (context) => StatusDialog(
                  title: "Delete Address",
                  message:
                      "Are you sure you want to delete '${item['title']}'?",
                  btn1Text: "Cancel",
                  btn2Text: "Delete",
                  icon: Icons.delete_sweep_rounded,
                  iconColor: AppColor.mutedRed,
                  onBtn1Pressed: () => Navigator.of(context).pop(false),
                  onBtn2Pressed: () => Navigator.of(context).pop(true),
                ),
              );
            },
            onDismissed: (direction) {
              setState(() => addresses.removeAt(index));
              _showSuccessSnackBar(item['title']);
            },
            background: _buildDeleteBackground(),
            child: _buildAddressCard(context, item, index),
          );
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
    bool isDefault = item['isDefault'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          for (var i = 0; i < addresses.length; i++) {
            addresses[i]['isDefault'] = (i == index);
          }
        });
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
                        item['title'],
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
                    if (result != null) {
                      if (result == "deleted") {
                        setState(() => addresses.removeAt(index));
                      } else if (result is Map<String, dynamic>) {
                        setState(() {
                          if (result['isDefault'] == true) {
                            for (var element in addresses) {
                              element['isDefault'] = false;
                            }
                          }
                          addresses[index] = result;
                        });
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
                    setState(() {
                      for (var i = 0; i < addresses.length; i++) {
                        addresses[i]['isDefault'] = (i == index);
                      }
                    });
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
        "Default",
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
        text: 'Add New Address',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewAddressScreen(),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              if (result['isDefault'] == true) {
                for (var element in addresses) {
                  element['isDefault'] = false;
                }
              }
              addresses.add(result);
            });
          }
        },
        width: double.infinity,
        height: 56,
        borderRadius: 16,
      ),
    );
  }

  void _showSuccessSnackBar(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(
          "Address '$title' deleted",
          color: isDark ? Colors.black : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
