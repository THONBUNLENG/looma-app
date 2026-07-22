import 'package:televerse/televerse.dart';

class BotManager {
  static final BotManager _instance = BotManager._internal();
  factory BotManager() => _instance;
  BotManager._internal();

  Bot? _bot;
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  final String _token = "8752422469:AAEaAtUqs3zJmu-McbPGvxYofBeKwSc11ZI";

  Future<void> start() async {
    if (_isRunning) return;

    try {
      _bot = Bot(_token);
      
      _bot!.command('start', (ctx) async {
        await ctx.reply("Welcome to Looma FAQ Admin Bot! \n\nI am here to help you manage FAQs. Use /help to see available commands.");
      });

      _bot!.command('help', (ctx) async {
        await ctx.reply("Available commands:\n/start - Start the bot\n/help - Show this help message\n/status - Check bot status");
      });

      _bot!.command('status', (ctx) async {
        await ctx.reply("Bot is running and operational.");
      });

      // Handle generic messages
      _bot!.onMessage((ctx) async {
        if (ctx.message?.text?.startsWith('/') ?? false) return;
        await ctx.reply("You said: ${ctx.message?.text}. \nI'm still learning how to handle FAQs!");
      });

      await _bot!.start();
      _isRunning = true;
      print("Telegram Bot started successfully.");
    } catch (e) {
      _isRunning = false;
      print("Failed to start Telegram Bot: $e");
      rethrow;
    }
  }

  Future<void> stop() async {
    if (!_isRunning) return;
    
    try {
      _isRunning = false;
      _bot = null;
      print("Telegram Bot stopped.");
    } catch (e) {
      print("Error stopping Telegram Bot: $e");
    }
  }
}
