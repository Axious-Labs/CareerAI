import { ApplicationRepository } from '../repositories/application.repository';
import { CreateApplicationInput } from '../schemas/application.schema';
import { ApplicationStatus } from '@prisma/client';

export class ApplicationService {
  constructor(private appRepo: ApplicationRepository) {}

  async getUserApplications(userId: string) {
    const apps = await this.appRepo.findByUserId(userId);
    if (apps.length === 0) {
      // Default initial mock application tracking for new users
      return [
        {
          id: 'app_01',
          jobId: 'job_01',
          status: 'INTERVIEWING',
          appliedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000).toISOString(),
          notes: 'Completed initial screening interview with Axious Labs team.',
          job: {
            title: 'Junior AI Engineer',
            company: 'Axious Labs',
            location: 'Remote',
          },
        },
        {
          id: 'app_02',
          jobId: 'job_02',
          status: 'APPLIED',
          appliedAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
          notes: 'Submitted resume highlighting Python and LangGraph experience.',
          job: {
            title: 'Associate Machine Learning Engineer',
            company: 'TechFlow Systems',
            location: 'San Francisco, CA (Hybrid)',
          },
        },
      ];
    }
    return apps;
  }

  async createApplication(userId: string, input: CreateApplicationInput) {
    return this.appRepo.create({
      userId,
      jobId: input.jobId,
      status: (input.status as ApplicationStatus) || ApplicationStatus.APPLIED,
      notes: input.notes,
    });
  }
}
