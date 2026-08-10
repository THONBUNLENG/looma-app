import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/constants/app_color.dart';
import 'package:shopping_app/constants/string_extension.dart';
import 'package:shopping_app/src/telegarm_bot/bot_manager.dart';
import 'package:shopping_app/src/widget/text_widget.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _rotationController;
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? quickText]) async {
    final text = quickText ?? _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    if (quickText == null) _controller.clear();

    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await BotManager().getAiResponse(text);

    if (mounted) {
      setState(() {
        _messages.add({'isUser': false, 'text': response});
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : AppColor.backgroundColor,
      appBar: AppBar(
        title: TextWidget(
          "AI Support".tr,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
            icon: Icon(
              Icons.delete_sweep_outlined,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty && !_isLoading
                  ? _buildWelcomeScreen(isDark)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      itemCount: _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _buildTypingIndicator(isDark);
                        }
                        final msg = _messages[index];
                        return _buildChatBubble(
                          msg['text'],
                          msg['isUser'] == true,
                          isDark,
                        );
                      },
                    ),
            ),
            if (!_isLoading) _buildQuickActions(),
            _buildInputArea(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser, bool isDark) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
              radius: 18,
              child: Lottie.asset(
                'assets/lottie/robot.json',
                width: 25,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.smart_toy_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.primaryColor
                    : (isDark ? Colors.grey[800] : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextWidget(
                text,
                color: isUser ? Colors.white : (isDark ? Colors.white : Colors.black87),
                fontSize: 14,
                lineHeight: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
            radius: 18,
            child: Lottie.asset('assets/lottie/user_robot.json', width: 25),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SizedBox(
              width: 30,
              height: 20,
              child: Lottie.asset(
                'assets/lottie/loading.json',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 25,
      ),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !_isLoading,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: _isLoading ? 'Thinking...'.tr : 'Ask me anything...'.tr,
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _isLoading ? null : () => _sendMessage(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isLoading ? Colors.grey : theme.primaryColor,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? RotationTransition(
                          key: const ValueKey('loading'),
                          turns: _rotationController,
                          child: const Icon(
                            Icons.hourglass_empty,
                            color: Colors.white,
                            size: 22,
                          ),
                        )
                      : const Icon(
                          key: ValueKey('send'),
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(bool isDark) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/robot.json', width: 250),
          const SizedBox(height: 20),
          TextWidget(
            "Hello! I am your Looma AI Assistant.".tr,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : theme.primaryColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextWidget(
              "Ask me about our business hours, delivery fees, or payment options.".tr,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);
    final List<Map<String, String>> actions = [
      {"label": "⏰ Hours".tr, "val": "What are your business hours?"},
      {"label": "🚚 Delivery".tr, "val": "How much is the delivery fee?"},
      {"label": "💳 Payment".tr, "val": "What are the payment options?"},
      {"label": "📦 Returns".tr, "val": "What is your return policy?"},
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: TextWidget(
                actions[index]["label"]!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () => _sendMessage(actions[index]["val"]),
            ),
          );
        },
      ),
    );
  }
}
