import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/interview/models/interview_model.dart';
import 'package:careerai_mobile/features/interview/services/interview_service.dart';
import 'package:careerai_mobile/features/interview/presentation/interview_prep_screen.dart';

class MockInterviewService extends InterviewService {
  MockInterviewService() : super(ApiClient());

  @override
  Future<InterviewSessionData> startInterview({
    String targetRole = 'AI/ML Engineer',
    String difficulty = 'MID',
    String? skillFocus,
    int questionCount = 4,
  }) async {
    return InterviewSessionData(
      sessionId: 'test_session_001',
      targetRole: targetRole,
      difficulty: difficulty,
      totalQuestions: 1,
      instructions: 'Test Instructions',
      questions: [
        InterviewQuestion(
          id: 'q_test_1',
          category: 'System Architecture',
          question: 'How do you optimize LLM latency in production?',
          expectedKeyPoints: ['Prompt caching', 'Quantization', 'Streaming'],
          sampleAnswerGuide: 'Explain caching and speculative decoding',
        ),
      ],
    );
  }
}

void main() {
  group('Interview Preparation Models & Widget Tests', () {
    test('InterviewQuestion serialization and deserialization', () {
      final json = {
        'id': 'q_test_1',
        'category': 'Architecture',
        'question': 'How does vector search scale?',
        'expectedKeyPoints': ['HNSW graph', 'IVF indexing'],
        'sampleAnswerGuide': 'Explain memory vs latency tradeoffs',
      };

      final question = InterviewQuestion.fromJson(json);
      expect(question.id, 'q_test_1');
      expect(question.category, 'Architecture');
      expect(question.question, 'How does vector search scale?');
      expect(question.expectedKeyPoints.length, 2);
    });

    test('AnswerEvaluationResult model score computation', () {
      final json = {
        'sessionId': 'sess_1',
        'questionId': 'q_test_1',
        'score': 90,
        'feedback': 'Great technical articulation',
        'strengths': ['Solid terminology'],
        'areasForImprovement': ['Mention observability'],
        'modelAnswerTip': 'Use STAR methodology',
      };

      final result = AnswerEvaluationResult.fromJson(json);
      expect(result.score, 90);
      expect(result.strengths.first, 'Solid terminology');
    });

    testWidgets('InterviewPrepScreen renders with AppBar and Role Chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            interviewServiceProvider.overrideWithValue(MockInterviewService()),
          ],
          child: const MaterialApp(
            home: InterviewPrepScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('AI Mock Interview Prep'), findsOneWidget);
      expect(find.text('Target Domain & Role'), findsOneWidget);
      expect(find.text('How do you optimize LLM latency in production?'), findsOneWidget);
    });
  });
}
