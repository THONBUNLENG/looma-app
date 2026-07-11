import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'contact_us.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextWidget(
            "Help Center",
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_horiz, color: isDark ? Colors.white : Colors.black),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: isDark ? Colors.white : Colors.black,
            indicatorWeight: 3,
            labelColor: isDark ? Colors.white : Colors.black,
            unselectedLabelColor: isDark ? Colors.white38 : Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: const [
              Tab(text: "FAQ"),
              Tab(text: "Contact us"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FaqTabContent(),
            ContactUsTabContent(),
          ],
        ),
      ),
    );
  }
}

class FaqTabContent extends StatelessWidget {
  const FaqTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterChip(context, "General", true),
              _buildFilterChip(context, "Account", false),
              _buildFilterChip(context, "Service", false),
              _buildFilterChip(context, "Payment", false),
              _buildFilterChip(context, "Delivery", false),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
              prefixIcon: Icon(Icons.search, color: isDark ? Colors.white38 : Colors.grey),
              suffixIcon: Icon(Icons.tune, color: isDark ? Colors.white38 : Colors.grey),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFaqCard(
                context,
                "What is Evira?",
                "Evira is a premium shopping platform that provides high-quality products with fast delivery and secure order options.",
              ),
              _buildFaqCard(context, "How to use Evira?", "Simply browse products, add them to your cart, and proceed to checkout using your preferred order method."),
              _buildFaqCard(context, "How do I cancel a orders product?", "You can cancel your order from the 'My Orders' section within 30 minutes of purchase."),
              _buildFaqCard(context, "Is Evira free to use?", "Yes, downloading and browsing Evira is completely free."),
              _buildFaqCard(context, "How to add promo on Evira?", "Enter your promo code at the checkout page under the 'Discount' section."),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {},
        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        selectedColor: isDark ? Colors.white : Colors.black,
        labelStyle: TextStyle(
          color: isSelected
              ? (isDark ? Colors.black : Colors.white)
              : (isDark ? Colors.white70 : Colors.black),
          fontWeight: FontWeight.w600,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Colors.transparent : (isDark ? Colors.white10 : Colors.black12),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: isDark ? Colors.white : Colors.black,
          collapsedIconColor: isDark ? Colors.white54 : Colors.grey,
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          children: [
            if (answer.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Text(
                  answer,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}