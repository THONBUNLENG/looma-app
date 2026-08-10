import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/model/order_model.dart';
import 'package:shopping_app/src/model/souvenir_model.dart';
import 'package:shopping_app/src/network/datastor/membership_service.dart';
import 'package:shopping_app/src/screen/home_screen/order/bloc/order_bloc.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_success_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/widget/show_dialog.dart';
import '../../../../constants/string_extension.dart';

class SouvenirRedemptionScreen extends StatefulWidget {
  const SouvenirRedemptionScreen({super.key});

  @override
  State<SouvenirRedemptionScreen> createState() => _SouvenirRedemptionScreenState();
}

class _SouvenirRedemptionScreenState extends State<SouvenirRedemptionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => OrderBloc(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: TextWidget(
            'Redeem Souvenirs'.tr,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: StreamBuilder<List<OrderModel>>(
          stream: MembershipService.getOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders = snapshot.data ?? [];
            final points = MembershipService.calculateAvailablePoints(orders);
            final filteredSouvenirs = sampleSouvenirs.where((souvenir) {
              return souvenir.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();

            return BlocListener<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderSuccess &&
                    state.order?.items.first['type'] == 'souvenir') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessScreen(
                        orderId: state.order?.id ?? "N/A",
                        totalAmount: 0.0,
                        paymentMethod: 'Points'.tr,
                      ),
                    ),
                  );
                } else if (state is OrderFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: TextWidget(
                          "Redemption failed: ${state.error}".tr,
                          color: Colors.white),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  _buildPointsCard(points, isDark),
                  const SizedBox(height: 6),
                  Expanded(
                    child: filteredSouvenirs.isEmpty
                        ? _buildEmptyState(isDark)
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: filteredSouvenirs.length,
                            itemBuilder: (context, index) {
                              final souvenir = filteredSouvenirs[index];
                              return _buildSouvenirCard(
                                  context, souvenir, points, isDark);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPointsCard(int points, bool isDark) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2C2C2E), Colors.black]
              : [const Color(0xFF000000), const Color(0xFF2C2C2E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      "AVAILABLE POINTS".tr,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                      "$points",
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.stars, color: Colors.amber, size: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 80, color: isDark ? Colors.white12 : Colors.grey[300]),
          const SizedBox(height: 16),
          TextWidget(
            "No souvenirs found".tr,
            fontSize: 16,
            color: isDark ? Colors.white38 : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildSouvenirCard(BuildContext context, SouvenirModel souvenir,
      int availablePoints, bool isDark) {
    final canAfford = availablePoints >= souvenir.pointCost;
    final pointsNeeded = souvenir.pointCost - availablePoints;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CachedNetworkImage(
                        imageUrl: souvenir.imagePath,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.white24 : Colors.grey[300],
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.card_giftcard,
                          size: 40,
                          color: isDark ? Colors.white24 : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!canAfford)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextWidget(
                            "Need $pointsNeeded more",
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  souvenir.title,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    TextWidget(
                      "${souvenir.pointCost} pts",
                      fontSize: 12,
                      color: isDark ? Colors.amber[200] : Colors.amber[800],
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: canAfford
                        ? () => _confirmRedemption(context, souvenir)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      disabledBackgroundColor:
                          isDark ? Colors.white12 : Colors.grey[200],
                      disabledForegroundColor:
                          isDark ? Colors.white24 : Colors.grey[400],
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: TextWidget(
                      "Redeem".tr,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRedemption(BuildContext context, SouvenirModel souvenir) {
    showDialog(
      context: context,
      builder: (context) => StatusDialog(
        title: "Confirm Redemption".tr,
        message: "Are you sure you want to redeem ${souvenir.title} for ${souvenir.pointCost} points?".tr,
        btn1Text: "Cancel".tr,
        btn2Text: "Confirm".tr,
        imagePath: 'assets/icon/i_color/Information.png',
        iconColor: Colors.amber,
        btn2Color: Colors.amber,
        onBtn1Pressed: () => Navigator.pop(context),
        onBtn2Pressed: () {
          Navigator.pop(context);
          _handleRedeem(context, souvenir);
        },
      ),
    );
  }

  void _handleRedeem(BuildContext context, SouvenirModel souvenir) {
    final userId = MembershipService.getUserId();
    if (userId == "GUEST") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget("Please login to redeem souvenirs.".tr))
      );
      return;
    }

    final defaultAddress = ProfileManager().defaultAddress ?? {};

    final order = OrderModel(
      userId: userId,
      items: [
        {
          'id': souvenir.id,
          'name': souvenir.title,
          'pointCost': souvenir.pointCost,
          'type': 'souvenir',
          'quantity': 1,
        }
      ],
      totalAmount: 0.0,
      status: 'Completed',
      paymentMethod: 'Points',
      deliveryMethod: 'Self-Pickup',
      address: defaultAddress,
      createdAt: DateTime.now(),
      pointsRedeemed: souvenir.pointCost,
    );

    context.read<OrderBloc>().add(PlaceOrder(order));
  }
}