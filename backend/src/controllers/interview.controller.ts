import { Response, NextFunction } from 'express';
import { InterviewService } from '../services/interview.service';
import { AuthenticatedRequest } from '../middleware/auth.middleware';
import { sendSuccess } from '../utils/api-response';

export class InterviewController {
  constructor(private interviewService: InterviewService) {}

  startInterview = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const { targetRole, difficulty, skillFocus, questionCount } = req.body;
      const result = await this.interviewService.startInterview(
        userId,
        targetRole,
        difficulty,
        skillFocus,
        questionCount
      );
      sendSuccess(res, result, 201);
    } catch (err) {
      next(err);
    }
  };

  evaluateAnswer = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const { sessionId, questionId, questionText, candidateAnswer, targetRole } = req.body;
      const result = await this.interviewService.evaluateAnswer(
        userId,
        sessionId,
        questionId,
        questionText,
        candidateAnswer,
        targetRole
      );
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };

  getHistory = async (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): Promise<void> => {
    try {
      const userId = req.user!.userId;
      const result = await this.interviewService.getInterviewHistory(userId);
      sendSuccess(res, result, 200);
    } catch (err) {
      next(err);
    }
  };
}
