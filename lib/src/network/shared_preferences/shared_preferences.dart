import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Standard String getter used by your EcommerceAPIService
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}

class PrefKey {
  static const String token = 'auth_token';
  static const String userId = 'user_id';
  static const String cartItems = 'cart_items';
}
