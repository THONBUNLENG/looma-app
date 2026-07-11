import 'package:flutter/material.dart';
import '../../../widget/text_widget.dart';
class SearchMenuScreen extends StatefulWidget {
  const SearchMenuScreen({super.key});

  @override
  State<SearchMenuScreen> createState() => _SearchMenuScreenState();
}

class _SearchMenuScreenState extends State<SearchMenuScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    "WOMEN",
    "MEN",
    "KIDS",
    "Z.HOME",
    "LIFESTYLE",
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white38 : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildSearchHeader(context, isDark, primaryColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryTabs(primaryColor, secondaryColor),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: TextWidget(
              "Recent Searches",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 48,
                    color: primaryColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  TextWidget(
                    "You have no recent searches.",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  // Slight bottom offset for optical centering
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchHeader(
    BuildContext context,
    bool isDark,
    Color color,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: color, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(
                    4,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: color),
                  decoration: InputDecoration(
                    hintText:
                        "Search ${_categories[_selectedCategoryIndex].toLowerCase()}",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    prefixIcon: Icon(Icons.search, color: color, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.qr_code_scanner_rounded, color: color, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(Color active, Color inactive) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isActive = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? active : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: TextWidget(
                  _categories[index],
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: isActive ? active : inactive,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
