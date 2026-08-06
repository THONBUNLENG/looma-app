import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/model/payment_model.dart';
import 'package:shopping_app/src/network/repository/payment_repository.dart';
import 'package:shopping_app/src/screen/home_screen/order/order_success_screen.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'bakong_khqr_payment_screen.dart';
import 'aba_payment.dart';
import 'bloc/payment_bloc.dart';

class CheckoutPaymentScreen extends StatelessWidget {
  final double totalAmount;
  final String orderId;
  final String paymentMethod;

  const CheckoutPaymentScreen({
    super.key,
    this.totalAmount = 0.0,
    this.orderId = "ORD-0000",
    this.paymentMethod = "Bank transfer",
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(paymentRepository: PaymentRepository()),
      child: CheckoutPaymentView(
        totalAmount: totalAmount,
        orderId: orderId,
        paymentMethod: paymentMethod,
      ),
    );
  }
}

class CheckoutPaymentView extends StatefulWidget {
  final double totalAmount;
  final String orderId;
  final String paymentMethod;
  const CheckoutPaymentView({
    super.key,
    required this.totalAmount,
    required this.orderId,
    required this.paymentMethod,
  });

  @override
  State<CheckoutPaymentView> createState() => _CheckoutPaymentViewState();
}

class _CheckoutPaymentViewState extends State<CheckoutPaymentView> {

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'KHQR',
      'image': 'assets/icon/khqr.png',
      'subtitle': 'Scan to pay with any banking app',
      'method': PaymentMethod.khqr,
    },
    {
      'name': 'ABA KHQR',
      'image': 'assets/icon/i_color/aba.png',
      'subtitle': 'Scan to pay with any banking app',
      'method': PaymentMethod.abaKhqr,
    },
  ];

  void _handlePaymentExecution(PaymentMethod method) {
    context.read<PaymentBloc>().add(
      InitiatePayment(
        orderId: widget.orderId,
        amount: widget.totalAmount,
        currency: 'USD',
        method: method,
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext rootContext) {
    CartManager().clearCart();
    Navigator.pushAndRemoveUntil(
      rootContext,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(
          orderId: widget.orderId,
          totalAmount: widget.totalAmount,
          paymentMethod: widget.paymentMethod,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
    isDark ? theme.colorScheme.surface : const Color(0xFFF8F9FA);
    final cardColor =
    isDark ? theme.colorScheme.surfaceContainer : Colors.white;
    final borderColor =
    isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.1);

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentInitiated) {
          if (state.transaction.method == PaymentMethod.khqr) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => KhqrPaymentScreen(
                  amount: state.transaction.amount,
                  currency: state.transaction.currency,
                  orderId: state.transaction.orderId,
                  bakongToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImlkIjoiMTM1YmJiNTUyYmYwNDIyNiJ9LCJpYXQiOjE3Nzk3Nzc3NjIsImV4cCI6MTc4NzU1Mzc2Mn0.mcbViUl6l9JRAsWMAiv0nj5J_E0',
                ),
              ),
            );
          } else if (state.transaction.method == PaymentMethod.abaKhqr) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AbaPaymentScreen(
                  amount: state.transaction.amount,
                  orderId: state.transaction.orderId,
                ),
              ),
            );
          } else {
            _showPaymentSuccessDialog(context);
          }
        } else if (state is PaymentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidget(state.error.tr)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: BackButton(color: theme.colorScheme.onSurface,),
          title: TextWidget(
            "Payment Option".tr,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemCount: _paymentMethods.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final method = _paymentMethods[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handlePaymentExecution(method['method']),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  method['image']!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                  const Icon(Icons.payment_rounded, size: 30),
                                ),
                              ),
                            ),
                            if (method['name'] == 'ABA KHQR')
                              Container(
                                width: double.infinity,
                                height: 18,
                                color: const Color(0xFFE31B23),
                                alignment: Alignment.center,
                                child: const Text(
                                  "KHQR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              (method['name'] as String).tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            const SizedBox(height: 4),
                            TextWidget(
                              (method['subtitle'] as String).tr,
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}