import 'package:televerse/televerse.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../model/order_model.dart';
import '../network/crud_firebase/firestore_service.dart';

class BotManager {
  static final BotManager _instance = BotManager._internal();

  factory BotManager() => _instance;

  BotManager._internal();

  Bot? _bot;
  bool _isRunning = false;
  int? _adminChatId;
  GenerativeModel? _aiModel;

  static const String _token = "8752422469:AAEaAtUqs3zJmu-McbPGvxYofBeKwSc11ZI";

  static const String _geminiModelName = 'gemini-1.5-flash';

  bool get isRunning => _isRunning;

  Future<void> init() async {
    if (_token.isEmpty) {
      debugPrint(
        "⚠️ Missing TELEGRAM_BOT_TOKEN. Set it in BotManager before running.",
      );
    }

    _adminChatId = await FirestoreService().getTelegramAdminChatId();

    _aiModel = FirebaseAI.googleAI().generativeModel(
      model: _geminiModelName,
      systemInstruction: Content.system(r'''
You are the customer support AI for Looma, a modern E-commerce app in Cambodia.
Answer customer questions accurately, politely, and briefly using ONLY the information below. 
If the user greets you, greet them back warmly as Looma AI.

Core Features of Looma App:
- Multi-language: Supports English and Khmer.
- Payments: ABA PayWay, KHQR (Bakong), and standard cards.
- Rewards: Special Birthday Reward system with cash vouchers.
- Authentication: Login via Google, Apple, Facebook, Email, or Phone (OTP).
- Delivery: Integrated with Google Maps for precise location.
- Security: Secure local storage for user data.

Knowledge Base:
- Business Hours: Monday–Saturday, 8:00 AM – 6:00 PM.
- Payment Options: ABA PayWay, KHQR, Credit Card.
- Delivery Fee: $1.50 in Phnom Penh, $2.50 to provinces.
- Returns: Allowed within 7 days with a valid purchase receipt.
- App Support: You can get instant answers for common questions directly in the app's AI Support chat. For more complex issues, contact us via this Telegram group.

If a question cannot be answered from the list above, kindly instruct the user to contact human support in this group or via the "Contact Us" screen in the app.
'''),
    );
  }

  Future<void> start() async {
    if (_isRunning) return;

    if (_token.isEmpty) {
      debugPrint("❌ Cannot start Telegram bot: TELEGRAM_BOT_TOKEN is empty.");
      return;
    }

    try {
      await init();
      _bot = Bot(_token);

      _bot!.command('register', (ctx) async {
        final chatId = ctx.id.id;
        _adminChatId = chatId;
        await FirestoreService().saveTelegramAdminChatId(chatId);

        await ctx.reply(
          "✅ *Registration Successful!*\n\nThis chat (ID: $chatId) is now registered to receive Looma order notifications.",
          parseMode: ParseMode.markdown,
        );
      });

      _bot!.command('start', (ctx) async {
        await ctx.reply(
          "Hello! Welcome to Looma support. How can I help you today?\n\nAdmin Note: Use /register to receive order notifications in this chat.",
        );
      });

      _bot!.onMessage((ctx) async {
        final text = ctx.message?.text;
        if (text == null || text.startsWith('/')) return;

        if (_aiModel == null) {
          if (ctx.message?.chat.type == ChatType.private) {
            await ctx.reply(
              "I'm sorry, my AI brain is currently being configured. Please contact support!",
            );
          }
          return;
        }

        try {
          final response = await _aiModel!.generateContent([
            Content.text(text),
          ]);
          final replyText =
              response.text ?? 'Sorry, I could not process your request.';
          await ctx.reply(replyText);
        } catch (e) {
          debugPrint('❌ Gemini AI Error: $e');
          if (ctx.message?.chat.type == ChatType.private) {
            final errorStr = e.toString().toLowerCase();
            if (errorStr.contains("permission") ||
                errorStr.contains("not enabled")) {
              await ctx.reply(
                '⚠️ AI Configuration Error: Enable the Gemini Developer API for this Firebase project in the Firebase console (Build > AI Logic).',
              );
            } else if (errorStr.contains("location is not supported") ||
                errorStr.contains("user location")) {
              await ctx.reply(
                '⚠️ AI Region Error: Gemini is not supported in your current region.',
              );
            } else if (errorStr.contains("not found") ||
                errorStr.contains("retired")) {
              await ctx.reply(
                '⚠️ AI Configuration Error: The Gemini model name is invalid or has been retired. Please update BotManager._geminiModelName.',
              );
            } else {
              await ctx.reply(
                'An error occurred while connecting to AI. Please try again later.',
              );
            }
          }
        }
      });

      await _bot!.start();
      _isRunning = true;
      debugPrint("🚀 Telegram Bot started successfully");
    } catch (e) {
      debugPrint("❌ Error starting Telegram bot: $e");
      _isRunning = false;
    }
  }

