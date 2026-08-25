// ignore_for_file: non_const_argument_for_const_parameter

import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String iconType;
  final Color? iconColor;
  final String? payload;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.iconType,
    this.iconColor,
    this.payload,
  });

  IconData get icon {
    switch (iconType) {
      case 'sms':
        return Icons.sms_outlined;
      default:
        return Icons.notifications_active_outlined;
    }
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    String? iconType,
    Color? iconColor,
    String? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      iconType: iconType ?? this.iconType,
      iconColor: iconColor ?? this.iconColor,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
      'iconType': iconType,
      'iconColor': iconColor?.toARGB32(),
      'payload': payload,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      timestamp: DateTime.parse(json['timestamp']),
      iconType: json['iconType'] ?? 'default',
      iconColor: json['iconColor'] != null ? Color(json['iconColor']) : null,
      payload: json['payload'],
    );
  }
}
