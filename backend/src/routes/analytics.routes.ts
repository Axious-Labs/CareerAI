import { Router } from 'express';
import { AnalyticsController } from '../controllers/analytics.controller';
import { AnalyticsService } from '../services/analytics.service';
import { AnalyticsRepository } from '../repositories/analytics.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { salaryBenchmarkQuerySchema } from '../schemas/analytics.schema';

const analyticsRouter = Router();
const analyticsRepo = new AnalyticsRepository();
const analyticsService = new AnalyticsService(analyticsRepo);
const analyticsController = new AnalyticsController(analyticsService);

analyticsRouter.get('/overview', authenticate, analyticsController.getOverview);
analyticsRouter.get('/market-trends', authenticate, analyticsController.getMarketTrends);
analyticsRouter.get('/funnel', authenticate, analyticsController.getFunnel);
analyticsRouter.post(
  '/salary-benchmark',
  authenticate,
  validateRequest(salaryBenchmarkQuerySchema),
  analyticsController.getSalaryBenchmark
);

export { analyticsRouter };

