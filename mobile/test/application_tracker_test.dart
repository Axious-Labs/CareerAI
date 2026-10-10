import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/applications/services/application_service.dart';

void main() {
  group('Job Applications Model & State Tests', () {
    test('JobApplication serialization and interview rounds mapping', () {
      final json = {
        'id': 'app_test_1',
        'jobId': 'job_01',
        'title': 'AI Solutions Architect',
        'company': 'Axious Labs',
        'location': 'Remote',
        'status': 'interviewing',
        'appliedDate': '5 days ago',
        'notes': 'Completed round 1 with distinction',
        'rounds': [
          {
            'roundName': 'Round 1: System Design',
            'scheduledDate': 'Oct 10',
            'interviewer': 'Lead Engineer',
            'feedback': 'Great architectural trade-off discussion',
          }
        ],
      };

      final app = JobApplication.fromJson(json);
      expect(app.title, 'AI Solutions Architect');
      expect(app.status, ApplicationStatus.interviewing);
      expect(app.statusDisplay, 'INTERVIEWING');
      expect(app.rounds.length, 1);
      expect(app.rounds.first.roundName, 'Round 1: System Design');
      expect(app.rounds.first.feedback, contains('architectural'));
    });

    test('ApplicationsNotifier updates status and internal candidate notes', () {
      final service = ApplicationService(ApiClient());
      final notifier = ApplicationsNotifier(service);

      final initialApps = ApplicationService.defaultApplications;
      expect(initialApps.isNotEmpty, isTrue);

      final firstId = initialApps.first.id;
      notifier.updateApplicationStatus(firstId, ApplicationStatus.offer);

      final updatedApp = notifier.state.firstWhere((a) => a.id == firstId);
      expect(updatedApp.status, ApplicationStatus.offer);
      expect(updatedApp.statusDisplay, 'OFFER');

      const newNote = 'Offer contract under review with hiring director';
      notifier.updateApplicationNotes(firstId, newNote);
      final noteApp = notifier.state.firstWhere((a) => a.id == firstId);
      expect(noteApp.notes, newNote);
    });
  });
}
