import { Router } from 'express';
import { ChatController } from '../controllers/chat.controller';
import { ChatService } from '../services/chat.service';
import { GenAIClient } from '../integrations/genai/genai.client';
import { UserRepository } from '../repositories/user.repository';
import { authenticate } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validate.middleware';
import { chatMessageSchema } from '../schemas/chat.schema';

const chatRouter = Router();
const genaiClient = new GenAIClient();
const userRepo = new UserRepository();
const chatService = new ChatService(genaiClient, userRepo);
const chatController = new ChatController(chatService);

chatRouter.post('/', authenticate, validateRequest(chatMessageSchema), chatController.sendMessage);

export { chatRouter };
