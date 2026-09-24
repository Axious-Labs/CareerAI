import { Router } from 'express';
import { ResumeController } from '../controllers/resume.controller';
import { ResumeService } from '../services/resume.service';
import { ResumeRepository } from '../repositories/resume.repository';
import { GenAIClient } from '../integrations/genai/genai.client';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { uploadResumeSchema } from '../schemas/resume.schema';

const resumeRouter = Router();
const resumeRepo = new ResumeRepository();
const genaiClient = new GenAIClient();
const resumeService = new ResumeService(resumeRepo, genaiClient);
const resumeController = new ResumeController(resumeService);

resumeRouter.post('/upload', authenticate, validateRequest(uploadResumeSchema), resumeController.upload);
resumeRouter.get('/', authenticate, resumeController.getAll);
resumeRouter.get('/:id', authenticate, resumeController.getById);

export { resumeRouter };
