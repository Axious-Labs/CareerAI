import { GenAIClient } from '../integrations/genai/genai.client';
import { UserRepository } from '../repositories/user.repository';
import { ChatMessageInput } from '../schemas/chat.schema';

export class ChatService {
  constructor(
    private genaiClient: GenAIClient,
    private userRepo: UserRepository
  ) {}

  async processMessage(userId: string, input: ChatMessageInput) {
    const user = await this.userRepo.findById(userId);

    const context = {
      userName: user?.name || 'Developer',
      targetRole: user?.targetRole || 'AI/ML Engineer',
      skills: ['Python', 'Flutter', 'FastAPI', 'Docker', 'Machine Learning'],
    };

    const answer = await this.genaiClient.generateCareerAdvice(input.message, context);

    return {
      response: answer,
      source: 'career_assistant',
      timestamp: new Date().toISOString(),
      suggestedPrompts: [
        'How can I bridge my LangGraph skill gap?',
        'Review my resume for Junior AI roles',
        'Suggest 3 project ideas to build this week',
      ],
    };
  }
}
