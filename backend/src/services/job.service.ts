import { JobRepository } from '../repositories/job.repository';
import { CreateJobInput } from '../schemas/job.schema';
import { NotFoundError } from '../utils/errors';

export class JobService {
  constructor(private jobRepo: JobRepository) {}

  async getJobs(roleFilter?: string) {
    const jobs = await this.jobRepo.findAll(roleFilter);
    if (jobs.length === 0) {
      // Return default starter jobs for early-career developers
      return [
        {
          id: 'job_01',
          title: 'Junior AI Engineer',
          company: 'Axious Labs',
          location: 'Remote',
          description: 'Help build next-generation career intelligence models and RAG workflows.',
          matchScore: 88,
          sourceUrl: 'https://careers.axiouslabs.org/jobs/1',
        },
        {
          id: 'job_02',
          title: 'Associate Machine Learning Engineer',
          company: 'TechFlow Systems',
          location: 'San Francisco, CA (Hybrid)',
          description: 'Develop data pipelines, fine-tune open weights LLMs, and optimize inference latency.',
          matchScore: 82,
          sourceUrl: 'https://careers.techflow.io/jobs/ml-assoc',
        },
        {
          id: 'job_03',
          title: 'Junior Full-Stack & AI Developer',
          company: 'Nexus Innovations',
          location: 'Remote',
          description: 'Build modern Flutter frontends and TypeScript backends powered by generative AI.',
          matchScore: 76,
          sourceUrl: 'https://nexusinnovations.tech/jobs/fullstack-ai',
        },
      ];
    }
    return jobs.map((job) => ({
      ...job,
      matchScore: 80,
    }));
  }

  async getJobById(id: string) {
    const job = await this.jobRepo.findById(id);
    if (!job) {
      throw new NotFoundError('Job not found');
    }
    return job;
  }

  async createJob(input: CreateJobInput) {
    return this.jobRepo.create({
      title: input.title,
      company: input.company,
      location: input.location,
      description: input.description,
      sourceUrl: input.sourceUrl,
    });
  }
}
