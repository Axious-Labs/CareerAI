import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/chat_message_model.dart';

final aiChatServiceProvider = Provider<AiChatService>((ref) {
  return AiChatService(ApiClient());
});

class ChatStateNotifier extends StateNotifier<List<ChatMessageData>> {
  final AiChatService _service;

  ChatStateNotifier(this._service) : super(_service.getInitialMessages());

  Future<void> sendUserMessage(String userText) async {
    final userMsg = ChatMessageData(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      text: userText,
      sender: MessageSender.user,
      timestamp: 'Just now',
    );
    state = [...state, userMsg];

    final response = await _service.generateResponse(userText);
    state = [...state, response];
  }

  void clearConversation() {
    state = _service.getInitialMessages();
  }
}

final chatStateProvider =
    StateNotifierProvider<ChatStateNotifier, List<ChatMessageData>>((ref) {
  final service = ref.watch(aiChatServiceProvider);
  return ChatStateNotifier(service);
});

class AiChatService {
  final ApiClient apiClient;

  AiChatService(this.apiClient);

  List<ChatMessageData> getInitialMessages() {
    return const [
      ChatMessageData(
        id: 'init_1',
        text:
            'Hello Alex! I am your CareerAI Mentor by Axious Labs. I can analyze your resume ATS match, conduct mock interviews, or tailor learning roadmaps. What would you like to explore?',
        sender: MessageSender.ai,
        timestamp: '10:00 AM',
        quickReplies: [
          'Review my resume for AI Engineer roles',
          'How do I bridge the LangGraph skill gap?',
          'Prepare for upcoming technical interview',
        ],
        domainCategory: 'General Orientation',
      ),
    ];
  }

  Future<ChatMessageData> generateResponse(String userPrompt) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.chat,
        data: {'message': userPrompt, 'context': 'career_guidance'},
      );
      if (response.data != null && response.data['data'] != null) {
        return ChatMessageData.fromJson(
            response.data['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Fallback
    }

    final lower = userPrompt.toLowerCase();
    String replyText =
        'That is an insightful career question. Building practical open-source artifacts, mastering distributed workflows, and writing clean automated test suites are the highest-signal indicators for engineering hiring managers.';
    List<String> replies = const [
      'Show me available job matches',
      'What are the highest-paying skills?',
    ];

    if (lower.contains('resume')) {
      replyText =
          'Your resume currently has an ATS score of 84%. To reach 95%+, emphasize metrics: mention query throughput, test coverage, and specific LangGraph agent graph implementations.';
      replies = const [
        'How do I add quantified metrics?',
        'Analyze my skill match percentage',
      ];
    } else if (lower.contains('langgraph') || lower.contains('skill')) {
      replyText =
          'LangGraph is high-priority for AI engineering roles because production agents need cyclic loops, human-in-the-loop checkpoints, and state persistence. Check your personalized roadmap in the Skills tab!';
      replies = const [
        'Open Skills Roadmap',
        'Start Mock Interview on LangGraph',
      ];
    } else if (lower.contains('interview')) {
      replyText =
          'I recommend running our AI Mock Interview Prep! You can practice questions on LLM latency optimization, pgvector search, and system architecture with automated STAR scoring.';
      replies = const [
        'Start an AI Mock Interview now',
        'Review past interview feedback',
      ];
    }

    return ChatMessageData(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      text: replyText,
      sender: MessageSender.ai,
      timestamp: 'Now',
      quickReplies: replies,
      domainCategory: 'Career Mentorship',
    );
  }
}
