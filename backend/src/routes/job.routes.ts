import { Router } from 'express';
import { JobController } from '../controllers/job.controller';
import { JobService } from '../services/job.service';
import { JobRepository } from '../repositories/job.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { createJobSchema } from '../schemas/job.schema';

const jobRouter = Router();
const jobRepo = new JobRepository();
const skillRepo = new SkillRepository();
const jobService = new JobService(jobRepo, skillRepo);
const jobController = new JobController(jobService);

jobRouter.get('/recommendations', authenticate, jobController.getRecommendations);
jobRouter.get('/search', authenticate, jobController.search);
jobRouter.get('/:id/match', authenticate, jobController.getJobMatch);
jobRouter.get('/:id', authenticate, jobController.getById);
jobRouter.get('/', authenticate, jobController.getAll);
jobRouter.post('/', authenticate, validateRequest(createJobSchema), jobController.create);

export { jobRouter };
