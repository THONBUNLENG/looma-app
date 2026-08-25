import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String deliveryMethod;
  final Map<String, dynamic> address;
  final DateTime createdAt;
  final String? promoCode;
  final double? discountAmount;
  final int? pointsRedeemed;
  final int? pointsRewarded;
  final String? note;
  final String? contactLine;
  final int? contactMethod; // 0: Phone, 1: Telegram, 2: WhatsApp

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.address,
    required this.createdAt,
    this.promoCode,
    this.discountAmount,
    this.pointsRedeemed,
    this.pointsRewarded,
    this.note,
    this.contactLine,
    this.contactMethod,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DateTime safeCreatedAt;
    try {
      if (data['createdAt'] is Timestamp) {
        safeCreatedAt = (data['createdAt'] as Timestamp).toDate();
      } else if (data['createdAt'] is String) {
        safeCreatedAt = DateTime.parse(data['createdAt']);
      } else {
        safeCreatedAt = DateTime.now();
      }
    } catch (_) {
      safeCreatedAt = DateTime.now();
    }

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Pending',
      paymentMethod: data['paymentMethod'] ?? '',
      deliveryMethod: data['deliveryMethod'] ?? '',
      address: Map<String, dynamic>.from(data['address'] ?? {}),
      createdAt: safeCreatedAt,
      promoCode: data['promoCode'],
      discountAmount: (data['discountAmount'] ?? 0.0).toDouble(),
      pointsRedeemed: data['pointsRedeemed'],
      pointsRewarded: data['pointsRewarded'],
      note: data['note'],
      contactLine: data['contactLine'],
      contactMethod: data['contactMethod'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryMethod': deliveryMethod,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'promoCode': promoCode,
      'discountAmount': discountAmount,
      'pointsRedeemed': pointsRedeemed,
      'pointsRewarded': pointsRewarded,
      'note': note,
      'contactLine': contactLine,
      'contactMethod': contactMethod,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      paymentMethod: json['paymentMethod'] ?? '',
      deliveryMethod: json['deliveryMethod'] ?? '',
      address: Map<String, dynamic>.from(json['address'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      promoCode: json['promoCode'],
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      pointsRedeemed: json['pointsRedeemed'],
      pointsRewarded: json['pointsRewarded'],
      note: json['note'],
      contactLine: json['contactLine'],
      contactMethod: json['contactMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryMethod': deliveryMethod,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'promoCode': promoCode,
      'discountAmount': discountAmount,
      'pointsRedeemed': pointsRedeemed,
      'pointsRewarded': pointsRewarded,
      'note': note,
      'contactLine': contactLine,
      'contactMethod': contactMethod,
    };
  }

  Map<String, dynamic> toMap() => toFirestore();
}
