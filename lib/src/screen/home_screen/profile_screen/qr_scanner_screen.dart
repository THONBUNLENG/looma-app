import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import '../../../../constants/string_extension.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null) {
        setState(() => _isScanned = true);
        Navigator.pop(context, code);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Implementation
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),

          // Custom Scanner Overlay
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: scanAreaSize,
                    width: scanAreaSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scanning Frame/Corners
          Align(
            alignment: Alignment.center,
            child: CustomPaint(
              size: Size(scanAreaSize, scanAreaSize),
              painter: ScannerCornersPainter(),
            ),
          ),

          // UI Elements (App Bar & Controls)
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                const Spacer(),
                _buildInstructionText(),
                const SizedBox(height: 40),
                _buildBottomControls(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          TextWidget(
            'Scan QR Code'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48), // Balance for the close button
        ],
      ),
    );
  }

  Widget _buildInstructionText() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextWidget(
        'Align the QR code within the frame to scan'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
          onPressed: () {
            controller.toggleTorch();
            setState(() => _isFlashOn = !_isFlashOn);
          },
        ),
        const SizedBox(width: 40),
        _buildActionButton(
          icon: Icons.image_outlined,
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null && mounted) {
              final BarcodeCapture? capture = await controller.analyzeImage(image.path);
              if (capture != null && capture.barcodes.isNotEmpty) {
                final String? code = capture.barcodes.first.rawValue;
                if (code != null && mounted) {
                  setState(() => _isScanned = true);
                  Navigator.pop(context, code);
                }
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: TextWidget(
                      'No QR code found in image'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(width: 40),
        _buildActionButton(
          icon: _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
          onPressed: () {
            controller.switchCamera();
            setState(() => _isFrontCamera = !_isFrontCamera);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}

class ScannerCornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    final path = Path();

    // Top Left
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top Right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom Right
    path.moveTo(size.width, size.width - cornerLength);
    path.lineTo(size.width, size.width);
    path.lineTo(size.width - cornerLength, size.width);

    // Bottom Left
    path.moveTo(cornerLength, size.width);
    path.lineTo(0, size.width);
    path.lineTo(0, size.width - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
