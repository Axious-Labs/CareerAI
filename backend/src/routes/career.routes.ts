import { Router } from 'express';
import { CareerController } from '../controllers/career.controller';
import { CareerService } from '../services/career.service';
import { GenAIClient } from '../integrations/genai/genai.client';
import { AgentClient } from '../integrations/agents/agent.client';
import { UserRepository } from '../repositories/user.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { careerAnalyzeSchema, skillGapSchema, roadmapSchema } from '../schemas/career.schema';

const careerRouter = Router();
const genaiClient = new GenAIClient();
const agentClient = new AgentClient();
const userRepo = new UserRepository();
const skillRepo = new SkillRepository();
const careerService = new CareerService(genaiClient, agentClient, userRepo, skillRepo);
const careerController = new CareerController(careerService);

careerRouter.post('/analyze', authenticate, validateRequest(careerAnalyzeSchema), careerController.analyzeProfile);
careerRouter.post('/skill-gap', authenticate, validateRequest(skillGapSchema), careerController.getSkillGap);
careerRouter.post('/roadmap', authenticate, validateRequest(roadmapSchema), careerController.getRoadmap);

export { careerRouter };
