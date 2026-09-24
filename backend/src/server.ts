import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import swaggerUi from 'swagger-ui-express';
import { env } from './config/env';
import { swaggerSpec } from './config/swagger';
import { apiRouter } from './routes';
import { errorHandler } from './middleware/error.middleware';
import { requestLogger } from './middleware/logger.middleware';
import { logger } from './utils/logger';

const app = express();

// Security & Utility Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('combined'));
app.use(requestLogger);

// Swagger Documentation UI
app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Health Check Endpoint
app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'CareerAI Backend Gateway',
    version: '1.0.0',
    organization: 'Axious Labs',
  });
});

// Mount API Gateway v1
app.use('/api/v1', apiRouter);

// Centralized Error Handler
app.use(errorHandler);

const server = app.listen(env.PORT, () => {
  logger.info(`🚀 CareerAI Backend Gateway running on port ${env.PORT}`);
  logger.info(`📚 Swagger Documentation available at http://localhost:${env.PORT}/docs`);
});

// Graceful Shutdown
const handleShutdown = () => {
  logger.info('Shutting down CareerAI Backend Gateway gracefully...');
  server.close(() => {
    logger.info('Server closed. Process terminating.');
    process.exit(0);
  });
};

process.on('SIGTERM', handleShutdown);
process.on('SIGINT', handleShutdown);

export default app;
