import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager extends ChangeNotifier {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  String _name = "Andrew Ainsley";
  String _phone = "11 820595";
  String _email = "andrew_ainsley@yourdomain.com";
  String _picture = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWk3ODZqYyZbb-CHDbmzE7En-1bcFgJBO8pg&s";
  List<Map<String, dynamic>> _addresses = [
    {
      "title": "Home",
      "address": "61480 Sunbrook Park, PC 5679",
      "isDefault": true,
    },
  ];

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get picture => _picture;
  List<Map<String, dynamic>> get addresses => _addresses;

  Map<String, dynamic>? get defaultAddress {
    try {
      return _addresses.firstWhere((element) => element['isDefault'] == true);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? _name;
    _phone = prefs.getString('user_phone') ?? _phone;
    _email = prefs.getString('user_email') ?? _email;
    _picture = prefs.getString('user_picture') ?? _picture;
    
    final String? addrData = prefs.getString('user_addresses');
    if (addrData != null) {
      _addresses = List<Map<String, dynamic>>.from(jsonDecode(addrData));
    }
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? phone, String? email, String? picture}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) {
      _name = name;
      await prefs.setString('user_name', name);
    }
    if (phone != null) {
      _phone = phone;
      await prefs.setString('user_phone', phone);
    }
    if (email != null) {
      _email = email;
      await prefs.setString('user_email', email);
    }
    if (picture != null) {
      _picture = picture;
      await prefs.setString('user_picture', picture);
    }
    notifyListeners();
  }

  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    _addresses = addresses;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_addresses', jsonEncode(_addresses));
    notifyListeners();
  }
}
