import { z } from 'zod';

export const careerAnalyzeSchema = z.object({
  targetRole: z.string().optional(),
});

export const skillGapSchema = z.object({
  targetRole: z.string().min(2, 'Target role is required'),
});

export const roadmapSchema = z.object({
  targetRole: z.string().min(2, 'Target role is required'),
  timelineWeeks: z.number().int().min(1).max(52).optional().default(8),
});

export type CareerAnalyzeInput = z.infer<typeof careerAnalyzeSchema>;
export type SkillGapInput = z.infer<typeof skillGapSchema>;
export type RoadmapInput = z.infer<typeof roadmapSchema>;
