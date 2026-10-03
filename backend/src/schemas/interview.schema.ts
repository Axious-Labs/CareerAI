import { z } from 'zod';

export const difficultyEnum = z.enum(['JUNIOR', 'MID', 'SENIOR', 'LEAD']);

export const startInterviewSchema = z.object({
  targetRole: z.string().min(2).optional(),
  difficulty: difficultyEnum.optional().default('MID'),
  skillFocus: z.string().optional(),
  questionCount: z.number().int().min(1).max(10).optional().default(5),
});

export const evaluateAnswerSchema = z.object({
  sessionId: z.string().min(1, 'Session ID is required'),
  questionId: z.string().min(1, 'Question ID is required'),
  questionText: z.string().min(3, 'Question text is required'),
  candidateAnswer: z.string().min(5, 'Candidate answer must be at least 5 characters'),
  targetRole: z.string().optional(),
});

export const interviewHistoryQuerySchema = z.object({
  targetRole: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(50).optional().default(10),
});

export type StartInterviewInput = z.infer<typeof startInterviewSchema>;
export type EvaluateAnswerInput = z.infer<typeof evaluateAnswerSchema>;
export type InterviewHistoryQueryInput = z.infer<typeof interviewHistoryQuerySchema>;
