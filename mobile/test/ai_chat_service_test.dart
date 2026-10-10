import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/ai_chat/models/chat_message_model.dart';
import 'package:careerai_mobile/features/ai_chat/services/ai_chat_service.dart';

void main() {
  group('AI Chat Models & Service Tests', () {
    test('ChatMessageData serialization and sender determination', () {
      final userJson = {
        'id': 'msg_01',
        'text': 'How do I optimize RAG retrieval?',
        'sender': 'user',
        'timestamp': '10:15 AM',
      };

      final userMsg = ChatMessageData.fromJson(userJson);
      expect(userMsg.isUser, isTrue);
      expect(userMsg.sender, MessageSender.user);

      final aiJson = {
        'id': 'msg_02',
        'text': 'Use hybrid dense-sparse search and cross-encoder reranking.',
        'sender': 'ai',
        'timestamp': '10:16 AM',
        'quickReplies': ['Show code sample', 'Explain latency impact'],
      };

      final aiMsg = ChatMessageData.fromJson(aiJson);
      expect(aiMsg.isUser, isFalse);
      expect(aiMsg.sender, MessageSender.ai);
      expect(aiMsg.quickReplies.length, 2);
    });

    test('AiChatService generates contextual responses based on domain prompt', () async {
      final service = AiChatService(ApiClient());

      final resumeResponse = await service.generateResponse('Can you review my resume?');
      expect(resumeResponse.isUser, isFalse);
      expect(resumeResponse.text, contains('ATS score'));

      final langGraphResponse = await service.generateResponse('What is LangGraph?');
      expect(langGraphResponse.text, contains('LangGraph'));

      final interviewResponse = await service.generateResponse('Prepare for my interview');
      expect(interviewResponse.text, contains('Mock Interview'));
    });

    test('ChatStateNotifier appends user and AI messages in sequence', () async {
      final service = AiChatService(ApiClient());
      final notifier = ChatStateNotifier(service);

      final initialLength = notifier.state.length;
      await notifier.sendUserMessage('Tell me about AI engineer career paths');

      expect(notifier.state.length, initialLength + 2);
      expect(notifier.state.last.isUser, isFalse);

      notifier.clearConversation();
      expect(notifier.state.length, initialLength);
    });
  });
}
