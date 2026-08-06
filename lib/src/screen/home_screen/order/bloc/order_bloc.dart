import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../model/order_model.dart';
import '../../../../network/crud_firebase/firestore_service.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final FirestoreService _firestoreService = FirestoreService();

  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        await _firestoreService.createOrder(event.order);
        emit(OrderSuccess(order: event.order));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });

    on<FetchOrders>((event, emit) async {
      emit(OrderLoading());
      try {

        emit(OrderSuccess(orders: []));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });
  }
}
