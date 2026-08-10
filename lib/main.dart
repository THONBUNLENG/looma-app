import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/network/crud_firebase/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/manager/network_wrapper.dart';
import 'package:shopping_app/src/screen/splash_screen.dart';
import 'manager/preferences_manager.dart';
import 'manager/cart_manager.dart';
import 'manager/profile_manager.dart';
import 'manager/review_manager.dart';
import 'manager/wishlist_manager.dart';
import 'src/telegarm_bot/bot_manager.dart';
import 'constants/navigator_extension.dart';
import 'light_dark_theme/theme.dart';
import 'localization/locale_en.dart';
import 'localization/locale_km.dart';
import 'localization/locale_cn.dart';

final FlutterLocalization translator = FlutterLocalization.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the localization library
  await FlutterLocalization.instance.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
    try {
      await Firebase.initializeApp();
    } catch (_) {}
  }
  
  try {
    await GoogleSignIn.instance.initialize(
      serverClientId: '561028849572-veuui4830sq4dteqo5vits81l1g8n653.apps.googleusercontent.com',
    );
  } catch (e) {
    debugPrint("Google Sign In initialization error: $e");
  }

  try {
    await SharedPrefUtil.init();
    await Future.wait([
      CartManager().init(),
      WishlistManager().init(),
      ProfileManager().init(),
      ReviewManager().init(),
    ]);

    // Start Bot in background so it doesn't block app startup
    BotManager().start().catchError((e) {
      debugPrint("Telegram Bot background start error: $e");
    });
  } catch (e) {
    debugPrint("Manager initialization error: $e");
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    translator.init(
      mapLocales: [
        const MapLocale('en', english),
        const MapLocale('km', khmer),
        const MapLocale('cn', chinese),
      ],
      initLanguageCode: 'en',
    );
    translator.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: TAppTheme.themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          navigatorKey: Go.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: TAppTheme.lightTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: translator.localizationsDelegates,
          supportedLocales: translator.supportedLocales,
          home: const NetworkWrapper(child: SplashScreen()),
        );
      },
    );
  }
}
