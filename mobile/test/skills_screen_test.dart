import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/skills/presentation/skills_screen.dart';

void main() {
  group('SkillsScreen Widget Unit Tests', () {
    testWidgets('SkillsScreen renders skill competencies, target role, and tabs', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SkillsScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Skills & Competencies'), findsOneWidget);
      expect(find.text('Target Role: AI/ML Engineer'), findsOneWidget);
      expect(find.text('My Skills'), findsOneWidget);
      expect(find.text('Skill Gap Analysis'), findsOneWidget);
      expect(find.text('Assessed Competencies'), findsOneWidget);
      expect(find.text('Python & NumPy'), findsOneWidget);
      expect(find.text('Personalized Learning Roadmap'), findsOneWidget);
    });

    testWidgets('SkillsScreen switches between My Skills and Skill Gap Analysis view', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SkillsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Tap on Skill Gap Analysis button
      final gapButton = find.text('Skill Gap Analysis');
      await tester.tap(gapButton);
      await tester.pump();

      expect(find.text('Target Role Gap Matrix'), findsOneWidget);
      expect(find.text('LangGraph & Multi-Agent Workflows'), findsOneWidget);

      // Tap back on My Skills
      final mySkillsButton = find.text('My Skills');
      await tester.tap(mySkillsButton);
      await tester.pump();

      expect(find.text('Assessed Competencies'), findsOneWidget);
    });
  });
}

