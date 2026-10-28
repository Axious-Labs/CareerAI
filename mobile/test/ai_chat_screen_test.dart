import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/ai_chat/presentation/ai_chat_screen.dart';

void main() {
  group('AiChatScreen Widget Unit Tests', () {
    testWidgets('AiChatScreen renders appbar branding, message list, and input bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiChatScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('CareerAI Assistant'), findsOneWidget);
      expect(find.text('Powered by Axious Labs LLM'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.send_rounded), findsOneWidget);
      expect(find.textContaining("I'm your CareerAI assistant"), findsOneWidget);
    });

    testWidgets('AiChatScreen sends message and appends user bubble', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AiChatScreen(),
          ),
        ),
      );

      await tester.pump();

      final inputFinder = find.byType(TextField);
      expect(inputFinder, findsOneWidget);

      await tester.enterText(inputFinder, 'Tell me about Flutter state management');
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      expect(find.text('Tell me about Flutter state management'), findsOneWidget);
    });
  });
}

