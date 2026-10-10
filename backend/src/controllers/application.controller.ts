import { Response, NextFunction } from 'express';
import { ApplicationService } from '../services/application.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class ApplicationController {
  constructor(private appService: ApplicationService) {}

  getAll = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const apps = await this.appService.getUserApplications(userId);
      sendSuccess(res, apps, 200);
    } catch (err) {
      next(err);
    }
  };

  create = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const app = await this.appService.createApplication(userId, req.body);
      sendSuccess(res, app, 201);
    } catch (err) {
      next(err);
    }
  };

  updateStatus = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const { status, notes } = req.body;
      const updated = await this.appService.updateStatus(
        userId,
        req.params.id,
        status,
        notes
      );
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };

  updateNotes = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const { notes } = req.body;
      const updated = await this.appService.updateNotes(
        userId,
        req.params.id,
        notes
      );
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };

  delete = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.appService.deleteApplication(userId, req.params.id);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getAnalytics = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const analytics = await this.appService.getApplicationAnalytics(userId);
      sendSuccess(res, analytics, 200);
    } catch (err) {
      next(err);
    }
  };
}
