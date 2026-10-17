import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/notifications/models/notification_model.dart';
import 'package:careerai_mobile/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:careerai_mobile/features/notifications/presentation/notifications_screen.dart';

void main() {
  group('Notification Widgets Unit Tests', () {
    testWidgets('NotificationTile renders title, message, badge and handles markAsRead', (tester) async {
      bool markedRead = false;
      bool dismissed = false;

      final testItem = NotificationItem(
        id: 'notif_tile_1',
        title: 'New High Match Job',
        message: 'Google is hiring Senior Flutter Engineers',
        type: NotificationType.jobAlert,
        createdAt: DateTime.now(),
        isRead: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotificationTile(
              item: testItem,
              onMarkAsRead: () {
                markedRead = true;
              },
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('New High Match Job'), findsOneWidget);
      expect(find.text('Google is hiring Senior Flutter Engineers'), findsOneWidget);
      expect(find.text('Job Match Alert'), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(markedRead, true);
      expect(dismissed, false);
    });

    testWidgets('NotificationsScreen renders inside ProviderScope with filters', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NotificationsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Career Alerts'), findsOneWidget);
      expect(find.text('All Alerts'), findsOneWidget);
      expect(find.text('Job Match Alert'), findsOneWidget);
    });
  });
}
