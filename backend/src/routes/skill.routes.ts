import { Router } from 'express';
import { SkillController } from '../controllers/skill.controller';
import { SkillService } from '../services/skill.service';
import { SkillRepository } from '../repositories/skill.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { addSkillSchema, createSkillSchema } from '../schemas/skill.schema';

const skillRouter = Router();
const skillRepo = new SkillRepository();
const skillService = new SkillService(skillRepo);
const skillController = new SkillController(skillService);

skillRouter.get('/', authenticate, skillController.getAll);
skillRouter.post('/', authenticate, validateRequest(createSkillSchema), skillController.create);
skillRouter.post('/user', authenticate, validateRequest(addSkillSchema), skillController.addUserSkill);

export { skillRouter };
