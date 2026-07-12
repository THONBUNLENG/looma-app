import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shopping_app/src/network/network_wrapper/network_wrapper.dart';
import 'package:shopping_app/src/screen/splash_screen.dart';

import 'manager/preferences_manager.dart';
import 'manager/cart_manager.dart';
import 'constants/navigator_extension.dart';
import 'light_dark_theme/theme.dart';
import 'localization/locale_ch.dart';
import 'localization/locale_en.dart';
import 'localization/locale_km.dart';

final FlutterLocalization translator = FlutterLocalization.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefUtil.init();
  await CartManager().init();
  await translator.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    translator.init(
      mapLocales: [
        const MapLocale('en', english),
        const MapLocale('km', khmer),
        const MapLocale('cn', chinese),
      ],
      initLanguageCode: 'en',
    );
    translator.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: TAppTheme.themeMode,
      builder: (context, currentMode, _) {
        final platformBrightness = View.of(
          context,
        ).platformDispatcher.platformBrightness;
        final brightness = currentMode == ThemeMode.system
            ? platformBrightness
            : (currentMode == ThemeMode.dark
                  ? Brightness.dark
                  : Brightness.light);

        final isDark = brightness == Brightness.dark;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: isDark
                ? const Color(0xFF121212)
                : Colors.white,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Go.navigatorKey,
          supportedLocales: translator.supportedLocales,
          localizationsDelegates: translator.localizationsDelegates,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          themeMode: currentMode,
          builder: (context, child) {
            return NetworkWrapper(child: child!);
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
