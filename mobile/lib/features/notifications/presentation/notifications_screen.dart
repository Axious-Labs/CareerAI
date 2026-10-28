import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(filteredNotificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final activeFilter = ref.watch(notificationTypeFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Career Alerts'),
            if (unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount new',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: () => ref.read(notificationsNotifierProvider.notifier).markAllAsRead(),
              icon: const Icon(Icons.done_all, size: 16, color: AppColors.accentLight),
              label: const Text('Read All', style: TextStyle(color: AppColors.accentLight, fontSize: 13)),
            ),
          IconButton(
            icon: const Icon(Icons.clear_all, color: AppColors.textMuted),
            tooltip: 'Clear All',
            onPressed: () => ref.read(notificationsNotifierProvider.notifier).clearAll(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Alerts'),
                  selected: activeFilter == null,
                  onSelected: (_) => ref.read(notificationTypeFilterProvider.notifier).state = null,
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.accent.withValues(alpha: 0.25),
                  labelStyle: TextStyle(
                    color: activeFilter == null ? AppColors.accentLight : AppColors.textSecondary,
                    fontWeight: activeFilter == null ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: activeFilter == null ? AppColors.accent : AppColors.border),
                ),
                const SizedBox(width: 8),
                ...NotificationType.values.map((type) {
                  final isSelected = activeFilter == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.label),
                      selected: isSelected,
                      onSelected: (_) => ref.read(notificationTypeFilterProvider.notifier).state = type,
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.accent.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.accentLight : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      side: BorderSide(color: isSelected ? AppColors.accent : AppColors.border),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Notification List
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No Alerts at this time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'We will notify you when relevant jobs, mock sessions, or goals update.',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return NotificationTile(
                        item: item,
                        onMarkAsRead: () =>
                            ref.read(notificationsNotifierProvider.notifier).markAsRead(item.id),
                        onDismiss: () =>
                            ref.read(notificationsNotifierProvider.notifier).removeNotification(item.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
