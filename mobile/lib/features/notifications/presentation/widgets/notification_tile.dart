import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.item,
    required this.onMarkAsRead,
    required this.onDismiss,
  });

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.jobAlert:
        return Icons.work_outline;
      case NotificationType.interviewReminder:
        return Icons.video_call_outlined;
      case NotificationType.goalDeadline:
        return Icons.flag_outlined;
      case NotificationType.resumeFeedback:
        return Icons.description_outlined;
      case NotificationType.skillRecommendation:
        return Icons.auto_awesome;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.jobAlert:
        return AppColors.accent;
      case NotificationType.interviewReminder:
        return AppColors.info;
      case NotificationType.goalDeadline:
        return AppColors.warning;
      case NotificationType.resumeFeedback:
        return AppColors.success;
      case NotificationType.skillRecommendation:
        return AppColors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeIcon = _getTypeIcon(item.type);
    final typeColor = _getTypeColor(item.type);
    final timeStr = DateFormat('MMM d, h:mm a').format(item.createdAt);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: item.isRead
              ? AppColors.surface
              : AppColors.surfaceLight.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead ? AppColors.border : typeColor.withValues(alpha: 0.4),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (!item.isRead) onMarkAsRead();
            if (item.actionRoute != null && context.mounted) {
              context.push(item.actionRoute!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.type.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: typeColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(timeStr, style: AppTextStyles.bodySmall),
                              if (!item.isRead) ...[
                                const SizedBox(width: 6),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
