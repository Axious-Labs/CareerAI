import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/jobs/services/jobs_service.dart';

void main() {
  group('Job Models & Filtering Tests', () {
    test('JobPosting serialization and enum mappings', () {
      final json = {
        'id': 'job_test_1',
        'title': 'Senior Flutter Engineer',
        'company': 'Axious Labs',
        'location': 'New York, NY',
        'workplaceType': 'remote',
        'experienceLevel': 'senior',
        'salaryRange': '\$150k - \$180k',
        'matchScore': 95,
        'description': 'Lead mobile app development with high performance.',
        'requirements': ['5+ years Flutter', 'State management proficiency'],
        'tags': ['Flutter', 'Dart', 'Riverpod'],
        'postedDate': '2026-06-01T00:00:00.000Z',
        'isSaved': true,
        'isApplied': false,
      };

      final job = JobPosting.fromJson(json);
      expect(job.id, 'job_test_1');
      expect(job.workplaceType, WorkplaceType.remote);
      expect(job.workplaceLabel, 'Remote');
      expect(job.experienceLevel, ExperienceLevel.senior);
      expect(job.experienceLabel, 'Senior');
      expect(job.isSaved, isTrue);
      expect(job.isApplied, isFalse);
    });

    test('JobPosting copyWith updates state immutably', () {
      final job = JobPosting(
        id: 'job_1',
        title: 'AI Dev',
        company: 'Axious',
        location: 'Remote',
        workplaceType: WorkplaceType.remote,
        experienceLevel: ExperienceLevel.entry,
        salaryRange: '\$100k',
        matchScore: 80,
        description: 'Test',
        requirements: const [],
        tags: const ['AI'],
        postedDate: DateTime.now(),
      );

      final savedJob = job.copyWith(isSaved: true);
      expect(savedJob.isSaved, isTrue);
      expect(job.isSaved, isFalse);

      final appliedJob = savedJob.copyWith(isApplied: true);
      expect(appliedJob.isApplied, isTrue);
    });

    test('JobFilterState detects active filter predicates correctly', () {
      const emptyFilter = JobFilterState();
      expect(emptyFilter.hasActiveFilters, isFalse);

      final queryFilter = emptyFilter.copyWith(searchQuery: 'python');
      expect(queryFilter.hasActiveFilters, isTrue);

      final workplaceFilter = emptyFilter.copyWith(workplaceType: WorkplaceType.remote);
      expect(workplaceFilter.hasActiveFilters, isTrue);

      final scoreFilter = emptyFilter.copyWith(minMatchScore: 80);
      expect(scoreFilter.hasActiveFilters, isTrue);
    });
  });

  group('JobsListNotifier State Management Tests', () {
    test('Toggle save and mark applied state transitions', () {
      final service = JobsService(ApiClient());
      final notifier = JobsListNotifier(service);

      final initialJobs = JobsService.defaultJobList;
      expect(initialJobs.isNotEmpty, isTrue);

      final firstId = initialJobs.first.id;
      notifier.toggleSaveJob(firstId);

      final updatedJobs = notifier.state;
      final savedJob = updatedJobs.firstWhere((j) => j.id == firstId);
      expect(savedJob.isSaved, isTrue);

      notifier.markApplied(firstId);
      final appliedJob = notifier.state.firstWhere((j) => j.id == firstId);
      expect(appliedJob.isApplied, isTrue);
    });
  });
}
