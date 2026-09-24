import { z } from 'zod';

export const chatMessageSchema = z.object({
  message: z.string().min(1, 'Message cannot be empty'),
  conversationId: z.string().optional(),
});

export type ChatMessageInput = z.infer<typeof chatMessageSchema>;
