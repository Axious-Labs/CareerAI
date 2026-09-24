import { Router } from 'express';
import { JobController } from '../controllers/job.controller';
import { JobService } from '../services/job.service';
import { JobRepository } from '../repositories/job.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { createJobSchema } from '../schemas/job.schema';

const jobRouter = Router();
const jobRepo = new JobRepository();
const jobService = new JobService(jobRepo);
const jobController = new JobController(jobService);

jobRouter.get('/', authenticate, jobController.getAll);
jobRouter.get('/:id', authenticate, jobController.getById);
jobRouter.post('/', authenticate, validateRequest(createJobSchema), jobController.create);

export { jobRouter };
