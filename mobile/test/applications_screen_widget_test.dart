import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/applications/services/application_service.dart';
import 'package:careerai_mobile/features/applications/presentation/applications_screen.dart';

class MockApplicationService extends ApplicationService {
  MockApplicationService() : super(ApiClient());

  @override
  Future<List<JobApplication>> getApplications() async {
    return ApplicationService.defaultApplications;
  }
}

void main() {
  group('ApplicationsScreen Widget Tests', () {
    testWidgets('ApplicationsScreen renders AppBar, filter chips, and application cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            applicationServiceProvider.overrideWithValue(MockApplicationService()),
          ],
          child: const MaterialApp(
            home: ApplicationsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Application Tracker'), findsOneWidget);
      expect(find.text('All Applications'), findsOneWidget);
      expect(find.text('APPLIED'), findsOneWidget);
      expect(find.text('UNDERREVIEW'), findsOneWidget);
      expect(find.text('INTERVIEWING'), findsOneWidget);
    });

    testWidgets('ApplicationsScreen filters by status upon chip selection', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            applicationServiceProvider.overrideWithValue(MockApplicationService()),
          ],
          child: const MaterialApp(
            home: ApplicationsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Tap on OFFER chip (default sample has no OFFER status)
      final offerChipFinder = find.widgetWithText(ChoiceChip, 'OFFER');
      expect(offerChipFinder, findsOneWidget);

      await tester.tap(offerChipFinder);
      await tester.pump();
      await tester.pump();

      expect(find.text('No applications matching this filter'), findsOneWidget);

      // Tap back on All Applications
      await tester.tap(find.text('All Applications'));
      await tester.pump();
      await tester.pump();

      expect(find.text('No applications matching this filter'), findsNothing);
    });
  });
}
