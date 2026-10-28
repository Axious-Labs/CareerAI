import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  group('DashboardScreen Widget Unit Tests', () {
    testWidgets('DashboardScreen renders app branding, greetings, and career metrics', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pump();

      // Header branding
      expect(find.text('CareerAI'), findsOneWidget);
      expect(find.text('Axious Labs'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);

      // Target Role & Readiness
      expect(find.text('Target Role'), findsOneWidget);
      expect(find.text('AI/ML Engineer'), findsOneWidget);
      expect(find.text('Career Readiness'), findsOneWidget);
      expect(find.text('68%'), findsOneWidget);

      // Skills section
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Python'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('GenAI'), findsOneWidget);
      expect(find.text('ML'), findsOneWidget);

      // Career Plan section
      expect(find.text("Today's Career Plan"), findsOneWidget);
      expect(find.text('Complete Transformers lesson'), findsOneWidget);
      expect(find.text('Solve 2 DSA problems'), findsOneWidget);
      expect(find.text('Apply to 3 relevant jobs'), findsOneWidget);

      // Quick Actions
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Analyze Resume'), findsOneWidget);
      expect(find.text('Skill Gap'), findsOneWidget);
      expect(find.text('Find Jobs'), findsOneWidget);
      expect(find.text('AI Career Assistant'), findsOneWidget);
      expect(find.text('Mock Interview'), findsOneWidget);
    });

    testWidgets('DashboardScreen renders action buttons and icons properly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byIcon(Icons.upload_file), findsOneWidget);
      expect(find.byIcon(Icons.compare_arrows), findsOneWidget);
      expect(find.byIcon(Icons.work_outline), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });
  });
}

