import { ApplicationRepository } from '../repositories/application.repository';
import { CreateApplicationInput } from '../schemas/application.schema';
import { ApplicationStatus } from '@prisma/client';
import { NotFoundError, UnauthorizedError } from '../utils/errors';

export interface ApplicationAnalytics {
  totalApplications: number;
  activeApplications: number;
  countsByStatus: Record<string, number>;
  interviewRatePercentage: number;
  offerRatePercentage: number;
  responseRatePercentage: number;
  insights: string[];
  recentActivity: Array<{
    id: string;
    jobTitle: string;
    company: string;
    status: string;
    date: string;
  }>;
}

export class ApplicationService {
  private static readonly DEFAULT_MOCK_APPS = [
    {
      id: 'app_01',
      jobId: 'job_01',
      userId: 'usr_default',
      status: ApplicationStatus.INTERVIEWING,
      appliedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
      notes: 'Completed initial screening interview with Axious Labs team lead Ravi Prakash.',
      job: {
        id: 'job_01',
        title: 'Junior AI Engineer',
        company: 'Axious Labs',
        location: 'Remote',
      },
    },
    {
      id: 'app_02',
      jobId: 'job_02',
      userId: 'usr_default',
      status: ApplicationStatus.APPLIED,
      appliedAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
      notes: 'Submitted resume highlighting Python and LangGraph experience.',
      job: {
        id: 'job_02',
        title: 'Associate Machine Learning Engineer',
        company: 'TechFlow Systems',
        location: 'San Francisco, CA (Hybrid)',
      },
    },
    {
      id: 'app_03',
      jobId: 'job_03',
      userId: 'usr_default',
      status: ApplicationStatus.OFFER,
      appliedAt: new Date(Date.now() - 14 * 24 * 60 * 60 * 1000),
      notes: 'Received offer for junior fullstack AI engineering role.',
      job: {
        id: 'job_03',
        title: 'Junior Full-Stack & AI Developer',
        company: 'Nexus Innovations',
        location: 'Remote',
      },
    },
  ];

  constructor(private appRepo: ApplicationRepository) {}

  async getUserApplications(userId: string) {
    const apps = await this.appRepo.findByUserId(userId);
    if (apps.length === 0) {
      return ApplicationService.DEFAULT_MOCK_APPS;
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

  async updateStatus(
    userId: string,
    applicationId: string,
    status: ApplicationStatus,
    notes?: string
  ) {
    const app = await this.appRepo.findById(applicationId);
    if (!app) {
      const mockIndex = ApplicationService.DEFAULT_MOCK_APPS.findIndex(
        (a) => a.id === applicationId
      );
      if (mockIndex !== -1) {
        return {
          ...ApplicationService.DEFAULT_MOCK_APPS[mockIndex],
          status,
          ...(notes !== undefined ? { notes } : {}),
        };
      }
      throw new NotFoundError('Application not found');
    }

    if (app.userId !== userId) {
      throw new UnauthorizedError('Unauthorized to update this application');
    }

    return this.appRepo.updateStatus(applicationId, status, notes);
  }

  async updateNotes(userId: string, applicationId: string, notes: string) {
    const app = await this.appRepo.findById(applicationId);
    if (!app) {
      const mockIndex = ApplicationService.DEFAULT_MOCK_APPS.findIndex(
        (a) => a.id === applicationId
      );
      if (mockIndex !== -1) {
        return {
          ...ApplicationService.DEFAULT_MOCK_APPS[mockIndex],
          notes,
        };
      }
      throw new NotFoundError('Application not found');
    }

    if (app.userId !== userId) {
      throw new UnauthorizedError('Unauthorized to update this application');
    }

    return this.appRepo.updateNotes(applicationId, notes);
  }

  async deleteApplication(userId: string, applicationId: string) {
    const app = await this.appRepo.findById(applicationId);
    if (!app) {
      const mockExists = ApplicationService.DEFAULT_MOCK_APPS.some(
        (a) => a.id === applicationId
      );
      if (mockExists) {
        return { id: applicationId, message: 'Application removed' };
      }
      throw new NotFoundError('Application not found');
    }

    if (app.userId !== userId) {
      throw new UnauthorizedError('Unauthorized to delete this application');
    }

    await this.appRepo.delete(applicationId);
    return { id: applicationId, message: 'Application successfully deleted' };
  }

  async getApplicationAnalytics(userId: string): Promise<ApplicationAnalytics> {
    const apps = await this.getUserApplications(userId);
    const total = apps.length;

    const counts: Record<string, number> = {
      APPLIED: 0,
      REVIEWING: 0,
      INTERVIEWING: 0,
      OFFER: 0,
      REJECTED: 0,
    };

    apps.forEach((a: any) => {
      const s = a.status as string;
      if (counts[s] !== undefined) {
        counts[s]++;
      } else {
        counts[s] = 1;
      }
    });

    const interviewingCount = counts.INTERVIEWING || 0;
    const offerCount = counts.OFFER || 0;
    const reviewingCount = counts.REVIEWING || 0;
    const active = total - (counts.REJECTED || 0);

    const interviewRate = total > 0 ? Math.round(((interviewingCount + offerCount) / total) * 100) : 0;
    const offerRate = total > 0 ? Math.round((offerCount / total) * 100) : 0;
    const responseRate = total > 0 ? Math.round(((total - (counts.APPLIED || 0)) / total) * 100) : 0;

    const insights: string[] = [];
    if (interviewRate >= 30) {
      insights.push('Strong interview conversion rate! Your resume and technical background are resonating well.');
    } else {
      insights.push('Consider tailoring your resume for specific job keywords to improve interview callback rates.');
    }

    if (offerCount > 0) {
      insights.push(`Congratulations on securing ${offerCount} offer! Evaluate compensation and growth opportunities.`);
    }

    if (counts.APPLIED > 3) {
      insights.push('Follow up on applications submitted over 10 days ago to show continued interest.');
    }

    const recentActivity = apps.slice(0, 5).map((a: any) => ({
      id: a.id,
      jobTitle: a.job?.title || 'Engineering Role',
      company: a.job?.company || 'Company',
      status: a.status,
      date: typeof a.appliedAt === 'string' ? a.appliedAt : a.appliedAt?.toISOString?.() || new Date().toISOString(),
    }));

    return {
      totalApplications: total,
      activeApplications: active,
      countsByStatus: counts,
      interviewRatePercentage: interviewRate,
      offerRatePercentage: offerRate,
      responseRatePercentage: responseRate,
      insights,
      recentActivity,
    };
  }
}
