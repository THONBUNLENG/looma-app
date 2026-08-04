
import '../../model/payment_model.dart';
import '../datastor/aba_payway_service.dart';
import '../datastor/bakong_service.dart';

class PaymentRepository {

  /// Initiate a payment based on the selected method
  Future<PaymentTransaction> initiatePayment({
    required String orderId,
    required double amount,
    required String currency,
    required PaymentMethod method,
  }) async {
    // In a real app, this would call your backend to create a transaction record
    // and get the necessary tokens/payloads for the payment gateways.
    
    final id = "TXN-${DateTime.now().millisecondsSinceEpoch}";
    
    return PaymentTransaction(
      id: id,
      orderId: orderId,
      amount: amount,
      currency: currency,
      method: method,
      status: PaymentStatus.initiated,
      timestamp: DateTime.now(),
    );
  }

  /// Check the status of a specific transaction
  Future<PaymentStatus> checkPaymentStatus(PaymentTransaction transaction, {String? bakongToken}) async {
    if (transaction.method == PaymentMethod.khqr) {
      if (transaction.md5Hash == null || bakongToken == null) return transaction.status;
      
      final result = await BakongService.checkTransactionByMd5(
        md5: transaction.md5Hash!,
        token: bakongToken,
      );
      return (result['success'] == true) ? PaymentStatus.success : PaymentStatus.pending;
    } 
    
    if (transaction.method == PaymentMethod.abaPay) {
      final result = await AbaPayWayService.checkTransaction(transaction.id);
      if (result['status'] == 0 || result['status'] == '0') {
        return PaymentStatus.success;
      }
      return PaymentStatus.pending;
    }

    return transaction.status;
  }
}
