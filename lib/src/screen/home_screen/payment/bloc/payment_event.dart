part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class InitiatePayment extends PaymentEvent {
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethod method;

  InitiatePayment({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
  });
}

class CheckPaymentStatus extends PaymentEvent {
  final PaymentTransaction transaction;
  final String? bakongToken;

  CheckPaymentStatus({
    required this.transaction,
    this.bakongToken,
  });
}

class UpdatePaymentStatus extends PaymentEvent {
  final PaymentStatus status;

  UpdatePaymentStatus(this.status);
}

class ResetPayment extends PaymentEvent {}
