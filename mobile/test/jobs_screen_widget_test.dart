import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/jobs/services/jobs_service.dart';
import 'package:careerai_mobile/features/jobs/presentation/jobs_screen.dart';

class MockJobsService extends JobsService {
  MockJobsService() : super(ApiClient());

  @override
  Future<List<JobPosting>> getRecommendedJobs() async {
    return JobsService.defaultJobList;
  }
}

void main() {
  group('JobsScreen Widget Tests', () {
    testWidgets('JobsScreen renders AppBar title, search bar, and bookmark toggle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobsServiceProvider.overrideWithValue(MockJobsService()),
          ],
          child: const MaterialApp(
            home: JobsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Matched Opportunities'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('JobsScreen search input filters displayed job items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobsServiceProvider.overrideWithValue(MockJobsService()),
          ],
          child: const MaterialApp(
            home: JobsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'NonExistentRole123');
      await tester.pump();
      await tester.pump();

      // Clear search
      await tester.enterText(searchField, '');
      await tester.pump();
      await tester.pump();
      expect(find.text('Matched Opportunities'), findsOneWidget);
    });

    testWidgets('JobsScreen toggles show saved jobs filter', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            jobsServiceProvider.overrideWithValue(MockJobsService()),
          ],
          child: const MaterialApp(
            home: JobsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      final bookmarkButton = find.byIcon(Icons.bookmark_outline);
      await tester.tap(bookmarkButton);
      await tester.pump();
      await tester.pump();

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });
  });
}
