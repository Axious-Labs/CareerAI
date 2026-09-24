import { Response, NextFunction } from 'express';
import { UserService } from '../services/user.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class UserController {
  constructor(private userService: UserService) {}

  getProfile = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const profile = await this.userService.getProfile(userId);
      sendSuccess(res, profile, 200);
    } catch (err) {
      next(err);
    }
  };

  updateProfile = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const updated = await this.userService.updateProfile(userId, req.body);
      sendSuccess(res, updated, 200);
    } catch (err) {
      next(err);
    }
  };
}
