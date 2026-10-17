import 'package:flutter/foundation.dart';

enum NotificationType {
  jobAlert,
  interviewReminder,
  goalDeadline,
  resumeFeedback,
  skillRecommendation;

  String get label {
    switch (this) {
      case NotificationType.jobAlert:
        return 'Job Match Alert';
      case NotificationType.interviewReminder:
        return 'Interview Session';
      case NotificationType.goalDeadline:
        return 'Goal Milestone';
      case NotificationType.resumeFeedback:
        return 'Resume AI Insights';
      case NotificationType.skillRecommendation:
        return 'Skill Roadmap';
    }
  }

  static NotificationType fromString(String? val) {
    if (val == null) return NotificationType.jobAlert;
    final normalized = val.toLowerCase().replaceAll('_', '');
    for (final t in NotificationType.values) {
      if (t.name.toLowerCase() == normalized) return t;
    }
    return NotificationType.jobAlert;
  }
}

@immutable
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? metadata;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
    this.metadata,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      metadata: metadata ?? this.metadata,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? 'Career Notification',
      message: json['message'] as String? ?? '',
      type: NotificationType.fromString(json['type'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      actionRoute: json['actionRoute'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'actionRoute': actionRoute,
    'metadata': metadata,
  };
}
