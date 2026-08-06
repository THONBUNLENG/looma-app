import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:shopping_app/manager/cart_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'package:shopping_app/src/network/datastor/aba_payway_service.dart';
import 'package:shopping_app/constants/string_extension.dart';

class AbaPaymentScreen extends StatefulWidget {
  final double amount;
  final String orderId;
  final String merchantName;

  const AbaPaymentScreen({
    super.key,
    required this.amount,
    required this.orderId,
    this.merchantName = 'LOOMA SHOP',
  });

  @override
  State<AbaPaymentScreen> createState() => _AbaPaymentScreenState();
}

class _AbaPaymentScreenState extends State<AbaPaymentScreen> {
  static const Color abaTealStart = Color(0xFF005a8d);
  static const Color abaTealAccent = Color(0xFF005a8d);
  static const Color abaBlue = Color(0xFF005a8d);

  static const int _lifetimeMinutes = 5;

  Timer? _pollingTimer;
  Timer? _countdownTimer;
  DateTime? _deadline;

  bool _loading = true;
  bool _isCheckingStatus = false;
  String? _error;
  Map<String, dynamic>? _qrData;
  Duration _remaining = const Duration(minutes: _lifetimeMinutes);

  @override
  void initState() {
    super.initState();
    _loadQr();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadQr() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    _pollingTimer?.cancel();
    _countdownTimer?.cancel();

    try {
      final items = base64Encode(utf8.encode(jsonEncode([
        {
          'name': 'Order #${widget.orderId}',
          'quantity': 1,
          'price': widget.amount.toStringAsFixed(2)
        }
      ])));

      final result = await AbaPayWayService.generateQr(
        transactionId: widget.orderId,
        amount: widget.amount,
        items: items,
        lifetimeMinutes: _lifetimeMinutes,
      );

      final status = result['status'];
      final code = status is Map ? status['code']?.toString() : status?.toString();

      if (code == '0' || code == '00') {
        setState(() {
          _qrData = result;
          _loading = false;
          _deadline = DateTime.now().add(const Duration(minutes: _lifetimeMinutes));
          _remaining = const Duration(minutes: _lifetimeMinutes);
        });
        _startPolling();
        _startCountdown();
      } else {
        final message = status is Map ? status['message']?.toString() : 'Failed to generate QR';
        setState(() {
          _error = message ?? 'Failed to generate QR code';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_deadline == null) return;
      final left = _deadline!.difference(DateTime.now());
      if (left.isNegative) {
        timer.cancel();
        setState(() => _remaining = Duration.zero);
      } else if (mounted) {
        setState(() => _remaining = left);
      }
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (_deadline != null && DateTime.now().isAfter(_deadline!)) {
        timer.cancel();
        return;
      }

      if (_isCheckingStatus) return;

      _isCheckingStatus = true;
      final result = await AbaPayWayService.checkTransaction(widget.orderId);
      _isCheckingStatus = false;

      if (result['status'] == '0' || result['status'] == 0) {
        timer.cancel();
        if (mounted) {
          _onPaymentSuccess();
        }
      }
    });
  }

  void _onPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 24),
            TextWidget(
              "Payment Successful!".tr,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextWidget(
              "Your transaction for Order #${widget.orderId} has been completed successfully.".tr,
              textAlign: TextAlign.center,
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              lineHeight: 1.5,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  CartManager().clearCart();
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: abaBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: TextWidget(
                  "Back to Home".tr,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? _decodeQrImage() {
    final raw = _qrData?['qrImage'] as String?;
    if (raw == null) return null;
    final commaIndex = raw.indexOf(',');
    final base64Part = commaIndex >= 0 ? raw.substring(commaIndex + 1) : raw;
    try {
      return base64Decode(base64Part);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining <= Duration.zero && !_loading && _error == null;

    return Scaffold(
      backgroundColor: abaTealAccent,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [abaTealStart, abaTealAccent],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Main Content Card
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // White Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: _buildCardContent(expired),
                      ),
                      
                      // Floating Merchant Logo
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/image/logo4-removebg.png',
                                color: Colors.black,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.account_balance_rounded,
                                  color: abaBlue,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(bool expired) {
    return Column(
      children: [
        const SizedBox(height: 50),
        
        // Merchant Name
        TextWidget(
          widget.merchantName.tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        
        const SizedBox(height: 4),
        
        // Instruction & Arrow
        if (_error == null && !_loading) ...[
          TextWidget(
            "Scan here to pay".tr,
            fontSize: 14,
            color: Colors.black38,
          ),
          const SizedBox(height: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black12, size: 24),
        ],
        
        const SizedBox(height: 20),
        
        // QR Section or Error
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildQRSpace(expired),
          ),
        ),
        
        // Payment Method Footer
        _buildFooter(),
      ],
    );
  }

  Widget _buildQRSpace(bool expired) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: abaTealAccent));
    }

    if (_error != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2B38),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                "technical_problem_contact_aba".tr,
                color: Colors.white,
                fontSize: 18,
                lineHeight: 1.6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "[SERVER-ERR]",
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 13,
                  ),
                  TextButton(
                    onPressed: _loadQr,
                    child: TextWidget(
                      "agree".tr,
                      color: const Color(0xFF16BFC0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final qrBytes = _decodeQrImage();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (expired)
          TextWidget("QR expired".tr, color: Colors.black45)
        else if (qrBytes != null)
          _buildQRWithCorners(qrBytes),
        
        const SizedBox(height: 30),
        
        // Price
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: r'$',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              TextSpan(
                text: widget.amount.toStringAsFixed(2),
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Timer
        if (!expired && !_loading)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: Colors.black26),
              const SizedBox(width: 6),
              TextWidget("${_remaining.inSeconds} secs", fontSize: 13, color: Colors.black26),
            ],
          ),
          
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildQRWithCorners(Uint8List qrBytes) {
    const double qrSize = 180.0;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // The QR Image
        Image.memory(qrBytes, width: qrSize, height: qrSize, fit: BoxFit.contain),
        
        // Corners
        SizedBox(
          width: qrSize + 20,
          height: qrSize + 20,
          child: Stack(
            children: [
              // Top Left
              _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),
              // Top Right
              _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),
              // Bottom Left
              _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
              // Bottom Right
              _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right, required bool isTop, required bool isLeft}) {
    const double length = 20.0;
    const double thickness = 3.5;
    
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: length,
        height: length,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: abaTealAccent, width: thickness) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: abaTealAccent, width: thickness) : BorderSide.none,
            left: isLeft ? const BorderSide(color: abaTealAccent, width: thickness) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: abaTealAccent, width: thickness) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          TextWidget("Payment method", fontSize: 13, color: Colors.black45),
          const Spacer(),
          _buildMiniBrand('ABA'),
          const SizedBox(width: 6),
          _buildMiniBrand('VISA'),
          const SizedBox(width: 6),
          _buildMiniBrand('Mastercard'),
          const SizedBox(width: 6),
          _buildMiniBrand('UnionPay'),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildMiniBrand(String brand) {
    String assetPath = '';
    switch (brand) {
      case 'ABA':
        assetPath = 'assets/icon/i_color/aba.png';
        break;
      case 'VISA':
        assetPath = 'assets/icon/i_color/visa.png';
        break;
      case 'Mastercard':
        assetPath = 'assets/icon/i_color/mastercard.png';
        break;
      case 'UnionPay':
        assetPath = 'assets/icon/i_color/union_pay.png';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(2),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Text(brand[0], style: const TextStyle(fontSize: 8))),
      ),
    );
  }
}