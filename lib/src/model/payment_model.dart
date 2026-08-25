enum PaymentMethod {
  khqr,
  abaPay,
  abaKhqr,
  visa,
  mastercard,
  cashOnDelivery,
  bankTransfer,
  acleda,
  wing,
  chipMong,
}

class PaymentMethodInfo {
  final String title;
  final String subtitle;
  final String icon;
  final List<String>? logos;
  final PaymentMethod method;

  const PaymentMethodInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.logos,
    required this.method,
  });
}

const List<PaymentMethodInfo> kPaymentMethods = [
  PaymentMethodInfo(
    title: 'ABA PAY',
    subtitle: 'Tap to pay with ABA Mobile',
    icon: 'assets/icon/i_color/aba.png',
    method: PaymentMethod.abaPay,
  ),
  PaymentMethodInfo(
    title: 'Credit/Debit Card',
    subtitle: 'Visa, Mastercard...',
    icon: 'assets/icon/card.png',
    logos: [
      'assets/icon/i_color/visa.png',
      'assets/icon/i_color/mastercard.png',
      'assets/icon/i_color/union_pay.png',
    ],
    method: PaymentMethod.visa,
  ),
  PaymentMethodInfo(
    title: 'ACLEDA mobile',
    subtitle: 'Pay securely with ACLEDA.',
    icon: 'assets/icon/i_color/ac.png',
    method: PaymentMethod.acleda,
  ),
  PaymentMethodInfo(
    title: 'Wing Bank',
    subtitle: 'Pay securely with Wing Bank',
    icon: 'assets/icon/i_color/wing.png',
    method: PaymentMethod.wing,
  ),
  PaymentMethodInfo(
    title: 'CHIP MONG BANK',
    subtitle: 'Tap to pay with CHIP MONG',
    icon: 'assets/icon/i_color/chip_mong.png',
    method: PaymentMethod.chipMong,
  ),
  PaymentMethodInfo(
    title: 'Bank transfer',
    subtitle: 'ទូទាត់តាមភ្នាក់ងារផ្សេងៗ',
    icon: 'assets/icon/i_color/bank_transfer.png',
    method: PaymentMethod.bankTransfer,
  ),
  PaymentMethodInfo(
    title: 'Cash on Delivery',
    subtitle: 'បង់ប្រាក់នៅពេលដែលអ្នកទទួលបានទំនិញ',
    icon: 'assets/icon/i_color/cash_on_delivery.png',
    method: PaymentMethod.cashOnDelivery,
  ),
];

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
  final String? payload;

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
