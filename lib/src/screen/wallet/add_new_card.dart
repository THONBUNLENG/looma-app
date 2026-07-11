import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/wallet_card_model.dart';
import '../../widget/button.dart';
import '../../widget/text_widget.dart';
import 'color_card.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen>

    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController(
    text: "",
  );
  final TextEditingController _numberController = TextEditingController(
    text: "",
  );
  final TextEditingController _expiryController = TextEditingController(
    text: "",
  );
  final TextEditingController _cvvController = TextEditingController(
    text: "",
  );

  final FocusNode _cvvFocusNode = FocusNode();

  late AnimationController _flipController;
  late AnimationController _shimmerController;

  bool _isFront = true;
  int _selectedColorIndex = 1;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _cvvFocusNode.addListener(() {
      if (_cvvFocusNode.hasFocus && _isFront) {
        _toggleCard();
      } else if (!_cvvFocusNode.hasFocus && !_isFront) {
        _toggleCard();
      }
    });

    _nameController.addListener(() => setState(() {}));
    _numberController.addListener(() => setState(() {}));
    _expiryController.addListener(() => setState(() {}));
    _cvvController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _shimmerController.dispose();
    _cvvFocusNode.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _toggleCard() {
    _isFront ? _flipController.forward() : _flipController.reverse();
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _saveCard() {
    final name = _nameController.text.trim();
    final number = _numberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the card_repository holder's full name")),
      );
      return;
    }

    if (number.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 16-digit card_repository number")),
      );
      return;
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiry)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid expiry date (MM/YY)")),
      );
      return;
    }

    if (cvv.length != 3 || !RegExp(r'^[0-9]+$').hasMatch(cvv)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 3-digit CVV")),
      );
      return;
    }

    final card = WalletCardModel(
      number: _numberController.text,
      expiry: expiry,
      cvv: cvv,
      colorIndex: _selectedColorIndex,
     fullName: name,
    );

    Navigator.pop(context, card);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add New Card',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildAnimatedCard(),
                  const SizedBox(height: 30),
                  _buildLabel(context, "Select Card Color"),
                  _buildColorSelector(),
                  const SizedBox(height: 25),
                  _buildLabel(context, "Card Holder Name"),
                  _buildField(context, _nameController, "FULL NAME"),
                  const SizedBox(height: 20),
                  _buildLabel(context, "Card Number"),
                  _buildField(
                    context,
                    _numberController,
                    "0000 0000 0000 0000",
                    isNumber: true,
                    formatters: [
                      CardNumberFormatter(),
                      LengthLimitingTextInputFormatter(19),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(context, "Expiry Date"),
                            _buildField(
                              context,
                              _expiryController,
                              "MM/YY",
                              icon: Icons.calendar_today,
                              formatters: [
                                ExpiryDateFormatter(),
                                LengthLimitingTextInputFormatter(5),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(context, "CVV"),
                            _buildField(
                              context,
                              _cvvController,
                              "000",
                              isNumber: true,
                              focusNode: _cvvFocusNode,
                              formatters: [LengthLimitingTextInputFormatter(3)],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: MyCustomButton(
              text: 'Save Card',
              onPressed: _saveCard,
              width: double.infinity,
              height: 58,
              borderRadius: 30,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAnimatedCard() {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _flipController,
        builder: (context, child) {
          double angle = _flipController.value * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: angle <= pi / 2
                ? _buildFront()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: _cardBoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: Size.infinite,
                painter: CardMeshPainter(),
              ),
            ),
            _buildShimmerEffect(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Looma Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1,
                        ),
                      ),
                      _buildChip(),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _numberController.text.isEmpty
                        ? "•••• •••• •••• ••••"
                        : _numberController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _cardInfo("Card Holder", _nameController.text),
                      _cardInfo("Valid Thru", _expiryController.text),
                      const Icon(
                        Icons.contactless,
                        color: Colors.white54,
                        size: 22,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      height: 210,
      width: double.infinity,
      decoration: _cardBoxDecoration(),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 48, color: Colors.black.withValues(alpha: 0.8)),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomPaint(painter: SignatureLinePainter()),
                  ),
                ),
                const SizedBox(width: 15),
                TextWidget(
                  "CVV: ${_cvvController.text}",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardBoxDecoration() => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: cardGradients[_selectedColorIndex],
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 20,
        spreadRadius: -5,
        offset: const Offset(0, 12),
      ),
    ],
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: 1,
    ),
  );

  Widget _buildColorSelector() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cardGradients.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => setState(() => _selectedColorIndex = index),
          child: Container(
            width: 42,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: cardGradients[index],
              border: _selectedColorIndex == index
                  ? Border.all(color: Colors.blueAccent, width: 3)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    TextEditingController c,
    String h, {
    bool isNumber = false,
    IconData? icon,
    FocusNode? focusNode,
    List<TextInputFormatter>? formatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: c,
        focusNode: focusNode,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: formatters,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: h,
          suffixIcon: icon != null ? Icon(icon, size: 18) : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );

  Widget _buildChip() => Container(
    width: 42,
    height: 30,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: CustomPaint(painter: ChipLinesPainter()),
  );

  Widget _buildShimmerEffect() => AnimatedBuilder(
    animation: _shimmerController,
    builder: (context, child) => Transform.translate(
      offset: Offset(-400 + (_shimmerController.value * 800), 0),
      child: Transform.rotate(
        angle: pi / 4,
        child: Container(
          width: 100,
          height: 600,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _cardInfo(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(color: Colors.white54, fontSize: 8),
      ),
      Text(
        value.isEmpty ? "---" : value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newVal,
  ) {
    var t = newVal.text.replaceAll(' ', '');
    var b = StringBuffer();
    for (int i = 0; i < t.length; i++) {
      b.write(t[i]);
      if ((i + 1) % 4 == 0 && (i + 1) != t.length) b.write(' ');
    }
    return newVal.copyWith(
      text: b.toString(),
      selection: TextSelection.collapsed(offset: b.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue old,
    TextEditingValue newVal,
  ) {
    var t = newVal.text.replaceAll('/', '');
    var b = StringBuffer();
    for (int i = 0; i < t.length; i++) {
      b.write(t[i]);
      if (i == 1 && t.length > 1) b.write('/');
    }
    return newVal.copyWith(
      text: b.toString(),
      selection: TextSelection.collapsed(offset: b.length),
    );
  }
}

// ====================== PAINTERS ======================
class ChipLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CardMeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    var path = Path();

    for (int i = 1; i < 5; i++) {
      path.moveTo(0, size.height * (i / 5));
      path.quadraticBezierTo(
          size.width / 2, size.height * (i / 5) + 30,
          size.width, size.height * (i / 5)
      );
    }

    for (int i = 1; i < 8; i++) {
      path.moveTo(size.width * (i / 8), 0);
      path.quadraticBezierTo(
          size.width * (i / 8) + 40, size.height / 2,
          size.width * (i / 8), size.height
      );
    }

    canvas.drawPath(path, paint);

    var dotPaint = Paint()..color = Colors.cyanAccent.withValues(alpha: 0.4);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 3, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.6), 2, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.8), 4, dotPaint);
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}

class SignatureLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;
    for (double i = 8; i < size.height; i += 8) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(oldDelegate) => false;
}
