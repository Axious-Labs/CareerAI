import { Router } from 'express';
import { NotificationController } from '../controllers/notification.controller';
import { NotificationService } from '../services/notification.service';
import { NotificationRepository } from '../repositories/notification.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { createNotificationSchema } from '../schemas/notification.schema';

const notificationRouter = Router();
const notifRepo = new NotificationRepository();
const notifService = new NotificationService(notifRepo);
const notifController = new NotificationController(notifService);

notificationRouter.get('/summary', authenticate, notifController.getSummary);
notificationRouter.get('/unread-count', authenticate, notifController.getUnreadCount);
notificationRouter.patch('/mark-all-read', authenticate, notifController.markAllAsRead);
notificationRouter.delete('/clear-all', authenticate, notifController.clearAll);

notificationRouter.get('/', authenticate, notifController.getAll);
notificationRouter.post(
  '/',
  authenticate,
  validateRequest(createNotificationSchema),
  notifController.create
);
notificationRouter.patch('/:id/read', authenticate, notifController.markAsRead);
notificationRouter.delete('/:id', authenticate, notifController.delete);

export { notificationRouter };

