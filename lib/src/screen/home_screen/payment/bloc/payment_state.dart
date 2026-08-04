part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentInitiated extends PaymentState {
  final PaymentTransaction transaction;

  PaymentInitiated(this.transaction);
}

final class PaymentProcessing extends PaymentState {
  final PaymentTransaction transaction;

  PaymentProcessing(this.transaction);
}

final class PaymentSuccess extends PaymentState {
  final PaymentTransaction transaction;

  PaymentSuccess(this.transaction);
}

final class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}
