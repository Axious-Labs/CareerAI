import { JobRepository } from '../repositories/job.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { CreateJobInput } from '../schemas/job.schema';
import { NotFoundError } from '../utils/errors';

export interface JobMatchAnalysis {
  jobId: string;
  jobTitle: string;
  company: string;
  matchScore: number;
  matchedSkills: string[];
  missingSkills: string[];
  recommendedPreparation: string[];
  recommendationReason: string;
}

export class JobService {
  private static readonly STARTER_JOBS = [
    {
      id: 'job_01',
      title: 'Junior AI Engineer',
      company: 'Axious Labs',
      location: 'Remote',
      description: 'Help build next-generation career intelligence models and RAG workflows with Python, PyTorch, and LangGraph.',
      matchScore: 92,
      sourceUrl: 'https://careers.axiouslabs.org/jobs/1',
      requiredSkills: ['Python', 'GenAI', 'ML', 'RAG'],
    },
    {
      id: 'job_02',
      title: 'Associate Machine Learning Engineer',
      company: 'TechFlow Systems',
      location: 'San Francisco, CA (Hybrid)',
      description: 'Develop data pipelines, fine-tune open weights LLMs, and optimize inference latency using Python and Docker.',
      matchScore: 84,
      sourceUrl: 'https://careers.techflow.io/jobs/ml-assoc',
      requiredSkills: ['Python', 'ML', 'Docker', 'Transformers'],
    },
    {
      id: 'job_03',
      title: 'Junior Full-Stack & AI Developer',
      company: 'Nexus Innovations',
      location: 'Remote',
      description: 'Build modern Flutter frontends and TypeScript backends powered by generative AI.',
      matchScore: 78,
      sourceUrl: 'https://nexusinnovations.tech/jobs/fullstack-ai',
      requiredSkills: ['Flutter', 'TypeScript', 'GenAI', 'PostgreSQL'],
    },
    {
      id: 'job_04',
      title: 'AI Systems Integration Intern',
      company: 'Cognitive Matrix',
      location: 'New York, NY (Hybrid)',
      description: 'Assist in deploying vector search databases and autonomous agents with LangGraph.',
      matchScore: 75,
      sourceUrl: 'https://careers.cognitivematrix.io/interns',
      requiredSkills: ['Python', 'Agents', 'Vector Search'],
    },
  ];

  constructor(
    private jobRepo: JobRepository,
    private skillRepo?: SkillRepository
  ) {}

  async getJobs(roleFilter?: string) {
    const jobs = await this.jobRepo.findAll(roleFilter);
    if (jobs.length === 0) {
      if (roleFilter) {
        const lowerFilter = roleFilter.toLowerCase();
        const filtered = JobService.STARTER_JOBS.filter(
          (j) =>
            j.title.toLowerCase().includes(lowerFilter) ||
            j.description.toLowerCase().includes(lowerFilter)
        );
        return filtered.length > 0 ? filtered : JobService.STARTER_JOBS;
      }
      return JobService.STARTER_JOBS;
    }
    return jobs.map((job) => ({
      ...job,
      matchScore: 80,
    }));
  }

