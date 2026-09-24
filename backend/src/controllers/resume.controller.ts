import { Response, NextFunction } from 'express';
import { ResumeService } from '../services/resume.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class ResumeController {
  constructor(private resumeService: ResumeService) {}

  upload = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const resume = await this.resumeService.uploadResume(userId, req.body);
      sendSuccess(res, resume, 201);
    } catch (err) {
      next(err);
    }
  };

  getAll = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const resumes = await this.resumeService.getUserResumes(userId);
      sendSuccess(res, resumes, 200);
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
      const resume = await this.resumeService.getResumeById(req.params.id);
      sendSuccess(res, resume, 200);
    } catch (err) {
      next(err);
    }
  };
}
