import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/model/gift_card_model.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';
import 'package:intl/intl.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<GiftCardModel> _giftCards = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGiftCards();
  }

  void _loadGiftCards() {
    final profile = ProfileManager();

    String userIdentifier = "USER";
    if (profile.name.isNotEmpty) {
      userIdentifier = profile.name.split(' ').first.toUpperCase();
    } else if (profile.phone.isNotEmpty) {
      userIdentifier = profile.phone.length >= 4
          ? profile.phone.substring(profile.phone.length - 4)
          : profile.phone;
    }

    userIdentifier = userIdentifier.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (userIdentifier.isEmpty) userIdentifier = "USER";

    final baseCards = GiftCardModel.getSampleData(userIdentifier);
    final List<GiftCardModel> finalCards = List.from(baseCards);

    if (profile.dateOfBirth.isNotEmpty) {
      try {
        final parts = profile.dateOfBirth.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final now = DateTime.now();

          debugPrint(
            "GiftCardScreen: Checking birthday (Day/Month only) - User: $day/$month, Today: ${now.day}/${now.month}",
          );

          if (now.day == day && now.month == month) {
            debugPrint("GiftCardScreen: Birthday match! Adding voucher.");
            finalCards.insert(
              0,
              GiftCardModel.birthdayVoucher(
                userIdentifier,
                userName: profile.name,
              ),
            );
          } else {
            debugPrint("GiftCardScreen: Not birthday today.");
          }
        } else {
          debugPrint(
            "GiftCardScreen: Invalid DOB format: ${profile.dateOfBirth}",
          );
        }
      } catch (e) {
        debugPrint("Error parsing birthday for gift card screen: $e");
      }
    } else {
      debugPrint("GiftCardScreen: Profile DOB is empty.");
    }

    setState(() {
      _giftCards = finalCards;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          'Gift Card'.tr,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
          tabs: [
            Tab(text: 'Active'.tr),
            Tab(text: 'Inactive'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGiftCardList(
            _giftCards.where((g) => g.isActive).toList(),
            isDark,
          ),
          _buildGiftCardList(
            _giftCards.where((g) => !g.isActive).toList(),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCardList(List<GiftCardModel> cards, bool isDark) {
    if (cards.isEmpty) {
      return Center(
        child: TextWidget(
          "No vouchers available".tr,
          fontSize: 16,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildGiftCardItem(cards[index], isDark),
        );
      },
    );
  }

  Widget _buildGiftCardItem(GiftCardModel card, bool isDark) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: () => _showGiftCardDetail(card, isDark),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        card.title,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      TextWidget(
                        card.description,
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.black54,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                TextWidget(
                  "\$${card.amount.toInt()}",
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Valid until".tr,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      dateFormat.format(card.validUntil),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                      "Claim code".tr,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      card.claimCode,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGiftCardDetail(GiftCardModel card, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final dateFormat = DateFormat('dd/MM/yyyy');
        final dateRange =
            "${dateFormat.format(card.validFrom)} - ${dateFormat.format(card.validUntil)}";

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextWidget(
                    "Share gift cart".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(width: 48),
                  // Spacer to balance the close button
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: card.claimCode,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextWidget(
                          card.title,
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                        TextWidget(
                          "Valid from:",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        "\$${card.amount.toInt()}",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(
                        "Claim code:",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextWidget(
                      dateRange,
                      fontSize: 18,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextWidget(card.claimCode, fontSize: 18),
                ],
              ),
              const SizedBox(height: 8),
              TextWidget(card.description, fontSize: 12, color: Colors.black54),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Center(
                child: TextWidget(
                  "Terms & Conditions:",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...card.terms.map(
                (term) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextWidget("- $term", fontSize: 14, lineHeight: 1.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
