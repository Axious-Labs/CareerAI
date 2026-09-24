import { Request, Response, NextFunction } from 'express';
import { SkillService } from '../services/skill.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class SkillController {
  constructor(private skillService: SkillService) {}

  getAll = async (_req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const skills = await this.skillService.getAllSkills();
      sendSuccess(res, skills, 200);
    } catch (err) {
      next(err);
    }
  };

  create = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const skill = await this.skillService.createSkill(req.body);
      sendSuccess(res, skill, 201);
    } catch (err) {
      next(err);
    }
  };

  addUserSkill = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const userSkill = await this.skillService.addUserSkill(userId, req.body);
      sendSuccess(res, userSkill, 201);
    } catch (err) {
      next(err);
    }
  };
}
