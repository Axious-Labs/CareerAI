import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/resume/presentation/widgets/resume_score_card.dart';
import 'package:careerai_mobile/features/resume/presentation/widgets/resume_skill_chips.dart';

void main() {
  group('Resume Widget Tests', () {
    testWidgets('ResumeScoreCard renders score bars and match badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResumeScoreCard(
              atsScore: 88,
              keywordMatch: 82,
              readability: 94,
            ),
          ),
        ),
      );

      expect(find.text('ATS Resume Compatibility'), findsOneWidget);
      expect(find.text('88% Match'), findsOneWidget);
      expect(find.text('Overall ATS Score'), findsOneWidget);
      expect(find.text('Keyword Match (Target Role)'), findsOneWidget);
      expect(find.text('Structure & Readability'), findsOneWidget);
    });

    testWidgets('ResumeSkillChips renders skill chips and handles user tap', (WidgetTester tester) async {
      String? tappedSkill;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResumeSkillChips(
              skills: const ['Flutter', 'Python', 'Docker'],
              onSkillTapped: (skill) {
                tappedSkill = skill;
              },
            ),
          ),
        ),
      );

      expect(find.text('Extracted Technical Skills'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Python'), findsOneWidget);
      expect(find.text('Docker'), findsOneWidget);

      await tester.tap(find.text('Flutter'));
      await tester.pump();

      expect(tappedSkill, 'Flutter');
    });
  });
}
