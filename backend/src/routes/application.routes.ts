import { Router } from 'express';
import { ApplicationController } from '../controllers/application.controller';
import { ApplicationService } from '../services/application.service';
import { ApplicationRepository } from '../repositories/application.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { createApplicationSchema } from '../schemas/application.schema';

const applicationRouter = Router();
const appRepo = new ApplicationRepository();
const appService = new ApplicationService(appRepo);
const appController = new ApplicationController(appService);

applicationRouter.get('/', authenticate, appController.getAll);
applicationRouter.post('/', authenticate, validateRequest(createApplicationSchema), appController.create);

export { applicationRouter };
