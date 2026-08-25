import 'package:shopping_app/src/network/shared_preferences/shared_preferences.dart';

class PreferencesManager {
  factory PreferencesManager() => _instance;

  PreferencesManager._();

  static final PreferencesManager _instance = PreferencesManager._();

  Future<String> setGetString(dynamic key, [String? data]) async {
    final String keyString = key.toString();
    if (data != null) {
      await SharedPrefUtil.saveString(keyString, data);
      return data;
    } else {
      final value = SharedPrefUtil.getString(keyString) ?? '';
      return value;
    }
  }

  Future<bool> remove(dynamic key) async {
    return await SharedPrefUtil.remove(key.toString());
  }
}
