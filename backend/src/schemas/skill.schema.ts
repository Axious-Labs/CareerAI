import { z } from 'zod';

export const addSkillSchema = z.object({
  skillId: z.string().uuid('Valid skillId required'),
  proficiency: z.enum(['BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT']).default('INTERMEDIATE'),
});

export const createSkillSchema = z.object({
  name: z.string().min(1, 'Skill name is required'),
  category: z.string().min(1, 'Category is required'),
});

export type AddSkillInput = z.infer<typeof addSkillSchema>;
export type CreateSkillInput = z.infer<typeof createSkillSchema>;
