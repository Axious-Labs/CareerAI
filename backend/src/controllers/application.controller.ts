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
}
