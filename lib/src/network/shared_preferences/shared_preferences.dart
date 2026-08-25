import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<bool> saveInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}

class PrefKey {
  static const String token = 'auth_token';
  static const String userId = 'user_id';
  static const String cartItems = 'cart_items';
  static const String wishlistItems = 'wishlist_items';
  static const String fbToken = 'fb_token';
  static const String deviceId = 'device_id';
  static const String country = 'country';
  static const String pin = 'pin';
  static const String birthdayRewardYear = 'birthday_reward_year';
}