  Future<void> sendOrderNotification(OrderModel order) async {
    if (_token.isEmpty) {
      debugPrint("❌ Cannot send notification: TELEGRAM_BOT_TOKEN is empty.");
      return;
    }

    _adminChatId ??= await FirestoreService().getTelegramAdminChatId();

    if (_adminChatId == null) {
      debugPrint("⚠️ No Telegram Admin Chat ID registered.");
      return;
    }

    try {
      final messageBot = _bot ?? Bot(_token);

      final buffer = StringBuffer();
      buffer.writeln("🔔 *New Order Received!*");
      buffer.writeln("━━━━━━━━━━━━━━━");
      buffer.writeln("🆔 *Order ID:* `${order.id ?? 'Pending'}`");
      buffer.writeln("💰 *Total:* \$${order.totalAmount.toStringAsFixed(2)}");
      buffer.writeln("💳 *Payment:* ${order.paymentMethod}");
      buffer.writeln("🚚 *Delivery:* ${order.deliveryMethod}");
      buffer.writeln("📍 *Address:* ${order.address['address'] ?? 'N/A'}");
      buffer.writeln("━━━━━━━━━━━━━━━");
      buffer.writeln("📦 *Items:*");
      for (var item in order.items) {
        final title = item['title'] ?? item['name'] ?? 'Unknown Item';
        final qty = item['quantity'] ?? item['qty'] ?? 1;
        final price = item['price'] ?? 0.0;
        buffer.writeln(
          "• $title x$qty (\$${(price * qty).toStringAsFixed(2)})",
        );
      }
      buffer.writeln("━━━━━━━━━━━━━━━");
      buffer.writeln("📅 *Date:* ${order.createdAt.toString().split('.')[0]}");
      await messageBot.api.sendMessage(
        ChatID(_adminChatId!),
        buffer.toString(),
        parseMode: ParseMode.markdown,
      );

      debugPrint("✅ Telegram notification sent to $_adminChatId");
    } catch (e) {
      debugPrint("❌ Error sending Telegram notification: $e");
    }
  }

  Future<String> getAiResponse(String message) async {
    try {
      if (_aiModel == null) await init();
      if (_aiModel == null)
        // ignore: curly_braces_in_flow_control_structures
        return "I'm sorry, I'm having trouble connecting to my AI brain right now.";
      final response = await _aiModel!.generateContent([Content.text(message)]);
      return response.text ?? "I'm sorry, I couldn't understand that.";
    } catch (e) {
      debugPrint("❌ Gemini AI Response Error: $e");
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains("permission") || errorStr.contains("not enabled")) {
        return "⚠️ AI Configuration Error: Enable the Gemini Developer API for this Firebase project in the Firebase console.";
      } else if (errorStr.contains("location is not supported") ||
          errorStr.contains("user location")) {
        return "⚠️ AI Region Error: Gemini is not supported in your current region.";
      } else if (errorStr.contains("not found") ||
          errorStr.contains("retired")) {
        return "⚠️ AI Configuration Error: The Gemini model name is invalid or has been retired.";
      }
      return "An error occurred while connecting to AI. Please check your internet and try again.";
    }
  }
}
