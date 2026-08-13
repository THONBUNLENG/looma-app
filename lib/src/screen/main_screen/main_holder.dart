import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/callback_manager.dart';
import 'package:shopping_app/manager/preferences_manager.dart';
import 'package:shopping_app/manager/profile_manager.dart';
import 'package:shopping_app/src/widget/birthday_reward_dialog.dart';
import 'package:shopping_app/src/widget/loading_widget.dart';
import '../../../constants/app_color.dart';

import '../home_screen/favorite/favorite_screen.dart';
import '../home_screen/home_screen.dart';
import '../home_screen/profile_screen/profile_screen.dart';
import '../home_screen/menu/search_menu_screen.dart';
import '../home_screen/brand/brand_list_screen.dart';

class MainHolder extends StatefulWidget {
  const MainHolder({super.key});

  @override
  MainHolderState createState() => MainHolderState();

  static MainHolderState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainHolderState>();
}

class MainHolderState extends State<MainHolder> {
  int _selectedIndex = 0;
  bool _loadingLoginStatus = true;

  late final List<Widget> _pages;
  final List<NavItemData> _navItems = const [
    NavItemData(iconPath: 'assets/icon/home.png', label: 'Home'),
    NavItemData(iconPath: 'assets/icon/menu.png', label: 'Menu'),
    NavItemData(iconPath: 'assets/icon/brand.png', label: 'Brands'),
    NavItemData(iconPath: 'assets/icon/like.png', label: 'Wishlist'),
    NavItemData(iconPath: 'assets/icon/profile.png', label: 'Me'),
  ];

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 3) {
        CallbackManager().refreshWishlist?.call();
      }
    }
  }

  void refreshIndexStack(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    CallbackManager().refreshIndexStack = refreshIndexStack;
    CallbackManager().checkBirthdayReward = _checkBirthdayReward;
    _pages = [
      const HomeScreen(),
      const SearchMenuScreen(),
      const BrandListScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _loadingLoginStatus = false;
    });

    _checkBirthdayReward();
  }

  Future<void> _checkBirthdayReward() async {
    final profile = ProfileManager();
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (profile.dateOfBirth.isEmpty) {
      debugPrint("MainHolder: Profile DOB is empty.");
      return;
    }

    try {
      final parts = profile.dateOfBirth.split('/');
      if (parts.length != 3) {
        debugPrint("MainHolder: Invalid DOB format: ${profile.dateOfBirth}");
        return;
      }

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);

      final now = DateTime.now();
      debugPrint(
        "MainHolder: Checking birthday reward - User: $day/$month, Today: ${now.day}/${now.month}",
      );

      // STRICT DAY AND MONTH MATCH
      if (now.day == day && now.month == month) {
        final prefs = PreferencesManager();
        final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
        final rewardKey = "${PrefKey.birthdayRewardYear}_$uid";
        
        final lastRewardedYear = await prefs.setGetString(
          rewardKey,
        );
        final currentYear = now.year.toString();

        debugPrint(
          "MainHolder: Birthday match! UID: $uid, LastRewardedYear: $lastRewardedYear, CurrentYear: $currentYear",
        );

        if (lastRewardedYear != currentYear) {
          if (!mounted) return;


          await prefs.setGetString(rewardKey, currentYear);
          
          if (!mounted) return;
          debugPrint("MainHolder: Showing BirthdayRewardDialog");
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const BirthdayRewardDialog(),
          );
        } else {
          debugPrint("MainHolder: Already rewarded for this year ($currentYear).");
        }
      } else {
        debugPrint("MainHolder: Not birthday today. User: $day/$month, Now: ${now.day}/${now.month}");
      }
    } catch (e) {
      debugPrint("Error checking birthday reward: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loadingLoginStatus) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: LoadingWidget.loadingCenterWidget(),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomCurvedNavigationBar(
        selectedIndex: _selectedIndex,
        navItems: _navItems,
        onTabSelected: (index) => setSelectedIndex(index),
      ),
    );
  }
}

// Data Model សម្រាប់ Nav Item
class NavItemData {
  final String iconPath;
  final String label;

