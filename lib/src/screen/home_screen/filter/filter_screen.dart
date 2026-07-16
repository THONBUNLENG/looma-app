import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  String selectedSort = 'Recommend';
  RangeValues priceRange = const RangeValues(0, 2800);
  String selectedSize = '22';
  String selectedColor = 'Black';

  final List<String> sortOptions = [
    'Recommend',
    'New items',
    'Discount (High First)',
    'Discount (Low First)',
    'Price (High First)',
    'Price (Low First)',
  ];

  final List<String> sizes = [
    '22',
    '24',
    '26',
    '28',
    '30',
    '32',
    '34',
    '36',
    '37',
    '38',
    '39',
    '40',
    'Free size',
    'XS',
    'XS-S',
    'S',
    'M',
    'M-L',
    'L',
    'XL',
    'XXL',
    'S-M',
    'L-XL',
    'XXS-XS',
  ];

  final Map<String, Color> colors = {
    'Black': Colors.black,
    'Brown': Colors.brown,
    'White': Colors.white,
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Cream': const Color(0xFFFFFDD0),
    'Pink': Colors.pink,
    'Yellow': Colors.yellow,
    'Gray': Colors.grey,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: primaryTextColor),
        centerTitle: true,
        title: TextWidget(
          "LOOMA FILTER",
          color: primaryTextColor,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Sort by', primaryTextColor),
            Column(
              children: sortOptions.map((option) {
                return RadioListTile<String>(
                  title: TextWidget(
                    option.tr,
                    color: primaryTextColor,
                    fontSize: 16,
                  ),
                  value: option,
                  // ignore: deprecated_member_use
                  groupValue: selectedSort,
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    if (val != null) setState(() => selectedSort = val);
                  },
                  activeColor: primaryTextColor,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            _sectionTitle('Price Range', primaryTextColor),
            Center(
              child: TextWidget(
                "\$${priceRange.start.round()} - \$${priceRange.end.round()}",
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primaryTextColor,
              ),
            ),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 2800,
              activeColor: primaryTextColor,
              inactiveColor: borderColor,
              onChanged: (val) => setState(() => priceRange = val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget("\$0", color: primaryTextColor),
                TextWidget("\$2800", color: primaryTextColor),
              ],
            ),

            const SizedBox(height: 20),
            _sectionTitle('Size', primaryTextColor),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: sizes.length,
              itemBuilder: (context, i) => _selectableButton(
                sizes[i].tr,
                selectedSize == sizes[i],
                isDark,
                () => setState(() => selectedSize = sizes[i]),
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle('Color', primaryTextColor),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: colors.length + 1,
              itemBuilder: (context, i) {
                if (i < colors.length) {
                  String key = colors.keys.elementAt(i);
                  return _colorButton(
                    key.tr,
                    colors[key]!,
                    selectedColor == key,
                    isDark,
                    () => setState(() => selectedColor = key),
                  );
                }
                return _selectableButton(
                  "Printed".tr,
                  selectedColor == "Printed",
                  isDark,
                  () => setState(() => selectedColor = "Printed"),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: _bottomButtons(isDark),
    );
  }

  Widget _sectionTitle(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextWidget(
        text.tr,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _selectableButton(
    String label,
    bool isSelected,
    bool isDark,
    VoidCallback onTap,
  ) {
    final textColor = isSelected
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? Colors.white : Colors.black);

    final bgColor = isSelected
        ? (isDark ? Colors.white : Colors.black)
        : Colors.transparent;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.zero,
      ),
      onPressed: onTap,
      child: TextWidget(label, color: textColor, fontWeight: FontWeight.w500),
    );
  }

  Widget _colorButton(
    String name,
    Color color,
    bool isSelected,
    bool isDark,
    VoidCallback onTap,
  ) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? (isDark ? Colors.white10 : Colors.grey[100])
            : Colors.transparent,
        side: BorderSide(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          width: isSelected ? 1.5 : 1.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextWidget(
              name,
              color: isDark ? Colors.white : Colors.black,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedSort = 'Recommend';
                  priceRange = const RangeValues(0, 2800);
                  selectedSize = '22';
                  selectedColor = 'Black';
                });
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 56),
                side: BorderSide(color: isDark ? Colors.white : Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextWidget(
                "Clear".tr,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextWidget(
                "APPLY".tr,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
