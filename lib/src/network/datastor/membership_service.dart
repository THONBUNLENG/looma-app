import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/order_model.dart';

import 'package:flutter/material.dart';

enum MemberLevel {
  online,
  silver,
  gold,
  platinum;

  String get label {
    switch (this) {
      case MemberLevel.online:
        return "ONLINE";
      case MemberLevel.silver:
        return "SILVER";
      case MemberLevel.gold:
        return "GOLD";
      case MemberLevel.platinum:
        return "PLATINUM";
    }
  }

  Color get color {
    switch (this) {
      case MemberLevel.online:
        return const Color(0xFFD9904D);
      case MemberLevel.silver:
        return const Color(0xFF8E8E93);
      case MemberLevel.gold:
        return const Color(0xFFFBC02D); // Colors.yellow[700]
      case MemberLevel.platinum:
        return Colors.black;
    }
  }

  double get discountPercentage {
    switch (this) {
      case MemberLevel.online:
        return 0.0;
      case MemberLevel.silver:
        return 0.10;
      case MemberLevel.gold:
        return 0.15;
      case MemberLevel.platinum:
        return 0.20;
    }
  }
}

class MembershipService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<List<OrderModel>> getOrdersStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    });
  }

  static double calculateTotalSpent(List<OrderModel> orders) {
    return orders
        .where((order) =>
            order.status.toLowerCase() != 'pending' &&
            order.status.toLowerCase() != 'await payment')
        .fold(0.0, (previousValue, order) => previousValue + order.totalAmount);
  }

  static int calculatePoints(double totalSpent) {
    // 1 Point for every $25 spent
    return (totalSpent / 25).floor();
  }

  static int calculateAvailablePoints(List<OrderModel> orders) {
    final totalSpent = calculateTotalSpent(orders);
    final earnedPoints = calculatePoints(totalSpent);
    final redeemedPoints = orders.fold(0, (previousRedeemed, order) => previousRedeemed + (order.pointsRedeemed ?? 0));
    return earnedPoints - redeemedPoints;
  }

  static MemberLevel getLevel(double totalSpent) {
    if (totalSpent >= 100000) return MemberLevel.platinum;
    if (totalSpent >= 10000) return MemberLevel.gold;
    if (totalSpent >= 5000) return MemberLevel.silver;
    return MemberLevel.online;
  }
  
  static String getUserId() {
    return _auth.currentUser?.uid ?? "GUEST";
  }

  static String getMembershipId() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return "LM-GUEST";
    return "LM-${uid.substring(0, uid.length > 6 ? 6 : uid.length).toUpperCase()}";
  }
}
