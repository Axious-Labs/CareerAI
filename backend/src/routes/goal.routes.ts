import { Router } from 'express';
import { GoalController } from '../controllers/goal.controller';
import { GoalService } from '../services/goal.service';
import { GoalRepository } from '../repositories/goal.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import {
  createGoalSchema,
  updateGoalProgressSchema,
  addMilestoneSchema,
} from '../schemas/goal.schema';

const goalRouter = Router();
const goalRepo = new GoalRepository();
const goalService = new GoalService(goalRepo);
const goalController = new GoalController(goalService);

goalRouter.get('/summary', authenticate, goalController.getSummary);
goalRouter.get('/', authenticate, goalController.getAll);
goalRouter.post(
  '/',
  authenticate,
  validateRequest(createGoalSchema),
  goalController.create
);
goalRouter.get('/:id', authenticate, goalController.getById);
goalRouter.patch(
  '/:id/progress',
  authenticate,
  validateRequest(updateGoalProgressSchema),
  goalController.updateProgress
);
goalRouter.post(
  '/:id/milestones',
  authenticate,
  validateRequest(addMilestoneSchema),
  goalController.addMilestone
);
goalRouter.patch(
  '/:id/milestones/:milestoneId/toggle',
  authenticate,
  goalController.toggleMilestone
);
goalRouter.delete('/:id', authenticate, goalController.delete);

export { goalRouter };
