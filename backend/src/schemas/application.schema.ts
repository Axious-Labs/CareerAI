import { z } from 'zod';

export const createApplicationSchema = z.object({
  jobId: z.string().uuid('Valid jobId required'),
  status: z.enum(['APPLIED', 'REVIEWING', 'INTERVIEWING', 'OFFER', 'REJECTED']).default('APPLIED'),
  notes: z.string().optional(),
});

export const updateApplicationStatusSchema = z.object({
  status: z.enum(['APPLIED', 'REVIEWING', 'INTERVIEWING', 'OFFER', 'REJECTED']),
  notes: z.string().optional(),
});

export const updateApplicationNotesSchema = z.object({
  notes: z.string().min(1, 'Notes cannot be empty'),
});

export type CreateApplicationInput = z.infer<typeof createApplicationSchema>;
export type UpdateApplicationStatusInput = z.infer<typeof updateApplicationStatusSchema>;
export type UpdateApplicationNotesInput = z.infer<typeof updateApplicationNotesSchema>;
