import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
      sessionId: 'sess_test_1',
      targetRole: targetRole,
      difficulty: difficulty,
      totalQuestions: 1,
      instructions: 'Instructions',
      questions: [
        InterviewQuestion(
          id: 'q_test_1',
          category: 'Architecture',
          question: 'How do you optimize LLMs?',
          expectedKeyPoints: const ['Quantization'],
          sampleAnswerGuide: 'Guide',
        ),
      ],
    );
  }
}

void main() {
  group('InterviewPrepScreen Widget Tests', () {
    testWidgets('InterviewPrepScreen renders role chips and question navigation', (tester) async {
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
      expect(find.text('AI/ML Engineer'), findsWidgets);
      expect(find.text('Mobile Flutter Developer'), findsOneWidget);
    });

    testWidgets('InterviewPrepScreen displays answer input box and evaluate action', (tester) async {
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

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'Using isolates and compute for offloading heavy computation.');
      await tester.pump();

      expect(find.text('Evaluate with Axious AI'), findsOneWidget);
    });
  });
}
