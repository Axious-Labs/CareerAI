import { NotificationRepository, NotificationItem } from '../repositories/notification.repository';
import { CreateNotificationInput, NotificationPriority, NotificationQueryInput, NotificationType } from '../schemas/notification.schema';
import { NotFoundError, UnauthorizedError } from '../utils/errors';

export interface NotificationSummary {
  total: number;
  unread: number;
  read: number;
  byPriority: Record<NotificationPriority, number>;
  byType: Record<NotificationType, number>;
}

export class NotificationService {
  constructor(private notifRepo: NotificationRepository) {}

  async getNotifications(userId: string, query?: NotificationQueryInput): Promise<NotificationItem[]> {
    return this.notifRepo.findByUserId(userId, {
      unreadOnly: query?.unreadOnly,
      type: query?.type,
      priority: query?.priority,
    });
  }

  async getUnreadCount(userId: string): Promise<{ unreadCount: number }> {
    const unreadCount = await this.notifRepo.getUnreadCount(userId);
    return { unreadCount };
  }

  async markAsRead(userId: string, notificationId: string): Promise<NotificationItem> {
    const notif = await this.notifRepo.findById(notificationId);
    if (!notif) {
      throw new NotFoundError('Notification not found');
    }
    if (notif.userId !== userId && notif.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to modify this notification');
    }

    const updated = await this.notifRepo.markAsRead(notificationId);
    return updated!;
  }

  async markAllAsRead(userId: string): Promise<{ markedCount: number; message: string }> {
    const markedCount = await this.notifRepo.markAllAsRead(userId);
    return {
      markedCount,
      message: `Successfully marked ${markedCount} notification(s) as read`,
    };
  }

  async createNotification(userId: string, input: CreateNotificationInput): Promise<NotificationItem> {
    const id = `notif_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
    const newNotif: NotificationItem = {
      id,
      userId,
      title: input.title,
      message: input.message,
      type: input.type,
      priority: input.priority || 'MEDIUM',
      read: false,
      actionUrl: input.actionUrl,
      metadata: input.metadata,
      createdAt: new Date(),
    };

    return this.notifRepo.create(newNotif);
  }

  async deleteNotification(userId: string, notificationId: string): Promise<{ id: string; message: string }> {
    const notif = await this.notifRepo.findById(notificationId);
    if (!notif) {
      throw new NotFoundError('Notification not found');
    }
    if (notif.userId !== userId && notif.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to delete this notification');
    }

    await this.notifRepo.delete(notificationId);
    return { id: notificationId, message: 'Notification successfully deleted' };
  }

  async clearAllNotifications(userId: string): Promise<{ clearedCount: number; message: string }> {
    const clearedCount = await this.notifRepo.clearAll(userId);
    return {
      clearedCount,
      message: `Cleared ${clearedCount} notifications`,
    };
  }

  async getNotificationSummary(userId: string): Promise<NotificationSummary> {
    const notifications = await this.notifRepo.findByUserId(userId);

    const byPriority: Record<NotificationPriority, number> = {
      LOW: 0,
      MEDIUM: 0,
      HIGH: 0,
      URGENT: 0,
    };

    const byType: Record<NotificationType, number> = {
      INTERVIEW_REMINDER: 0,
      APPLICATION_UPDATE: 0,
      SKILL_RECOMMENDATION: 0,
      SYSTEM_ALERT: 0,
      GOAL_MILESTONE: 0,
    };

    let unread = 0;
    for (const notif of notifications) {
      if (!notif.read) unread++;
      if (byPriority[notif.priority] !== undefined) byPriority[notif.priority]++;
      if (byType[notif.type] !== undefined) byType[notif.type]++;
    }

    return {
      total: notifications.length,
      unread,
      read: notifications.length - unread,
      byPriority,
      byType,
    };
  }
}

