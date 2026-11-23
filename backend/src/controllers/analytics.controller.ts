import { Response, NextFunction } from 'express';
import { AnalyticsService } from '../services/analytics.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';
import { salaryBenchmarkQuerySchema } from '../schemas/analytics.schema';

export class AnalyticsController {
  constructor(private analyticsService: AnalyticsService) {}

  getOverview = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const overview = await this.analyticsService.getOverview(userId);
      sendSuccess(res, overview, 200);
    } catch (err) {
      next(err);
    }
  };

  getMarketTrends = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const role = req.query.role as string | undefined;
      const trends = await this.analyticsService.getMarketTrends(role);
      sendSuccess(res, trends, 200);
    } catch (err) {
      next(err);
    }
  };

  getSalaryBenchmark = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const input = salaryBenchmarkQuerySchema.parse(req.body);
      const benchmark = await this.analyticsService.calculateSalaryBenchmark(input);
      sendSuccess(res, benchmark, 200);
    } catch (err) {
      next(err);
    }
  };

  getFunnel = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const totalCount = req.query.total ? parseInt(req.query.total as string, 10) : 12;
      const funnel = await this.analyticsService.getApplicationFunnel(totalCount);
      sendSuccess(res, funnel, 200);
    } catch (err) {
      next(err);
    }
  };
}

