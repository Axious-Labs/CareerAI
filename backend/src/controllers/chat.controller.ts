import { Response, NextFunction } from 'express';
import { ChatService } from '../services/chat.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class ChatController {
  constructor(private chatService: ChatService) {}

  sendMessage = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.chatService.processMessage(userId, req.body);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };
}
