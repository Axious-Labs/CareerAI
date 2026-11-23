import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/interview/presentation/interview_prep_screen.dart';

void main() {
  group('InterviewPrepScreen Widget Tests', () {
    testWidgets('InterviewPrepScreen renders role chips and question navigation', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: InterviewPrepScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('AI Mock Interview Prep'), findsOneWidget);
      expect(find.text('Target Domain & Role'), findsOneWidget);
      expect(find.text('AI/ML Engineer'), findsWidgets);
      expect(find.text('Mobile Flutter Developer'), findsOneWidget);
    });

    testWidgets('InterviewPrepScreen displays answer input box and evaluate action', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: InterviewPrepScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'Using isolates and compute for offloading heavy computation.');
      await tester.pump();

      expect(find.text('Evaluate with Axious AI'), findsOneWidget);
    });
  });
}

