import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../../../.env') });

export const env = {
  PORT: process.env.PORT ? parseInt(process.env.PORT, 10) : 5000,
  NODE_ENV: process.env.NODE_ENV || 'development',
  DATABASE_URL: process.env.DATABASE_URL || 'postgresql://careerai:careerai_secret@localhost:5432/careerai_db?schema=public',
  JWT_SECRET: process.env.JWT_SECRET || 'careerai_default_jwt_secret_change_in_production_32_chars',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '7d',
  AI_SERVICE_URL: process.env.AI_SERVICE_URL || 'http://localhost:8001',
  AGENT_SERVICE_URL: process.env.AGENT_SERVICE_URL || 'http://localhost:8002',
  REDIS_URL: process.env.REDIS_URL || 'redis://localhost:6379',
};
