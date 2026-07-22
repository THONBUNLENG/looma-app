import 'package:flutter/material.dart';
import 'package:shopping_app/src/widget/text_widget.dart';
import 'bot_manager.dart';

class FAQAdminPage extends StatefulWidget {
  const FAQAdminPage({super.key});

  @override
  State<FAQAdminPage> createState() => _FAQAdminPageState();
}

class _FAQAdminPageState extends State<FAQAdminPage> {
  bool _isBotRunning = BotManager().isRunning;
  String _statusMessage = BotManager().isRunning
      ? "Bot is active"
      : "Bot is inactive";

  void _toggleBot() async {
    try {
      if (_isBotRunning) {
        await BotManager().stop();
        setState(() {
          _isBotRunning = false;
          _statusMessage = "Bot stopped";
        });
      } else {
        await BotManager().start();
        setState(() {
          _isBotRunning = true;
          _statusMessage = "Bot started successfully";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          "Telegram FAQ Admin",
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(isDark),
            const SizedBox(height: 30),
            TextWidget(
              "Bot Controls",
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _toggleBot,
              icon: Icon(_isBotRunning ? Icons.stop : Icons.play_arrow),
              label: TextWidget(_isBotRunning ? "Stop Bot" : "Start Bot"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBotRunning ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 20),
            TextWidget("Bot Info", fontSize: 18, fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            _infoRow("Bot Name", "@LoomaFAQ_bot"),
            _infoRow("Status", _isBotRunning ? "Running" : "Idle"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _isBotRunning ? Colors.green : Colors.grey),
      ),
      child: Column(
        children: [
          Icon(
            _isBotRunning ? Icons.check_circle : Icons.pause_circle_filled,
            color: _isBotRunning ? Colors.green : Colors.grey,
            size: 50,
          ),
          const SizedBox(height: 10),
          TextWidget(
            _statusMessage,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isBotRunning ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(label, color: Colors.grey),
          TextWidget(value, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
