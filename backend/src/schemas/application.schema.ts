import { z } from 'zod';

export const createApplicationSchema = z.object({
  jobId: z.string().uuid('Valid jobId required'),
  status: z.enum(['APPLIED', 'REVIEWING', 'INTERVIEWING', 'OFFER', 'REJECTED']).default('APPLIED'),
  notes: z.string().optional(),
});

export type CreateApplicationInput = z.infer<typeof createApplicationSchema>;
