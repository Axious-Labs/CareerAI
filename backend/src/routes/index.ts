import { Router } from 'express';
import { authRouter } from './auth.routes';
import { userRouter } from './user.routes';
import { skillRouter } from './skill.routes';
import { resumeRouter } from './resume.routes';
import { jobRouter } from './job.routes';
import { applicationRouter } from './application.routes';
import { chatRouter } from './chat.routes';
import { careerRouter } from './career.routes';

const apiRouter = Router();

apiRouter.use('/auth', authRouter);
apiRouter.use('/users', userRouter);
apiRouter.use('/skills', skillRouter);
apiRouter.use('/resumes', resumeRouter);
apiRouter.use('/jobs', jobRouter);
apiRouter.use('/applications', applicationRouter);
apiRouter.use('/chat', chatRouter);
apiRouter.use('/career', careerRouter);

export { apiRouter };
