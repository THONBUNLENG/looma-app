import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopping_app/manager/cart_manager.dart';

part 'bag_event.dart';

part 'bag_state.dart';

class BagBloc extends Bloc<BagEvent, BagState> {
  final CartManager _cartManager = CartManager();
  StreamSubscription? _cartSubscription;

  BagBloc() : super(BagInitial()) {
    on<BagStarted>(_onStarted);
    on<BagItemRemoved>(_onItemRemoved);
    on<BagItemUpdated>(_onItemUpdated);
    on<BagSelectionToggled>(_onSelectionToggled);
    on<BagAllSelected>(_onAllSelected);
    on<BagSelectedRemoved>(_onSelectedRemoved);
    on<BagVoucherApplied>(_onVoucherApplied);

    // Listen to CartManager changes and trigger a refresh
    _cartManager.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    add(BagStarted());
  }

  Future<void> _onStarted(BagStarted event, Emitter<BagState> emit) async {
    String? currentAppliedCode;
    double currentAppliedDiscount = 0.0;

    if (state is BagLoaded) {
      final currentState = state as BagLoaded;
      currentAppliedCode = currentState.appliedCode;
      currentAppliedDiscount = currentState.appliedDiscount;
    }

    emit(
      BagLoaded(
        items: _cartManager.cartItems,
        subtotal: _cartManager.subtotal,
        totalQuantity: _cartManager.totalQuantity,
        isAllSelected: _cartManager.isAllSelected,
        appliedCode: currentAppliedCode,
        appliedDiscount: currentAppliedDiscount,
      ),
    );
  }

  Future<void> _onItemRemoved(
    BagItemRemoved event,
    Emitter<BagState> emit,
  ) async {
    await _cartManager.removeFromCart(event.index);
  }

  Future<void> _onItemUpdated(
    BagItemUpdated event,
    Emitter<BagState> emit,
  ) async {
    await _cartManager.updateItem(event.index, event.item);
  }

  Future<void> _onSelectionToggled(
    BagSelectionToggled event,
    Emitter<BagState> emit,
  ) async {
    await _cartManager.toggleSelection(event.index);
  }

  Future<void> _onAllSelected(
    BagAllSelected event,
    Emitter<BagState> emit,
  ) async {
    await _cartManager.selectAll(event.selected);
  }

  Future<void> _onSelectedRemoved(
    BagSelectedRemoved event,
    Emitter<BagState> emit,
  ) async {
    await _cartManager.removeSelected();
  }

  Future<void> _onVoucherApplied(
    BagVoucherApplied event,
    Emitter<BagState> emit,
  ) async {
    if (state is BagLoaded) {
      final currentState = state as BagLoaded;
      emit(
        currentState.copyWith(
          appliedCode: event.code,
          // We'd ideally set the discount amount here if we had the voucher logic in a repository
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _cartManager.removeListener(_onCartChanged);
    _cartSubscription?.cancel();
    return super.close();
  }
}
