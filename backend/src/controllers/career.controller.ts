import { Response, NextFunction } from 'express';
import { CareerService } from '../services/career.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class CareerController {
  constructor(private careerService: CareerService) {}

  analyzeProfile = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.careerService.analyzeProfile(userId, req.body.targetRole);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getSkillGap = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.careerService.getSkillGap(userId, req.body.targetRole);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getRoadmap = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.careerService.getRoadmap(
        userId,
        req.body.targetRole,
        req.body.timelineWeeks
      );
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };
}
