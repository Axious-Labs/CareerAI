import { z } from 'zod';

export const createJobSchema = z.object({
  title: z.string().min(2),
  company: z.string().min(2),
  location: z.string().min(2),
  description: z.string().min(10),
  sourceUrl: z.string().url().optional(),
});

export const searchJobSchema = z.object({
  query: z.string().optional(),
  location: z.string().optional(),
  jobType: z.string().optional(),
});

export type CreateJobInput = z.infer<typeof createJobSchema>;
export type SearchJobQuery = z.infer<typeof searchJobSchema>;
