import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:khqr_sdk/khqr_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../network/datastor/bakong_service.dart';
import '../../../widget/button_cus.dart';
import 'qr_expired_screen.dart';

class KhqrPaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final String orderId;
  final String bakongToken;

  const KhqrPaymentScreen({
    super.key,
    required this.amount,
    required this.currency,
    required this.orderId,
    required this.bakongToken,
  });

  @override
  State<KhqrPaymentScreen> createState() => _KhqrPaymentScreenState();
}

class _KhqrPaymentScreenState extends State<KhqrPaymentScreen> {
  final GlobalKey _qrCardKey = GlobalKey();

  String? _qrPayload;
  String? _md5Hash;
  Timer? _pollingTimer;
  Timer? _countdownTimer;

  int _remainingSeconds = 300;
  bool _isExpired = false;
  bool _isPaid = false;
  bool _isSaving = false;
  bool _hasError = false;

  static const Color khqrRed = Color(0xFFE31B23);

  @override
  void initState() {
    super.initState();
    _generateKhqr();
  }

  void _generateKhqr() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();

    if (widget.bakongToken.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    setState(() {
      _qrPayload = null;
      _md5Hash = null;
      _isExpired = false;
      _isPaid = false;
      _hasError = false;
      _remainingSeconds = 300;
    });

    try {
      final expireTimestamp = DateTime.now()
          .add(const Duration(seconds: 300))
          .millisecondsSinceEpoch;

      final bool isUsd = widget.currency == 'USD';
      final String accountId = isUsd ? '007276456' : '007276457';

      final merchantInfo = MerchantInfo(
        bakongAccountId: '$accountId@aba',
        acquiringBank: 'ABA Bank',
        merchantId: accountId,
        merchantName: 'LOOMA SHOP',
        currency: isUsd ? KhqrCurrency.usd : KhqrCurrency.khr,
        amount: widget.amount,
        expirationTimestamp: expireTimestamp,
        billNumber: widget.orderId,
        storeLabel: 'Looma Shop',
        terminalLabel: 'Mobile App',
      );

      final response = KhqrSdk.generateMerchant(merchantInfo);

      if (response.status.code == 0 && response.data != null) {
        final qrString = response.data!.qr;
        final md5Hash = md5.convert(utf8.encode(qrString)).toString();

        setState(() {
          _qrPayload = qrString;
          _md5Hash = md5Hash;
        });

        _startTimer();
        _startPolling();
      } else {
        setState(() => _hasError = true);
      }
    } catch (e) {
      setState(() => _hasError = true);
    }
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _pollingTimer?.cancel();
        setState(() => _isExpired = true);
        _navigateToExpiredScreen();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _navigateToExpiredScreen() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrExpiredScreen(
          onRefresh: _generateKhqr,
        ),
      ),
    );
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _isExpired || _isPaid) return;
      
      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (_md5Hash == null || _isExpired || _isPaid) return;

        final result = await BakongService.checkTransactionByMd5(
          md5: _md5Hash!,
          token: widget.bakongToken,
        );

        if (!mounted) {
          timer.cancel();
          return;
        }

        if (result['success'] == true) {
          timer.cancel();
          _countdownTimer?.cancel();
          setState(() => _isPaid = true);
          _onPaymentSuccess();
        }
      });
    });
  }

  void _onPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
            ),
            const SizedBox(height: 20),
            TextWidget(
              "Payment Successful!".tr,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            TextWidget(
              "Your transaction for Order #${widget.orderId} was completed.".tr,
              textAlign: TextAlign.center,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 28),
            ButtonCus(
              buttonName: "Back to Home".tr,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              bgColor: khqrRed,
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _capturePngBytes() async {
    try {
      final boundary =
          _qrCardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: TextWidget(message.tr, color: Colors.white),
        backgroundColor: isError ? Colors.red[700] : Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _downloadQrCode() async {
    if (_qrPayload == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final bytes = await _capturePngBytes();
      if (bytes == null) {
        _showSnack("Could not capture QR image", isError: true);
        return;
      }

      await Gal.putImageBytes(bytes, album: 'Thon Bunleng');
      _showSnack("Saved KHQR to Gallery!");
    } catch (e) {
      _showSnack("Failed to save QR Code", isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _shareQrCode() async {
    if (_qrPayload == null) return;

    try {
      final bytes = await _capturePngBytes();
      if (bytes == null) {
        _showSnack("Could not capture QR image", isError: true);
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file =
          await File('${tempDir.path}/khqr_${widget.orderId}.png').create();
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Scan this KHQR to pay ${widget.amount.toStringAsFixed(2)} ${widget.currency} for Order #${widget.orderId}',
      );
    } catch (e) {
      _showSnack("Could not share QR Code", isError: true);
    }
  }

  void _copyQrData() {
    if (_qrPayload == null) return;
    Clipboard.setData(ClipboardData(text: _qrPayload!));
    _showSnack("KHQR data copied to clipboard!");
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? theme.colorScheme.surface : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: const BackButton(color: Colors.black),
        title: TextWidget(
          "My QR Code".tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _qrCardKey,
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white, // Always white for the ticket look
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Red Header
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: khqrRed,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: const Center(
                          child: Text(
                            "KHQR",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),

                      // Merchant Info Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Thon Bunleng",
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                TextWidget(
                                  widget.amount.toStringAsFixed(2),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                TextWidget(
                                  widget.currency,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Dashed Line
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : Colors.grey.withValues(alpha: 0.3),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // QR Code
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: Container(
                          width: 220,
                          height: 220,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_hasError)
                                Positioned.fill(
                                  child: _StatusOverlay(
                                    title: "QR code could not be generated".tr,
                                    message:
                                        "Ensure you have a stable internet connection and try again."
                                            .tr,
                                    buttonLabel: "Try Again".tr,
                                    onPressed: _generateKhqr,
                                  ),
                                )
                              else if (_qrPayload != null)
                                QrImageView(
                                  data: _qrPayload!,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  embeddedImage:
                                      const AssetImage('assets/icon/bakong.png'),
                                  embeddedImageStyle: const QrEmbeddedImageStyle(
                                    size: Size(36, 36),
                                  ),
                                  eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.square,
                                    color: Colors.black,
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.square,
                                    color: Colors.black,
                                  ),
                                )
                              else
                                const Center(
                                  child:
                                      CircularProgressIndicator(color: khqrRed),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),
              TextWidget(
                "Scan with Bakong App or Mobile Banking app that support KHQR".tr,
                textAlign: TextAlign.center,
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
                lineHeight: 1.5,
              ),

              const SizedBox(height: 24),
              // Action Buttons Section
              if (_qrPayload != null && !_isExpired && !_hasError)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Copy Button
                    Column(
                      children: [
                        InkWell(
                          onTap: _copyQrData,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.copy_rounded,
                                color: theme.colorScheme.onSurface, size: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextWidget(
                          "Copy".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    // Download Button
                    Column(
                      children: [
                        InkWell(
                          onTap: _isSaving ? null : _downloadQrCode,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: khqrRed),
                                  )
                                : Icon(Icons.download_rounded,
                                    color: theme.colorScheme.onSurface,
                                    size: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextWidget(
                          "Save".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    // Share Button
                    Column(
                      children: [
                        InkWell(
                          onTap: _shareQrCode,
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.share_rounded,
                                color: theme.colorScheme.onSurface, size: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextWidget(
                          "Share".tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),

              const SizedBox(height: 48),

              // Summary Payment Section
              Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  "Summary Payment".tr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:
                      isDark ? theme.colorScheme.surfaceContainer : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget("Amount".tr,
                            color: theme.colorScheme.onSurfaceVariant),
                        TextWidget("\$${widget.amount.toStringAsFixed(2)}",
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          "Total".tr,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        TextWidget(
                          "\$${widget.amount.toStringAsFixed(2)}",
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              if (!_isExpired && !_isPaid && !_hasError)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: khqrRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: khqrRed,
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextWidget(
                        "${"Expires in".tr}: ${_formatTime(_remainingSeconds)}",
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: khqrRed,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Refactored Full-Box Overlay Widget with Backdrop Blur & Solid Fill
class _StatusOverlay extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _StatusOverlay({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration( 
            color: isDark
                ? const Color(0xFF1E1E1E).withValues(alpha: 0.98)
                : Colors.white.withValues(alpha: 0.98),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prohibited Icon over QR Code
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 44,
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                  const Icon(
                    Icons.block_flipped,
                    size: 56,
                    color: _KhqrPaymentScreenState.khqrRed,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextWidget(
                title,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              TextWidget(
                message,
                fontSize: 12,
                textAlign: TextAlign.center, 
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              ButtonCus(
                buttonName: buttonLabel,
                onPressed: onPressed,
                bgColor: _KhqrPaymentScreenState.khqrRed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

