import { z } from 'zod';

export const goalCategoryEnum = z.enum([
  'SKILL_ACQUISITION',
  'APPLICATION_TARGET',
  'INTERVIEW_PRACTICE',
  'PORTFOLIO_PROJECT',
]);

export const goalStatusEnum = z.enum(['ACTIVE', 'COMPLETED', 'PAUSED']);

export const createMilestoneItemSchema = z.object({
  title: z.string().min(2, 'Milestone title is required'),
});

export const createGoalSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  description: z.string().min(5, 'Description must be at least 5 characters'),
  category: goalCategoryEnum,
  targetDate: z.string().optional(),
  milestones: z.array(createMilestoneItemSchema).optional(),
});

export const updateGoalProgressSchema = z.object({
  progressPercentage: z.number().min(0).max(100),
  status: goalStatusEnum.optional(),
});

export const addMilestoneSchema = z.object({
  title: z.string().min(2, 'Milestone title must be at least 2 characters'),
});

export type CreateGoalInput = z.infer<typeof createGoalSchema>;
export type UpdateGoalProgressInput = z.infer<typeof updateGoalProgressSchema>;
export type AddMilestoneInput = z.infer<typeof addMilestoneSchema>;
export type GoalCategory = z.infer<typeof goalCategoryEnum>;
export type GoalStatus = z.infer<typeof goalStatusEnum>;
