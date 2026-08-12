import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/network/crud_firebase/firestore_service.dart';

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
    
    // Clear first to ensure fresh state if called multiple times
    _name = "";
    _phone = "";
    _email = "";
    _picture = "";
    _gender = "";
    _dateOfBirth = "";
    _addresses = [
      {
        "title": "",
        "address": "",
        "isDefault": true,
      },
    ];

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

    // Attempt to sync from Firestore on startup
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestoreService = FirestoreService();
      final profile = await firestoreService.getUserProfile(user.uid);
      if (profile != null) {
        _name = profile.name.isNotEmpty ? profile.name : _name;
        _phone = profile.phone.isNotEmpty ? profile.phone : _phone;
        _email = profile.email.isNotEmpty ? profile.email : _email;
        _picture = profile.picture.isNotEmpty ? profile.picture : _picture;
        _gender = profile.gender.isNotEmpty ? profile.gender : _gender;
        _dateOfBirth = profile.age.isNotEmpty ? profile.age : _dateOfBirth;
      }

      // Fetch specific addresses collection/field
      final doc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      if (doc.exists && doc.data()?['addresses'] != null) {
        _addresses = List<Map<String, dynamic>>.from(doc.data()!['addresses']);
        // Cache back to prefs
        await prefs.setString('user_addresses', jsonEncode(_addresses));
      }
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
    await _syncToFirestore();
    notifyListeners();
  }

  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    _addresses = addresses;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_addresses', jsonEncode(_addresses));
    await _syncToFirestore(syncAddresses: true);
    notifyListeners();
  }

  Future<void> _syncToFirestore({bool syncAddresses = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestoreService = FirestoreService();
      String currentAddress = "";
      if (defaultAddress != null) {
        currentAddress = defaultAddress!['address'] ?? "";
      }

      await firestoreService.updateUserInfo(
        uid: user.uid,
        name: _name,
        email: _email,
        phone: _phone,
        address: currentAddress,
        gender: _gender,
        dateOfBirth: _dateOfBirth,
        picture: _picture,
      );

      if (syncAddresses) {
        await firestoreService.updateUserAddresses(user.uid, _addresses);
      }
    }
  }

  void clear() {
    _name = "";
    _phone = "";
    _email = "";
    _picture = "";
    _gender = "";
    _dateOfBirth = "";
    _addresses = [
      {
        "title": "",
        "address": "",
        "isDefault": true,
      },
    ];
    notifyListeners();
  }
}
