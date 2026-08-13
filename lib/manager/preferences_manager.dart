import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  factory PreferencesManager() => _instance;

  PreferencesManager._();

  static final PreferencesManager _instance = PreferencesManager._();

  Future<String> setGetString(dynamic key, [String? data]) async {
    final pref = await SharedPreferences.getInstance();
    final String keyString = key.toString();
    if (data != null) {
      pref.setString(keyString, data);
      return data;
    } else {
      final value = pref.getString(keyString) ?? '';
      return value;
    }
  }

  Future<bool> remove(dynamic key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.remove(key.toString());
  }
}
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
enum PrefKey { token, fbToken, deviceId, country, pin, birthdayRewardYear }
