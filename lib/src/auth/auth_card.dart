// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// import '../src/model/wallet_card_model.dart';
//
//
//
// // Inside _WalletCardScreenState class...
//
// final storage = const FlutterSecureStorage();
//
// Future<void> saveCardsSecurely() async {
//   try {
//     // 1. Convert localCards list to a JSON string
//     final String jsonString = jsonEncode(
//       localCards.map((card_repository) => card_repository.toJson()).toList(),
//     );
//
//     // 2. Write to storage
//     await storage.write(key: 'secure_wallet_cards', value: jsonString);
//     debugPrint("✅ Cards saved successfully");
//   } catch (e) {
//     debugPrint("❌ Error saving cards: $e");
//   }
// }
//
// Future<void> loadSavedCards() async {
//   try {
//     String? jsonString = await storage.read(key: 'secure_wallet_cards');
//
//     if (jsonString != null && jsonString.isNotEmpty) {
//       final List<dynamic> decodedList = jsonDecode(jsonString);
//
//       setState(() {
//         // 1. Map JSON back to Model
//         localCards = decodedList
//             .map((item) => WalletCardModel.fromJson(item))
//             .toList();
//
//         // 2. Re-initialize controllers for the loaded cards
//         flipControllers = List.generate(
//           localCards.length,
//               (_) => AnimationController(
//             vsync: this, // Now works because it's inside the State class
//             duration: const Duration(milliseconds: 600),
//           ),
//         );
//         isFrontList = List.generate(localCards.length, (_) => true);
//       });
//       debugPrint("✅ Loaded ${localCards.length} cards");
//     }
//   } catch (e) {
//     debugPrint("❌ Error loading cards: $e");
//   }
// }