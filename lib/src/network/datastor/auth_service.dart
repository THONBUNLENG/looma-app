import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'user_name';
  static const String _phoneKey = 'user_phone';
  static const String _pictureKey = 'user_picture';
  static const String _tokenKey = 'auth_token';
  static const String _notifiedKey = 'has_been_notified';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final p = await _prefs;
    return p.getBool(_isLoggedInKey) ?? false;
  }

  /// Perform Login / Save Session
  static Future<void> saveLoginData({
    required String username,
    required String phone,
    String? picture,
    String? token,
  }) async {
    final p = await _prefs;
    await p.setBool(_isLoggedInKey, true);
    await p.setString(_usernameKey, username);
    await p.setString(_phoneKey, phone);
    if (picture != null) await p.setString(_pictureKey, picture);
    if (token != null) await p.setString(_tokenKey, token);
    await p.setBool(_notifiedKey, false);
  }

  /// Get Token (Useful for API Headers)
  static Future<String?> getToken() async {
    final p = await _prefs;
    return p.getString(_tokenKey);
  }

  static Future<String?> getUsername() async {
    final p = await _prefs;
    return p.getString(_usernameKey);
  }

  static Future<String?> getPhone() async {
    final p = await _prefs;
    return p.getString(_phoneKey);
  }

  static Future<String?> getPicture() async {
    final p = await _prefs;
    return p.getString(_pictureKey);
  }

  /// --- Notification Logic ---
  /// Use this to check if you've already alerted the user about this login
  static Future<bool> shouldNotify() async {
    final p = await _prefs;
    bool alreadyNotified = p.getBool(_notifiedKey) ?? false;
    if (!alreadyNotified) {
      await p.setBool(_notifiedKey, true);
      return true;
    }
    return false;
  }

  /// Standard Logout
  static Future<void> logout() async {
    final p = await _prefs;
    await Future.wait([
      p.setBool(_isLoggedInKey, false),
      p.remove(_usernameKey),
      p.remove(_phoneKey),
      p.remove(_tokenKey),
      p.remove(_notifiedKey),
    ]);
  }

  /// Full Account Deletion
  static Future<void> deleteAccountPermanent() async {
    final p = await _prefs;
    await p.clear();
  }
}
