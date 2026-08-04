import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../../../model/payment_model.dart';
import '../../../../network/repository/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        super(PaymentInitial()) {
    
    on<InitiatePayment>(_onInitiatePayment);
    on<CheckPaymentStatus>(_onCheckPaymentStatus);
    on<ResetPayment>(_onResetPayment);
  }

  Future<void> _onInitiatePayment(
    InitiatePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final transaction = await _paymentRepository.initiatePayment(
        orderId: event.orderId,
        amount: event.amount,
        currency: event.currency,
        method: event.method,
      );
      emit(PaymentInitiated(transaction));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    // We don't want to show loading every time we poll, 
    // unless it's the very first manual check.
    try {
      final newStatus = await _paymentRepository.checkPaymentStatus(
        event.transaction,
        bakongToken: event.bakongToken,
      );

      if (newStatus == PaymentStatus.success) {
        emit(PaymentSuccess(event.transaction.copyWith(status: newStatus)));
      } else if (newStatus == PaymentStatus.failed) {
        emit(PaymentFailure("Payment failed"));
      } else {
        // Stay in processing or initiated state
        emit(PaymentProcessing(event.transaction.copyWith(status: newStatus)));
      }
    } catch (e) {
      // On polling error, we might just want to keep the current state
    }
  }

  void _onResetPayment(ResetPayment event, Emitter<PaymentState> emit) {
    emit(PaymentInitial());
  }
}
