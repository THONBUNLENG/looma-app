enum PaymentMethod {
  khqr,
  abaPay,
  abaKhqr,
  visa,
  mastercard,
  cashOnDelivery,
  bankTransfer,
}

enum PaymentStatus {
  pending,
  initiated,
  processing,
  success,
  failed,
  expired,
}

class PaymentTransaction {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime timestamp;
  final String? md5Hash; // For Bakong
  final String? payload; // For QR string or payment URL

  const PaymentTransaction({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.timestamp,
    this.md5Hash,
    this.payload,
  });

  PaymentTransaction copyWith({
    String? id,
    String? orderId,
    double? amount,
    String? currency,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? timestamp,
    String? md5Hash,
    String? payload,
  }) {
    return PaymentTransaction(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      method: method ?? this.method,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      md5Hash: md5Hash ?? this.md5Hash,
      payload: payload ?? this.payload,
    );
  }
}
