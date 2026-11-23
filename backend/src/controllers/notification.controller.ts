import { Response, NextFunction } from 'express';
import { NotificationService } from '../services/notification.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';
import { notificationQuerySchema } from '../schemas/notification.schema';

export class NotificationController {
  constructor(private notifService: NotificationService) {}

  getAll = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const parsedQuery = notificationQuerySchema.parse(req.query);
      const notifications = await this.notifService.getNotifications(userId, parsedQuery);
      sendSuccess(res, notifications, 200);
    } catch (err) {
      next(err);
    }
  };

  getUnreadCount = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.notifService.getUnreadCount(userId);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  markAsRead = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const updated = await this.notifService.markAsRead(userId, req.params.id);
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };

  markAllAsRead = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.notifService.markAllAsRead(userId);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  create = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const notification = await this.notifService.createNotification(userId, req.body);
      sendSuccess(res, notification, 201);
    } catch (err) {
      next(err);
    }
  };

  delete = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.notifService.deleteNotification(userId, req.params.id);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  clearAll = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.notifService.clearAllNotifications(userId);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getSummary = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const summary = await this.notifService.getNotificationSummary(userId);
      sendSuccess(res, summary, 200);
    } catch (err) {
      next(err);
    }
  };
}

