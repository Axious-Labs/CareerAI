import { z } from 'zod';

export const notificationTypeEnum = z.enum([
  'INTERVIEW_REMINDER',
  'APPLICATION_UPDATE',
  'SKILL_RECOMMENDATION',
  'SYSTEM_ALERT',
  'GOAL_MILESTONE',
]);

export const notificationPriorityEnum = z.enum([
  'LOW',
  'MEDIUM',
  'HIGH',
  'URGENT',
]);

export const createNotificationSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  message: z.string().min(5, 'Message must be at least 5 characters'),
  type: notificationTypeEnum,
  priority: notificationPriorityEnum.default('MEDIUM'),
  actionUrl: z.string().optional(),
  metadata: z.record(z.any()).optional(),
});

export const notificationQuerySchema = z.object({
  unreadOnly: z.preprocess((val) => val === 'true' || val === true, z.boolean()).optional(),
  type: notificationTypeEnum.optional(),
  priority: notificationPriorityEnum.optional(),
});

export type CreateNotificationInput = z.infer<typeof createNotificationSchema>;
export type NotificationQueryInput = z.infer<typeof notificationQuerySchema>;
export type NotificationType = z.infer<typeof notificationTypeEnum>;
export type NotificationPriority = z.infer<typeof notificationPriorityEnum>;

