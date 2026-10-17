import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  List<NotificationItem> get _defaultNotifications => [
    NotificationItem(
      id: 'notif_1',
      title: '95% Job Match: Senior Flutter Engineer at Stripe',
      message: 'A new high-match opening aligned with your skills in Riverpod and CI/CD was just published.',
      type: NotificationType.jobAlert,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      isRead: false,
      actionRoute: '/jobs',
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Technical Mock Interview Scheduled Tomorrow',
      message: 'Prepare for your Mobile System Design mock session with AI evaluation at 10:00 AM.',
      type: NotificationType.interviewReminder,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      actionRoute: '/interview-prep',
    ),
    NotificationItem(
      id: 'notif_3',
      title: 'Milestone Deadline: Master StateNotifier',
      message: 'Your goal milestone "Master StateNotifier and AsyncNotifier" target is approaching in 2 days.',
      type: NotificationType.goalDeadline,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      actionRoute: '/goals',
    ),
    NotificationItem(
      id: 'notif_4',
      title: 'Resume ATS Score Improved to 92/100',
      message: 'Your latest resume upload passed 14 ATS checks with 18 high-impact action verbs detected.',
      type: NotificationType.resumeFeedback,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionRoute: '/resume',
    ),
    NotificationItem(
      id: 'notif_5',
      title: 'Trending Skill: Agentic AI Integration',
      message: 'Add Agentic AI integration projects to your portfolio to boost employer inbound inquiries by 40%.',
      type: NotificationType.skillRecommendation,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      actionRoute: '/skills',
    ),
  ];

  Future<List<NotificationItem>> fetchNotifications() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.notifications);
      if (response.statusCode == 200 && response.data is List) {
        final list = (response.data as List)
            .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return list.isNotEmpty ? list : _defaultNotifications;
      }
    } catch (_) {
      // Offline fallback
    }
    return _defaultNotifications;
  }

  Future<bool> markAsRead(String id) async {
    try {
      final response = await _apiClient.dio.patch('${ApiEndpoints.markNotificationRead}/$id');
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }
}

// -----------------------------------------------------------------------------
// Riverpod State Management
// -----------------------------------------------------------------------------

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  final NotificationService _service;

  NotificationsNotifier(this._service) : super([]) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final items = await _service.fetchNotifications();
    state = items;
  }

  void markAsRead(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
    _service.markAsRead(id);
  }

  void markAllAsRead() {
    state = state.map((item) => item.copyWith(isRead: true)).toList();
  }

  void removeNotification(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final notificationsNotifierProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return NotificationsNotifier(service);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final list = ref.watch(notificationsNotifierProvider);
  return list.where((item) => !item.isRead).length;
});

final notificationTypeFilterProvider = StateProvider<NotificationType?>((ref) => null);

final filteredNotificationsProvider = Provider<List<NotificationItem>>((ref) {
  final list = ref.watch(notificationsNotifierProvider);
  final filter = ref.watch(notificationTypeFilterProvider);

  if (filter == null) return list;
  return list.where((item) => item.type == filter).toList();
});
