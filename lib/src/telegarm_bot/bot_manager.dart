import 'package:televerse/televerse.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
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

  final String _token = "8752422469:AAEaAtUqs3zJmu-McbPGvxYofBeKwSc11ZI";
  
  // Gemini API Key
  final String _geminiApiKey = "AIzaSyAfJhU1ppprip-KUWGaCanGf6nr1VjdNJs";

  bool get isRunning => _isRunning;

  Future<void> init() async {
    _adminChatId = await FirestoreService().getTelegramAdminChatId();
    
    // Initialize Gemini AI
    if (_geminiApiKey != "YOUR_GEMINI_API_KEY") {
      _aiModel = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
        systemInstruction: Content.system(r'''
You are the customer support AI for Looma. 
Answer customer questions accurately and briefly using ONLY the information below:

Knowledge Base:
- Business Hours: Monday–Saturday, 8:00 AM – 6:00 PM.
- Payment Options: ABA PayWay, KHQR, Credit Card.
- Delivery Fee: $1.50 in Phnom Penh, $2.50 to provinces.
- Returns: Allowed within 7 days with a valid purchase receipt.
- App Support: You can get instant answers for common questions directly in the app's AI Support chat. For more complex issues, you can contact us via our Telegram group.

If a question cannot be answered from the list above, kindly instruct the user to contact human support in this group.
'''),
      );
    }
  }

  Future<void> start() async {
    if (_isRunning) return;

    try {
      await init();
      _bot = Bot(_token);

      // Register command - works in both private and groups
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

      // Handle AI Support
      _bot!.onMessage((ctx) async {
        final text = ctx.message?.text;
        if (text == null || text.startsWith('/')) return;

        if (_aiModel == null) {
          // Fallback if AI is not configured
          if (ctx.message?.chat.type == ChatType.private) {
            await ctx.reply("I'm sorry, my AI brain is currently being configured. Please contact support!");
          }
          return;
        }

        try {
          final response = await _aiModel!.generateContent([Content.text(text)]);
          final replyText = response.text ?? 'Sorry, I could not process your request.';
          await ctx.reply(replyText);
        } catch (e) {
          debugPrint('❌ Gemini AI Error: $e');
          if (ctx.message?.chat.type == ChatType.private) {
            // More helpful error for developers
            if (e.toString().contains("API key not valid")) {
              await ctx.reply('⚠️ AI Configuration Error: The API key is invalid. Please check your BotManager configuration.');
            } else if (e.toString().contains("User location is not supported")) {
              await ctx.reply('⚠️ AI Region Error: Gemini is not supported in your current region.');
            } else {
              await ctx.reply('An error occurred while connecting to AI. Please try again later.');
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
    // Refresh admin ID from Firestore if not set
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
        buffer.writeln("• $title x$qty (\$${(price * qty).toStringAsFixed(2)})");
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

  // Public method to get AI response for in-app chat
  Future<String> getAiResponse(String message) async {
    if (_aiModel == null) await init();
    if (_aiModel == null) return "I'm sorry, I'm having trouble connecting to my AI brain right now.";

    try {
      final response = await _aiModel!.generateContent([Content.text(message)]);
      return response.text ?? "I'm sorry, I couldn't understand that.";
    } catch (e) {
      debugPrint("❌ Gemini AI Response Error: $e");
      final errorStr = e.toString();
      if (errorStr.contains("API key not valid")) {
        return "⚠️ AI Configuration Error: The API key is invalid.";
      } else if (errorStr.contains("User location is not supported")) {
        return "⚠️ AI Region Error: Gemini is not supported in your current region.";
      }
      return "An error occurred while connecting to AI. Please try again later.";
    }
  }
}
