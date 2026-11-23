import { Router } from 'express';
import { LearningController } from '../controllers/learning.controller';
import { LearningService } from '../services/learning.service';
import { LearningRepository } from '../repositories/learning.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { createCourseSchema, updateModuleProgressSchema } from '../schemas/learning.schema';

const learningRouter = Router();
const learningRepo = new LearningRepository();
const learningService = new LearningService(learningRepo);
const learningController = new LearningController(learningService);

learningRouter.get('/courses', authenticate, learningController.getAll);
learningRouter.post(
  '/courses',
  authenticate,
  validateRequest(createCourseSchema),
  learningController.create
);
learningRouter.get('/courses/:id', authenticate, learningController.getById);
learningRouter.patch('/courses/:id/bookmark', authenticate, learningController.toggleBookmark);
learningRouter.post(
  '/courses/:id/progress',
  authenticate,
  validateRequest(updateModuleProgressSchema),
  learningController.updateModuleProgress
);
learningRouter.get('/enrolled', authenticate, learningController.getUserEnrolled);

export { learningRouter };

