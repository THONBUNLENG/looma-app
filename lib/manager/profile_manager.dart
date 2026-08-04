import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager extends ChangeNotifier {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();
  String _name = "";
  String _phone = "";
  String _email = "";
  String _picture = "";
  String _gender = "";
  String _dateOfBirth = "";
  List<Map<String, dynamic>> _addresses = [
    {
      "title": "",
      "address": "",
      "isDefault": true,
    },
  ];

  String get name => _name;
  String get phone => _phone;
  String get email => _email;
  String get picture => _picture;
  String get gender => _gender;
  String get dateOfBirth => _dateOfBirth;
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
    _gender = prefs.getString('user_gender') ?? _gender;
    _dateOfBirth = prefs.getString('user_dob') ?? _dateOfBirth;
    
    final String? addrData = prefs.getString('user_addresses');
    if (addrData != null) {
      _addresses = List<Map<String, dynamic>>.from(jsonDecode(addrData));
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? picture,
    String? gender,
    String? dateOfBirth,
  }) async {
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
    if (gender != null) {
      _gender = gender;
      await prefs.setString('user_gender', gender);
    }
    if (dateOfBirth != null) {
      _dateOfBirth = dateOfBirth;
      await prefs.setString('user_dob', dateOfBirth);
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
