import { z } from 'zod';

export const learningDifficultyEnum = z.enum([
  'BEGINNER',
  'INTERMEDIATE',
  'ADVANCED',
]);

export const learningCategoryEnum = z.enum([
  'GEN_AI',
  'BACKEND',
  'FRONTEND',
  'DEVOPS',
  'SYSTEM_DESIGN',
]);

export const learningModuleItemSchema = z.object({
  title: z.string().min(3, 'Module title is required'),
  durationMinutes: z.number().min(5),
  externalUrl: z.string().optional(),
});

export const createCourseSchema = z.object({
  title: z.string().min(3, 'Course title must be at least 3 characters'),
  description: z.string().min(10, 'Course description must be at least 10 characters'),
  category: learningCategoryEnum,
  difficulty: learningDifficultyEnum,
  estimatedHours: z.number().min(1),
  skillsCovered: z.array(z.string()).min(1),
  modules: z.array(learningModuleItemSchema).min(1),
});

export const updateModuleProgressSchema = z.object({
  moduleId: z.string().min(1, 'Module ID is required'),
  completed: z.boolean(),
});

export const learningQuerySchema = z.object({
  category: learningCategoryEnum.optional(),
  difficulty: learningDifficultyEnum.optional(),
  skill: z.string().optional(),
});

export type CreateCourseInput = z.infer<typeof createCourseSchema>;
export type UpdateModuleProgressInput = z.infer<typeof updateModuleProgressSchema>;
export type LearningQueryInput = z.infer<typeof learningQuerySchema>;
export type LearningDifficulty = z.infer<typeof learningDifficultyEnum>;
export type LearningCategory = z.infer<typeof learningCategoryEnum>;

