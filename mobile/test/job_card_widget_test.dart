import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/jobs/presentation/widgets/job_card.dart';

void main() {
  group('JobCard Widget Tests', () {
    testWidgets('JobCard displays job data and handles save/apply interactions', (WidgetTester tester) async {
      bool applied = false;
      bool saveToggled = false;

      final testJob = JobPosting(
        id: 'job_widget_test',
        title: 'Lead AI Engineer',
        company: 'Axious Labs',
        location: 'San Francisco, CA',
        workplaceType: WorkplaceType.remote,
        experienceLevel: ExperienceLevel.senior,
        salaryRange: '\$160k - \$190k',
        matchScore: 94,
        description: 'Design next-generation agent architectures and graph execution engines.',
        requirements: const ['Extensive LangGraph experience'],
        tags: const ['Python', 'LangGraph', 'Flutter'],
        postedDate: DateTime.now(),
        isSaved: false,
        isApplied: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JobCard(
              job: testJob,
              onApply: () {
                applied = true;
              },
              onToggleSave: () {
                saveToggled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Lead AI Engineer'), findsOneWidget);
      expect(find.text('Axious Labs • San Francisco, CA'), findsOneWidget);
      expect(find.text('94% Match'), findsOneWidget);
      expect(find.text('\$160k - \$190k'), findsOneWidget);
      expect(find.text('Apply Now'), findsOneWidget);

      await tester.tap(find.text('Apply Now'));
      await tester.pump();
      expect(applied, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();
      expect(saveToggled, isTrue);
    });
  });
}
