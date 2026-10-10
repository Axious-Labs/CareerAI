import { Response, NextFunction } from 'express';
import { GoalService } from '../services/goal.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class GoalController {
  constructor(private goalService: GoalService) {}

  getAll = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const category = req.query.category as string | undefined;
      const goals = await this.goalService.getUserGoals(userId, category);
      sendSuccess(res, goals, 200);
    } catch (err) {
      next(err);
    }
  };

  getById = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const goal = await this.goalService.getGoalById(userId, req.params.id);
      sendSuccess(res, goal, 200);
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
      const goal = await this.goalService.createGoal(userId, req.body);
      sendSuccess(res, goal, 201);
    } catch (err) {
      next(err);
    }
  };

  updateProgress = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const { progressPercentage, status } = req.body;
      const updated = await this.goalService.updateProgress(
        userId,
        req.params.id,
        progressPercentage,
        status
      );
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };

  toggleMilestone = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const updated = await this.goalService.toggleMilestone(
        userId,
        req.params.id,
        req.params.milestoneId
      );
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };

  addMilestone = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const updated = await this.goalService.addMilestone(
        userId,
        req.params.id,
        req.body.title
      );
      sendSuccess(res, updated, 201);
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
      const result = await this.goalService.deleteGoal(userId, req.params.id);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getSummary = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const summary = await this.goalService.getGoalsSummary(userId);
      sendSuccess(res, summary, 200);
    } catch (err) {
      next(err);
    }
  };
}
