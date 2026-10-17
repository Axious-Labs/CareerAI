import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/notifications/models/notification_model.dart';
import 'package:careerai_mobile/features/notifications/services/notification_service.dart';

void main() {
  group('Notification Models & Enums Tests', () {
    test('NotificationType fromString correctly handles variations and default fallback', () {
      expect(NotificationType.fromString('jobAlert'), NotificationType.jobAlert);
      expect(NotificationType.fromString('interview_reminder'), NotificationType.interviewReminder);
      expect(NotificationType.fromString('goalDeadline'), NotificationType.goalDeadline);
      expect(NotificationType.fromString('resumeFeedback'), NotificationType.resumeFeedback);
      expect(NotificationType.fromString('skillRecommendation'), NotificationType.skillRecommendation);
      expect(NotificationType.fromString(null), NotificationType.jobAlert);
      expect(NotificationType.fromString('unknown_type'), NotificationType.jobAlert);
    });

    test('NotificationItem copyWith and JSON round-trip preserve all fields', () {
      final notif = NotificationItem(
        id: 'notif_unit_1',
        title: 'New Match Alert',
        message: 'Your dream job was posted',
        type: NotificationType.jobAlert,
        createdAt: DateTime(2026, 10, 15, 14, 30),
        isRead: false,
        actionRoute: '/jobs',
      );

      final readNotif = notif.copyWith(isRead: true);
      expect(readNotif.isRead, true);
      expect(readNotif.id, notif.id);

      final json = notif.toJson();
      expect(json['id'], 'notif_unit_1');
      expect(json['type'], 'jobAlert');
      expect(json['isRead'], false);

      final parsed = NotificationItem.fromJson(json);
      expect(parsed.id, notif.id);
      expect(parsed.title, notif.title);
      expect(parsed.type, notif.type);
    });
  });

  group('NotificationService & Notifier Tests', () {
    test('NotificationService returns default notification items', () async {
      final service = NotificationService();
      final items = await service.fetchNotifications();
      expect(items.isNotEmpty, true);
      expect(items.any((n) => n.title.contains('Stripe')), true);
    });

    test('NotificationsNotifier updates read states and clears notifications', () async {
      final service = NotificationService();
      final notifier = NotificationsNotifier(service);

      await notifier.loadNotifications();
      expect(notifier.state.isNotEmpty, true);

      final firstId = notifier.state.first.id;
      notifier.markAsRead(firstId);
      expect(notifier.state.firstWhere((n) => n.id == firstId).isRead, true);

      notifier.markAllAsRead();
      expect(notifier.state.every((n) => n.isRead), true);

      notifier.removeNotification(firstId);
      expect(notifier.state.any((n) => n.id == firstId), false);

      notifier.clearAll();
      expect(notifier.state.isEmpty, true);
    });
  });
}
