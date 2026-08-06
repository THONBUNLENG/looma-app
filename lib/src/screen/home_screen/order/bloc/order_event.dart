part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final OrderModel order;
  PlaceOrder(this.order);
}

class FetchOrders extends OrderEvent {
  final String userId;
  FetchOrders(this.userId);
}