  async getJobById(id: string) {
    const job = await this.jobRepo.findById(id);
    if (!job) {
      const starter = JobService.STARTER_JOBS.find((j) => j.id === id);
      if (starter) {
        return starter;
      }
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

  async getRecommendedJobs(userId: string) {
    let candidateSkills: string[] = ['Python', 'GenAI', 'Flutter', 'ML'];
    if (this.skillRepo) {
      try {
        const userSkills = await this.skillRepo.getUserSkills(userId);
        if (userSkills && userSkills.length > 0) {
          candidateSkills = userSkills.map((us) => us.skill.name);
        }
      } catch {
        // Fallback to candidateSkills
      }
    }

    const allJobs = await this.getJobs();

    return allJobs
      .map((job: any) => {
        const required: string[] =
          job.requiredSkills || this.extractRequiredSkills(job.title + ' ' + job.description);
        const matched = required.filter((req) =>
          candidateSkills.some((s) => s.toLowerCase() === req.toLowerCase())
        );
        const missing = required.filter(
          (req) => !candidateSkills.some((s) => s.toLowerCase() === req.toLowerCase())
        );

        const matchRate = required.length > 0 ? matched.length / required.length : 0.7;
        const calculatedScore = Math.min(
          98,
          Math.max(65, Math.round(65 + matchRate * 30))
        );

        return {
          ...job,
          matchScore: calculatedScore,
          matchedSkills: matched,
          missingSkills: missing,
          recommendationReason: `Matches ${matched.length} of ${required.length} key required skills (${matched.join(', ') || 'foundation'}).`,
        };
      })
      .sort((a: any, b: any) => b.matchScore - a.matchScore);
  }

  async getJobMatchDetails(userId: string, jobId: string): Promise<JobMatchAnalysis> {
    const job = await this.getJobById(jobId);
    let candidateSkills: string[] = ['Python', 'GenAI', 'Flutter'];
    if (this.skillRepo) {
      try {
        const userSkills = await this.skillRepo.getUserSkills(userId);
        if (userSkills && userSkills.length > 0) {
          candidateSkills = userSkills.map((us) => us.skill.name);
        }
      } catch {
        // Fallback
      }
    }

    const jobWithSkills = job as any;
    const required: string[] =
      jobWithSkills.requiredSkills || this.extractRequiredSkills(job.title + ' ' + job.description);
    const matched = required.filter((req) =>
      candidateSkills.some((s) => s.toLowerCase() === req.toLowerCase())
    );
    const missing = required.filter(
      (req) => !candidateSkills.some((s) => s.toLowerCase() === req.toLowerCase())
    );

    const matchRate = required.length > 0 ? matched.length / required.length : 0.7;
    const score = Math.min(98, Math.max(60, Math.round(60 + matchRate * 35)));

    return {
      jobId: job.id,
      jobTitle: job.title,
      company: job.company,
      matchScore: score,
      matchedSkills: matched,
      missingSkills: missing,
      recommendedPreparation: missing.map(
        (skill) => `Review ${skill} architecture fundamentals and hands-on production patterns.`
      ),
      recommendationReason: `You have strong foundations in ${matched.join(', ')}. Addressing ${missing.join(', ') || 'advanced topics'} will make you a top candidate.`,
    };
  }

  async searchJobs(query?: string, location?: string, jobType?: string) {
    try {
      const dbJobs = await this.jobRepo.search(query, location);
      if (dbJobs.length > 0) {
        return dbJobs;
      }
    } catch {
      // Fallback to starter jobs
    }

    let results = [...JobService.STARTER_JOBS];
    if (query) {
      const q = query.toLowerCase();
      results = results.filter(
        (j) =>
          j.title.toLowerCase().includes(q) ||
          j.description.toLowerCase().includes(q) ||
          j.company.toLowerCase().includes(q)
      );
    }
    if (location) {
      const loc = location.toLowerCase();
      results = results.filter((j) => j.location.toLowerCase().includes(loc));
    }
    if (jobType && jobType.toLowerCase() === 'remote') {
      results = results.filter((j) => j.location.toLowerCase().includes('remote'));
    }
    return results;
  }

  private extractRequiredSkills(text: string): string[] {
    const knownSkills = [
      'Python',
      'PyTorch',
      'TypeScript',
      'Flutter',
      'GenAI',
      'ML',
      'Docker',
      'PostgreSQL',
      'RAG',
      'LangGraph',
      'Transformers',
      'Agents',
    ];
    const found = knownSkills.filter((s) =>
      text.toLowerCase().includes(s.toLowerCase())
    );
    return found.length > 0 ? found : ['Python', 'System Architecture'];
  }
}
