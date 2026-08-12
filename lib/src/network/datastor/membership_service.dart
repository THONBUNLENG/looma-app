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
        return const Color(0xFFFBC02D);
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
    return (totalSpent / 25).floor();
  }

  static int calculateAvailablePoints(List<OrderModel> orders) {
    final totalSpent = calculateTotalSpent(orders);
    final earnedPoints = calculatePoints(totalSpent);
    final redeemedPoints = orders.fold(0, (total, order) => total + (order.pointsRedeemed ?? 0));
    final rewardedPoints = orders.fold(0, (total, order) => total + (order.pointsRewarded ?? 0));
    final balance = earnedPoints - redeemedPoints + rewardedPoints;
    return balance < 0 ? 0 : balance;
  }

  static int calculatePendingPoints(List<OrderModel> orders) {
    final pendingTotal = orders
        .where((order) =>
            order.status.toLowerCase() == 'pending' ||
            order.status.toLowerCase() == 'await payment')
        .fold(0.0, (previousValue, order) => previousValue + order.totalAmount);
    return calculatePoints(pendingTotal);
  }

  static Future<void> redeemSouvenir(OrderModel order) async {
    await _firestore.collection('orders').add(order.toFirestore());
  }

  static Future<void> grantPoints(int amount) async {
    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    final orderId = "REWARD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";

    await _firestore.collection('orders').doc(orderId).set({
      'userId': user.uid,
      'items': [
        {
          'name': 'Point Reward',
          'type': 'reward',
          'points': amount,
        }
      ],
      'totalAmount': 0.0,
      'status': 'Completed',
      'paymentMethod': 'System Reward',
      'deliveryMethod': 'Direct Grant',
      'address': {},
      'createdAt': FieldValue.serverTimestamp(),
      'pointsRewarded': amount,
    });
  }

  static MemberLevel getLevel(double totalSpent) {
    if (totalSpent >= 100000) return MemberLevel.platinum;
    if (totalSpent >= 10000) return MemberLevel.gold;
    if (totalSpent >= 5000) return MemberLevel.silver;
    return MemberLevel.online;
  }

  static double getNextLevelRequirement(MemberLevel currentLevel) {
    switch (currentLevel) {
      case MemberLevel.online:
        return 5000.0;
      case MemberLevel.silver:
        return 10000.0;
      case MemberLevel.gold:
        return 100000.0;
      case MemberLevel.platinum:
        return 0.0;
    }
  }

  static int getPointsToNextLevel(double totalSpent) {
    final level = getLevel(totalSpent);
    if (level == MemberLevel.platinum) return 0;

    final nextReq = getNextLevelRequirement(level);
    final remainingSpend = nextReq - totalSpent;
    if (remainingSpend <= 0) return 0;

    return calculatePoints(remainingSpend);
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
