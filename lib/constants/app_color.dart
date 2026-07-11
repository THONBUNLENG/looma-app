import 'package:flutter/material.dart';

mixin AppColor {
  static const int _primary = 0xFF1E88E5;
  static const Map<int, Color> _swatch = {
    50: primaryColor,
    100: primaryColor,
    200: primaryColor,
    300: primaryColor,
    400: primaryColor,
    500: primaryColor,
    600: primaryColor,
    700: primaryColor,
    800: primaryColor,
    900: primaryColor,
  };
  static const MaterialColor primarySwatch = MaterialColor(_primary, _swatch);
  static const Color primaryColor = Color(_primary);
  static const Color secondaryColor = Color(0xFFDAA520);
  static const Color backgroundColor = Color(0xFFF8F9FD);
  static const Color darkMode = Colors.black;
  static const Color lightMode = Colors.white;
  static const Color lightChipTheme = Colors.grey;
  static const Color darkGrey = Color(0xFF939393);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey100 = Color(0xFFF5F5F5);

  ///-------------------------------------------------------
  static const Color buttonColor = Color(0xFF004CFF);
  static const Color pink = Color(0xFFE91E63);
  static const Color lightPink = Color(0xFFF8BBD0);
  static const Color hotPink = Color(0xFFFF69B4);
  static const Color rosePink = Color(0xFFF48FB1);
  static const Color accentLightBlue = Color(0xFFF2F5FE);
  static const Color softBackground = Color(0xFFD9E4FF);
  static const Color errorRed = Color(0xFFD32F2F); // Material Red
  static const Color softRed = Color(0xFFFFEAEA);
  static const Color saleRed = Color(0xFFFF4848);
  static const Color successGreen = Color(0xFF08C514);
  static const Color gold = Color(0xFFECA61B);
  static const Color mutedRed = Color(0xFFD97474);
  static const Color blueStart = Color(0xFF004CFF);
  static const Color greenEnd = Color(0xFF17BE5A);
  static const Color mainColor = Color(0xFF004BFE);
  static const Color grey30Color = Color(0xFFF8F8F8);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color textColor = Colors.black87;
  static const Color greyColor = Colors.grey;
  static const Color orageColor = Colors.deepOrangeAccent;
  static const Color pinkColor = Colors.pink;
  static const Color greenColor = Colors.green;
  static const Color pink100Color = Color(0xFFF81140);
  static const Color pink30Color = Color(0xFFFF5790);
}

class SizesIcon {
  // Icon Sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Button Sizes
  static const double buttonHeight = 18.0;
  static const double buttonRadius = 12.0;

  // --- ADD THESE LINES TO FIX THE ERROR ---
  static const double inputFieldRadius = 12.0;
  static const double inputFieldHeight = 56.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  // -----------------------------------------
}
