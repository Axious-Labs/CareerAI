import { Router } from 'express';
import { UserController } from '../controllers/user.controller';
import { UserService } from '../services/user.service';
import { UserRepository } from '../repositories/user.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { updateUserSchema } from '../schemas/user.schema';

const userRouter = Router();
const userRepo = new UserRepository();
const skillRepo = new SkillRepository();
const userService = new UserService(userRepo, skillRepo);
const userController = new UserController(userService);

userRouter.get('/me', authenticate, userController.getProfile);
userRouter.put('/me', authenticate, validateRequest(updateUserSchema), userController.updateProfile);

export { userRouter };
