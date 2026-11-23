import { Response, NextFunction } from 'express';
import { LearningService } from '../services/learning.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';
import { createCourseSchema, learningQuerySchema, updateModuleProgressSchema } from '../schemas/learning.schema';

export class LearningController {
  constructor(private learningService: LearningService) {}

  getAll = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const parsedQuery = learningQuerySchema.parse(req.query);
      const courses = await this.learningService.getAllCourses(parsedQuery);
      sendSuccess(res, courses, 200);
    } catch (err) {
      next(err);
    }
  };

  getById = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const course = await this.learningService.getCourseById(req.params.id);
      sendSuccess(res, course, 200);
    } catch (err) {
      next(err);
    }
  };

  create = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const input = createCourseSchema.parse(req.body);
      const course = await this.learningService.createCourse(input);
      sendSuccess(res, course, 201);
    } catch (err) {
      next(err);
    }
  };

  toggleBookmark = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const progress = await this.learningService.toggleBookmark(userId, req.params.id);
      sendSuccess(res, progress, 200);
    } catch (err) {
      next(err);
    }
  };

  updateModuleProgress = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const input = updateModuleProgressSchema.parse(req.body);
      const progress = await this.learningService.updateModuleProgress(userId, req.params.id, input);
      sendSuccess(res, progress, 200);
    } catch (err) {
      next(err);
    }
  };

  getUserEnrolled = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const courses = await this.learningService.getUserEnrolledCourses(userId);
      sendSuccess(res, courses, 200);
    } catch (err) {
      next(err);
    }
  };
}

