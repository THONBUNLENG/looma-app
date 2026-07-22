import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../model/wallet_card_model.dart';
import 'add_new_card.dart';
import 'color_card.dart';

class WalletCardScreen extends StatefulWidget {
  final List<WalletCardModel> cards;

  const WalletCardScreen({super.key, required this.cards});

  @override
  State<WalletCardScreen> createState() => _WalletCardScreenState();
}

class _WalletCardScreenState extends State<WalletCardScreen>
    with TickerProviderStateMixin {

  late List<WalletCardModel> localCards;
  late List<AnimationController> flipControllers;
  late List<bool> isFrontList;
  late AnimationController _shimmerController;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  final storage = const FlutterSecureStorage();

  Future<void> saveCardsSecurely() async {
    try {

      final String jsonString = jsonEncode(
        localCards.map((card) => card.toJson()).toList(),
      );


      await storage.write(key: 'secure_wallet_cards', value: jsonString);
      debugPrint("✅ Cards saved successfully");
    } catch (e) {
      debugPrint("❌ Error saving cards: $e");
    }
  }

  Future<void> loadSavedCards() async {
    try {
      String? jsonString = await storage.read(key: 'secure_wallet_cards');

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);

        setState(() {
          localCards = decodedList
              .map((item) => WalletCardModel.fromJson(item))
              .toList();

          flipControllers = List.generate(
            localCards.length,
                (_) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 600),
            ),
          );
          isFrontList = List.generate(localCards.length, (_) => true);
        });
        debugPrint("✅ Loaded ${localCards.length} cards");
      }
    } catch (e) {
      debugPrint("❌ Error loading cards: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    localCards = List.from(widget.cards);

    flipControllers = [];
    isFrontList = [];

    loadSavedCards();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    for (var controller in flipControllers) {
      controller.dispose();
    }
    _shimmerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _toggleCard(int index) {
    HapticFeedback.mediumImpact();
    if (isFrontList[index]) {
      flipControllers[index].forward();
    } else {
      flipControllers[index].reverse();
    }
    setState(() => isFrontList[index] = !isFrontList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: _pageController,
        itemCount: localCards.length + 1,
        itemBuilder: (context, index) {
          if (index == localCards.length) {
            return _buildAddCardButton(context);
          }
          final card = localCards[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildCardView(card, index),
          );
        },
      ),
    );
  }

  Widget _buildCardView(WalletCardModel card, int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _toggleCard(index),
          child: AnimatedBuilder(
            animation: flipControllers[index],
            builder: (context, child) {
              double angle = flipControllers[index].value * pi;
              bool showFront = angle <= pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..rotateY(angle),
                child: showFront
                    ? _buildFront(card)
                    : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _buildBack(card),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddCardButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final newCardModel = await Navigator.push<WalletCardModel>(
          context,
          MaterialPageRoute(builder: (_) => const AddNewCardScreen()),
        );

        if (newCardModel != null) {
          final newCard = WalletCardModel(
            number: newCardModel.number,
            fullName: newCardModel.fullName,
            expiry: newCardModel.expiry,
            cvv: newCardModel.cvv,
            colorIndex: newCardModel.colorIndex,
          );

          setState(() {
            localCards.add(newCard);
            flipControllers.add(
                AnimationController(
                    vsync: this,
                    duration: const Duration(milliseconds: 600)
                )
            );
            isFrontList.add(true);
          });

          await saveCardsSecurely();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 40, color: isDark ? Colors.white54 : Colors.black54),
            const SizedBox(height: 8),
            const Text("Add Card", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildFront(WalletCardModel card) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      width: width,
      height: 220,
      decoration: _cardDecoration(card),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: Size(width, 220),
                painter: CardMeshPainter(),
              ),
            ),
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -width + (_shimmerController.value * 3 * width),
                    0,
                  ),
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Container(
                      width: 120,
                      height: 500,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0),
                            Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildLogo(), _buildChip()],
                  ),
                  const Spacer(),
                  Text(
                    card.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _cardLabel("CARD HOLDER", card.fullName),
                      _cardLabel("VALID THRU", card.expiry),
                      Image.asset(
                        'assets/icon/i_color/mastercard.png',
                        height: 45,
                        width: 45,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.credit_card,
                              color: Colors.white54,
                              size: 40,
                            ),
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

  Widget _buildBack(WalletCardModel card) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      width: width,
      height: 220,
      decoration: _cardDecoration(card),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(height: 48, color: Colors.black.withValues(alpha: 0.85)),
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
                Text(
                  card.cvv,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "THIS CARD IS PROPERTY OF THE ISSUING BANK. AUTHORIZED SIGNATURE REQUIRED.\nIF FOUND, PLEASE RETURN TO ANY BRANCH OF THE BANK.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration(WalletCardModel card) {
    final gradient = cardGradients[card.colorIndex % cardGradients.length];
    final gradientColors = (gradient is LinearGradient)
        ? gradient.colors
        : [Colors.blue, Colors.blueAccent];

    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Looma",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "PREMIUM",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildChip() {
    return Container(
      width: 42,
      height: 32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFE6B800)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomPaint(painter: ChipLinesPainter()),
    );
  }

  Widget _cardLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ChipLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    const double padding = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.3 + padding, 0),
      Offset(size.width * 0.3 + padding, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7 - padding, 0),
      Offset(size.width * 0.7 - padding, size.height),
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
