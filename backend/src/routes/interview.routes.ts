import { Router } from 'express';
import { InterviewController } from '../controllers/interview.controller';
import { InterviewService } from '../services/interview.service';
import { GenAIClient } from '../integrations/genai/genai.client';
import { UserRepository } from '../repositories/user.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { startInterviewSchema, evaluateAnswerSchema } from '../schemas/interview.schema';

const interviewRouter = Router();
const genaiClient = new GenAIClient();
const userRepo = new UserRepository();
const skillRepo = new SkillRepository();
const interviewService = new InterviewService(genaiClient, userRepo, skillRepo);
const interviewController = new InterviewController(interviewService);

interviewRouter.post(
  '/start',
  authenticate,
  validateRequest(startInterviewSchema),
  interviewController.startInterview
);

interviewRouter.post(
  '/evaluate',
  authenticate,
  validateRequest(evaluateAnswerSchema),
  interviewController.evaluateAnswer
);

interviewRouter.get(
  '/history',
  authenticate,
  interviewController.getHistory
);

export { interviewRouter };
