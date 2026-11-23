import { NotificationService } from '../src/services/notification.service';
import { NotificationRepository } from '../src/repositories/notification.repository';
import { NotFoundError, UnauthorizedError } from '../src/utils/errors';

describe('Notification Service Tests', () => {
  let notifRepo: NotificationRepository;
  let notifService: NotificationService;

  beforeEach(() => {
    notifRepo = new NotificationRepository();
    notifService = new NotificationService(notifRepo);
  });

  it('should retrieve seeded notifications for user', async () => {
    const list = await notifService.getNotifications('usr_test');
    expect(list.length).toBeGreaterThan(0);
    expect(list[0].id).toBeDefined();
    expect(list[0].title).toBeDefined();
    expect(list[0].message).toBeDefined();
  });

  it('should filter notifications by unread status', async () => {
    const unread = await notifService.getNotifications('usr_test', { unreadOnly: true });
    expect(unread.every((n) => !n.read)).toBe(true);
  });

  it('should filter notifications by type', async () => {
    const interviewNotifs = await notifService.getNotifications('usr_test', {
      type: 'INTERVIEW_REMINDER',
    });
    expect(interviewNotifs.length).toBeGreaterThan(0);
    expect(interviewNotifs.every((n) => n.type === 'INTERVIEW_REMINDER')).toBe(true);
  });

  it('should create a new notification', async () => {
    const created = await notifService.createNotification('usr_test', {
      title: 'New Candidate Match',
      message: 'A candidate profile matching your Senior AI opening has arrived.',
      type: 'APPLICATION_UPDATE',
      priority: 'HIGH',
    });

    expect(created.id).toBeDefined();
    expect(created.title).toBe('New Candidate Match');
    expect(created.read).toBe(false);

    const fetched = await notifRepo.findById(created.id);
    expect(fetched).not.toBeNull();
    expect(fetched?.priority).toBe('HIGH');
  });

  it('should mark a specific notification as read', async () => {
    const created = await notifService.createNotification('usr_read_test', {
      title: 'System Alert',
      message: 'Vector database re-indexing complete.',
      type: 'SYSTEM_ALERT',
      priority: 'LOW',
    });

    const updated = await notifService.markAsRead('usr_read_test', created.id);
    expect(updated.read).toBe(true);
    expect(updated.readAt).toBeDefined();
  });

  it('should throw NotFoundError when marking non-existent notification', async () => {
    await expect(
      notifService.markAsRead('usr_test', 'notif_does_not_exist_999')
    ).rejects.toThrow(NotFoundError);
  });

  it('should mark all notifications as read for a user', async () => {
    const result = await notifService.markAllAsRead('usr_test');
    expect(result.markedCount).toBeGreaterThanOrEqual(0);

    const unreadCount = await notifService.getUnreadCount('usr_test');
    expect(unreadCount.unreadCount).toBe(0);
  });

  it('should compute comprehensive notification summary metrics', async () => {
    const summary = await notifService.getNotificationSummary('usr_test');
    expect(summary.total).toBeGreaterThanOrEqual(0);
    expect(summary.byPriority).toHaveProperty('HIGH');
    expect(summary.byType).toHaveProperty('INTERVIEW_REMINDER');
  });

  it('should delete a notification', async () => {
    const created = await notifService.createNotification('usr_del_test', {
      title: 'Temporary',
      message: 'Will be deleted',
      type: 'SYSTEM_ALERT',
      priority: 'LOW',
    });

    const res = await notifService.deleteNotification('usr_del_test', created.id);
    expect(res.id).toBe(created.id);

    const check = await notifRepo.findById(created.id);
    expect(check).toBeNull();
  });
});