  const NavItemData({required this.iconPath, required this.label});
}

// ==========================================
// CUSTOM CURVED NAVIGATION BAR WIDGET
// ==========================================
class CustomCurvedNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItemData> navItems;
  final ValueChanged<int> onTabSelected;

  const CustomCurvedNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onTabSelected,
  });

  // Global Animation Constants
  static const Duration kNavDuration = Duration(milliseconds: 400);
  static const Curve kNavCurve = Curves.fastOutSlowIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / navItems.length;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    // Theme Colors
    final Color barBgColor = isDark
        ? (theme.cardColor != Colors.white
              ? theme.cardColor
              : const Color(0xFF1E1E1E))
        : Colors.white;
    final Color activeCircleColor = isDark ? Colors.white : AppColor.black;
    final Color inactiveIconColor = isDark
        ? Colors.grey.shade500
        : Colors.grey.shade600;

    return Container(
      height: 78 + bottomPadding,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Curved Background with Custom Paint
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 65 + bottomPadding,
            child: AnimatedPositionedCustomPaint(
              itemWidth: itemWidth,
              selectedIndex: selectedIndex,
              color: barBgColor,
              isDark: isDark,
              duration: kNavDuration,
              curve: kNavCurve,
            ),
          ),

          // 2. Active Indicator Circle (Floating Icon)
          AnimatedPositioned(
            duration: kNavDuration,
            curve: kNavCurve,
            left: selectedIndex * itemWidth + (itemWidth / 2) - 26,
            top: 2,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: activeCircleColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeCircleColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  key: ValueKey(selectedIndex),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset(
                    navItems[selectedIndex].iconPath,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // 3. Navigation Items (Icons & Text Labels)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 65 + bottomPadding,
            child: SafeArea(
              top: false,
              child: Row(
                children: List.generate(navItems.length, (index) {
                  final isSelected = selectedIndex == index;
                  final item = navItems[index];

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTabSelected(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: isSelected ? 0.0 : 1.0,
                            child: Image.asset(
                              item.iconPath,
                              width: 22,
                              height: 22,
                              color: inactiveIconColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Roboto',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? activeCircleColor
                                  : inactiveIconColor,
                            ),
                            child: Text(item.label.tr),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPositionedCustomPaint extends StatelessWidget {
  final double itemWidth;
  final int selectedIndex;
  final Color color;
  final bool isDark;
  final Duration duration;
  final Curve curve;

  const AnimatedPositionedCustomPaint({
    super.key,
    required this.itemWidth,
    required this.selectedIndex,
    required this.color,
    required this.isDark,
    required this.duration,
    required this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: selectedIndex * itemWidth),
      duration: duration,
      curve: curve,
      builder: (context, leftOffset, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: CurvedDipPainter(
            dipOffsetX: leftOffset + (itemWidth / 2),
            color: color,
            shadowColor: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.12),
          ),
        );
      },
    );
  }
}

class CurvedDipPainter extends CustomPainter {
  final double dipOffsetX;
  final Color color;
  final Color shadowColor;

  CurvedDipPainter({
    required this.dipOffsetX,
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    const double dipWidth = 84.0;
    const double dipDepth = 26.0;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(dipOffsetX - (dipWidth / 2), 0);

    // Left curve
    path.cubicTo(
      dipOffsetX - (dipWidth * 0.35),
      0,
      dipOffsetX - (dipWidth * 0.3),
      dipDepth,
      dipOffsetX,
      dipDepth,
    );

    // Right curve
    path.cubicTo(
      dipOffsetX + (dipWidth * 0.3),
      dipDepth,
      dipOffsetX + (dipWidth * 0.35),
      0,
      dipOffsetX + (dipWidth / 2),
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow first
    canvas.drawPath(path.shift(const Offset(0, -1)), shadowPaint);
    // Then draw the actual bar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedDipPainter oldDelegate) {
    return oldDelegate.dipOffsetX != dipOffsetX ||
        oldDelegate.color != color ||
        oldDelegate.shadowColor != shadowColor;
  }
}
