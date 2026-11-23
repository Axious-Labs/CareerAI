import { NotificationPriority, NotificationType } from '../schemas/notification.schema';

export interface NotificationItem {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: NotificationType;
  priority: NotificationPriority;
  read: boolean;
  actionUrl?: string;
  metadata?: Record<string, any>;
  createdAt: Date;
  readAt?: Date;
}

export class NotificationRepository {
  private static notificationsStore: Map<string, NotificationItem> = new Map();

  constructor() {
    this.seedDefaultNotifications();
  }

  private seedDefaultNotifications(): void {
    if (NotificationRepository.notificationsStore.size > 0) return;

    const initialNotifications: NotificationItem[] = [
      {
        id: 'notif_01',
        userId: 'usr_default',
        title: 'Mock Interview Ready',
        message: 'Your AI Mock Technical System Architecture interview session is ready to review.',
        type: 'INTERVIEW_REMINDER',
        priority: 'HIGH',
        read: false,
        actionUrl: '/interviews/sess_test_1',
        metadata: { sessionId: 'sess_test_1', role: 'AI/ML Engineer' },
        createdAt: new Date(Date.now() - 3600000), // 1 hour ago
      },
      {
        id: 'notif_02',
        userId: 'usr_default',
        title: 'Application Status Updated',
        message: 'Axious Labs has advanced your application for Senior AI Platform Engineer to Interviewing.',
        type: 'APPLICATION_UPDATE',
        priority: 'URGENT',
        read: false,
        actionUrl: '/applications/app_101',
        metadata: { applicationId: 'app_101', newStatus: 'INTERVIEWING' },
        createdAt: new Date(Date.now() - 7200000), // 2 hours ago
      },
      {
        id: 'notif_03',
        userId: 'usr_default',
        title: 'Skill Recommendation',
        message: 'Trending requirement detected: 78% of AI roles now seek LangGraph cyclic workflow skills.',
        type: 'SKILL_RECOMMENDATION',
        priority: 'MEDIUM',
        read: true,
        actionUrl: '/skills/recommendations',
        metadata: { skill: 'LangGraph', relevanceScore: 0.92 },
        createdAt: new Date(Date.now() - 86400000), // 1 day ago
        readAt: new Date(Date.now() - 43200000),
      },
      {
        id: 'notif_04',
        userId: 'usr_default',
        title: 'Career Goal Milestone Reached',
        message: 'Congratulations! You reached 65% completion on "Master LangGraph Cyclic AI Workflows".',
        type: 'GOAL_MILESTONE',
        priority: 'LOW',
        read: true,
        actionUrl: '/goals/goal_01',
        metadata: { goalId: 'goal_01', progress: 65 },
        createdAt: new Date(Date.now() - 172800000), // 2 days ago
        readAt: new Date(Date.now() - 86400000),
      },
      {
        id: 'notif_05',
        userId: 'usr_default',
        title: 'System Maintenance Notice',
        message: 'Scheduled infrastructure enhancements for Vector DB embeddings tonight at 02:00 UTC.',
        type: 'SYSTEM_ALERT',
        priority: 'LOW',
        read: true,
        createdAt: new Date(Date.now() - 259200000), // 3 days ago
        readAt: new Date(Date.now() - 200000000),
      },
    ];

    for (const notif of initialNotifications) {
      NotificationRepository.notificationsStore.set(notif.id, notif);
    }
  }

  async findByUserId(
    userId: string,
    options?: { unreadOnly?: boolean; type?: NotificationType; priority?: NotificationPriority }
  ): Promise<NotificationItem[]> {
    const results: NotificationItem[] = [];

    for (const notif of NotificationRepository.notificationsStore.values()) {
      if (notif.userId === userId || notif.userId === 'usr_default') {
        if (options?.unreadOnly && notif.read) continue;
        if (options?.type && notif.type !== options.type) continue;
        if (options?.priority && notif.priority !== options.priority) continue;
        results.push(notif);
      }
    }

    return results.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
  }

  async findById(id: string): Promise<NotificationItem | null> {
    return NotificationRepository.notificationsStore.get(id) || null;
  }

  async create(item: NotificationItem): Promise<NotificationItem> {
    NotificationRepository.notificationsStore.set(item.id, item);
    return item;
  }

  async markAsRead(id: string): Promise<NotificationItem | null> {
    const notif = NotificationRepository.notificationsStore.get(id);
    if (!notif) return null;

    const updated: NotificationItem = {
      ...notif,
      read: true,
      readAt: new Date(),
    };
    NotificationRepository.notificationsStore.set(id, updated);
    return updated;
  }

  async markAllAsRead(userId: string): Promise<number> {
    let count = 0;
    for (const [id, notif] of NotificationRepository.notificationsStore.entries()) {
      if ((notif.userId === userId || notif.userId === 'usr_default') && !notif.read) {
        NotificationRepository.notificationsStore.set(id, {
          ...notif,
          read: true,
          readAt: new Date(),
        });
        count++;
      }
    }
    return count;
  }

  async getUnreadCount(userId: string): Promise<number> {
    let count = 0;
    for (const notif of NotificationRepository.notificationsStore.values()) {
      if ((notif.userId === userId || notif.userId === 'usr_default') && !notif.read) {
        count++;
      }
    }
    return count;
  }

  async delete(id: string): Promise<boolean> {
    return NotificationRepository.notificationsStore.delete(id);
  }

  async clearAll(userId: string): Promise<number> {
    let count = 0;
    for (const [id, notif] of NotificationRepository.notificationsStore.entries()) {
      if (notif.userId === userId || notif.userId === 'usr_default') {
        NotificationRepository.notificationsStore.delete(id);
        count++;
      }
    }
    return count;
  }
}

