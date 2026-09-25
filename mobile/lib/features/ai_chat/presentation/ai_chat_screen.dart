import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello Alex! I am your CareerAI Assistant by Axious Labs. How can I help you accelerate your journey toward becoming an AI/ML Engineer today?",
      isUser: false,
      timestamp: "10:00 AM",
    ),
  ];

  final List<String> _suggestedPrompts = [
    "What should I learn to become an AI Engineer?",
    "How can I bridge my LangGraph skill gap?",
    "Review my resume for early-career AI roles",
  ];

  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: "Now",
      ));
      _isTyping = true;
    });

    _messageController.clear();

    // Simulate response from Node.js backend / GenAI service
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: "Based on your current profile (strong Python at 80% and Flutter at 70%), prioritize mastering LLM architectures, fine-tuning with LoRA, and agentic workflows using LangGraph.",
            isUser: false,
            timestamp: "Now",
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accent,
              child: Icon(Icons.smart_toy, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('CareerAI Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Powered by Axious Labs GenAI', style: TextStyle(fontSize: 11, color: AppColors.accentLight)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Suggested prompt pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _suggestedPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    onPressed: () => _sendMessage(prompt),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Message history
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? AppColors.accent : AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                        bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                      ),
                      border: msg.isUser ? null : Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: msg.isUser ? AppColors.primary : AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg.timestamp,
                            style: TextStyle(
                              color: msg.isUser ? AppColors.primary.withOpacity(0.6) : AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: const [
                  SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                  ),
                  SizedBox(width: 8),
                  Text('CareerAI Assistant is thinking...', style: AppTextStyles.bodySmall),
                ],
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Ask career advice, skill gap, or interview prep...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.accent),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
