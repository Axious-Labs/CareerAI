import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/applications/presentation/applications_screen.dart';

void main() {
  group('ApplicationsScreen Widget Tests', () {
    testWidgets('ApplicationsScreen renders AppBar, filter chips, and application cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ApplicationsScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Application Tracker'), findsOneWidget);
      expect(find.text('All Applications'), findsOneWidget);
      expect(find.text('APPLIED'), findsOneWidget);
      expect(find.text('UNDERREVIEW'), findsOneWidget);
      expect(find.text('INTERVIEWING'), findsOneWidget);
    });

    testWidgets('ApplicationsScreen filters by status upon chip selection', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ApplicationsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Tap on OFFER chip (default sample has no OFFER status)
      final offerChipFinder = find.widgetWithText(ChoiceChip, 'OFFER');
      expect(offerChipFinder, findsOneWidget);

      await tester.tap(offerChipFinder);
      await tester.pump();

      expect(find.text('No applications matching this filter'), findsOneWidget);

      // Tap back on All Applications
      await tester.tap(find.text('All Applications'));
      await tester.pump();

      expect(find.text('No applications matching this filter'), findsNothing);
    });
  });
}
