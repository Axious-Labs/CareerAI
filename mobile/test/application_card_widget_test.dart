import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/applications/presentation/widgets/application_card.dart';

void main() {
  group('ApplicationCard Widget Tests', () {
    testWidgets('ApplicationCard renders application details and interview rounds', (WidgetTester tester) async {
      final testApp = JobApplication(
        id: 'app_test_widget',
        jobId: 'job_01',
        title: 'Senior Flutter Developer',
        company: 'Axious Labs',
        location: 'Remote',
        status: ApplicationStatus.interviewing,
        appliedDate: '4 days ago',
        notes: 'Passed initial portfolio screen',
        rounds: const [
          InterviewRoundInfo(
            roundName: 'System Architecture Round',
            scheduledDate: 'Oct 12, 2026',
            interviewer: 'Axious Team Lead',
            feedback: 'Solid widget tree performance understanding',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApplicationCard(
              application: testApp,
            ),
          ),
        ),
      );

      expect(find.text('Senior Flutter Developer'), findsOneWidget);
      expect(find.text('Axious Labs • Remote'), findsOneWidget);
      expect(find.text('INTERVIEWING'), findsOneWidget);
      expect(find.text('Passed initial portfolio screen'), findsOneWidget);
      expect(find.text('System Architecture Round'), findsOneWidget);
      expect(find.text('Applied 4 days ago'), findsOneWidget);
    });
  });
}
