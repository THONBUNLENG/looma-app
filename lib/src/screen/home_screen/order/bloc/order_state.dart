part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderSuccess extends OrderState {
  final OrderModel? order;
  final List<OrderModel>? orders;
  OrderSuccess({this.order, this.orders});
}

final class OrderFailure extends OrderState {
  final String error;
  OrderFailure(this.error);
}
