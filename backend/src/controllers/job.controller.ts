import { Request, Response, NextFunction } from 'express';
import { JobService } from '../services/job.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class JobController {
  constructor(private jobService: JobService) {}

  getAll = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const roleFilter = req.query.role as string | undefined;
      const jobs = await this.jobService.getJobs(roleFilter);
      sendSuccess(res, jobs, 200);
    } catch (err) {
      next(err);
    }
  };

  getById = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const job = await this.jobService.getJobById(req.params.id);
      sendSuccess(res, job, 200);
    } catch (err) {
      next(err);
    }
  };

  create = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const job = await this.jobService.createJob(req.body);
      sendSuccess(res, job, 201);
    } catch (err) {
      next(err);
    }
  };

  getRecommendations = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user?.userId || 'usr_default';
      const recommendations = await this.jobService.getRecommendedJobs(userId);
      sendSuccess(res, recommendations, 200);
    } catch (err) {
      next(err);
    }
  };

  getJobMatch = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user?.userId || 'usr_default';
      const match = await this.jobService.getJobMatchDetails(userId, req.params.id);
      sendSuccess(res, match, 200);
    } catch (err) {
      next(err);
    }
  };

  search = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = req.query.query as string | undefined;
      const location = req.query.location as string | undefined;
      const jobType = req.query.jobType as string | undefined;
      const results = await this.jobService.searchJobs(query, location, jobType);
      sendSuccess(res, results, 200);
    } catch (err) {
      next(err);
    }
  };
}
