import 'package:flutter/material.dart';

import 'package:shopping_app/manager/callback_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../favorite/favorite_screen.dart';
import '../home_screen/home_screen.dart';
import '../home_screen/menu/menu_screen.dart';
import '../home_screen/order/order_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../wallet/wallet_page.dart';

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

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
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
    _pages = [
      const HomeScreen(),
      const WishlistScreen(),
      const MyWalletPage(),
      const OrderScreen(),
      const MenuScreen(
        categoryName: '',
        newItems: [],
        clothes: [],
        polos: [],
        activewear: [],
        jackets: [],
        jeans: [],
        joggers: [],
        leggings: [],
        pants: [],
        shirts: [],
        skirt: [],
        suits: [],
        sweatshirts: [],
        tShirts: [],
        blouses: [],
        cardigans: [],
        coats: [],
        dresses: [],
        shorts: [],
        skirts: [],
        hoodies: [],
      ),
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_loadingLoginStatus) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white10
                  : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/icon/home.png', 'Home'),
              _buildNavItem(1, 'assets/icon/like.png', 'Wishlist'),
              _buildNavItem(2, 'assets/icon/payment.png', 'Wallet'),
              _buildNavItem(3, 'assets/icon/order.png', 'Order'),
              _buildNavItem(4, 'assets/icon/menu.png', 'Menu'),
              _buildNavItem(5, 'assets/icon/profile.png', 'Me'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isActive = _selectedIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color activeColor = isDark ? Colors.white : Colors.black;
    final Color inactiveColor = isDark ? Colors.white38 : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => setSelectedIndex(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 22,
              height: 22,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            TextWidget(
              label,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 2,
              width: isActive ? 12 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
