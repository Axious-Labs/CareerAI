import { Request, Response, NextFunction } from 'express';
import { JobService } from '../services/job.service';
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
}
