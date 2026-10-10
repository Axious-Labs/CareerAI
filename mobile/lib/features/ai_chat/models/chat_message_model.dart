enum MessageSender {
  user,
  ai,
  system,
}

class ChatMessageData {
  final String id;
  final String text;
  final MessageSender sender;
  final String timestamp;
  final List<String> quickReplies;
  final String? domainCategory;

  const ChatMessageData({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.quickReplies = const [],
    this.domainCategory,
  });

  bool get isUser => sender == MessageSender.user;

  factory ChatMessageData.fromJson(Map<String, dynamic> json) {
    final senderStr = (json['sender'] ?? '').toString().toLowerCase();
    MessageSender sender = MessageSender.ai;
    if (senderStr == 'user') sender = MessageSender.user;
    if (senderStr == 'system') sender = MessageSender.system;

    return ChatMessageData(
      id: json['id'] as String? ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: json['text'] as String? ?? '',
      sender: sender,
      timestamp: json['timestamp'] as String? ?? 'Now',
      quickReplies: (json['quickReplies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      domainCategory: json['domainCategory'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender': sender.name,
      'timestamp': timestamp,
      'quickReplies': quickReplies,
      if (domainCategory != null) 'domainCategory': domainCategory,
    };
  }
}
