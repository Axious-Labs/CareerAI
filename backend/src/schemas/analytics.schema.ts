import { z } from 'zod';

export const seniorityLevelEnum = z.enum([
  'ENTRY',
  'JUNIOR',
  'MID',
  'SENIOR',
  'LEAD',
  'PRINCIPAL',
]);

export const timeframeEnum = z.enum(['WEEK', 'MONTH', 'QUARTER', 'YEAR', 'ALL']);

export const salaryBenchmarkQuerySchema = z.object({
  role: z.string().min(2, 'Target role is required'),
  level: seniorityLevelEnum,
  location: z.string().optional(),
  skills: z.array(z.string()).optional(),
});

export const analyticsQuerySchema = z.object({
  timeframe: timeframeEnum.default('MONTH').optional(),
  role: z.string().optional(),
});

export type SalaryBenchmarkQueryInput = z.infer<typeof salaryBenchmarkQuerySchema>;
export type AnalyticsQueryInput = z.infer<typeof analyticsQuerySchema>;
export type SeniorityLevel = z.infer<typeof seniorityLevelEnum>;
export type Timeframe = z.infer<typeof timeframeEnum>;

