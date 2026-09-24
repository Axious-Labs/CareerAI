import { z } from 'zod';

export const uploadResumeSchema = z.object({
  fileName: z.string().min(1, 'fileName is required'),
  fileUrl: z.string().url('Valid fileUrl is required'),
});

export type UploadResumeInput = z.infer<typeof uploadResumeSchema>;
