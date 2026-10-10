import { JobService } from '../src/services/job.service';
import { JobRepository } from '../src/repositories/job.repository';
import { SkillRepository } from '../src/repositories/skill.repository';

describe('Job Intelligence & Recommendation Service Tests', () => {
  let mockJobRepo: jest.Mocked<Partial<JobRepository>>;
  let mockSkillRepo: jest.Mocked<Partial<SkillRepository>>;
  let jobService: JobService;

  beforeEach(() => {
    mockJobRepo = {
      findAll: jest.fn().mockResolvedValue([]),
      findById: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((data) =>
        Promise.resolve({
          id: 'job_created_1',
          ...data,
          createdAt: new Date(),
        })
      ),
      search: jest.fn().mockResolvedValue([]),
    };

    mockSkillRepo = {
      getUserSkills: jest.fn().mockResolvedValue([
        { skillId: 'sk_1', skill: { name: 'Python', category: 'Backend' } },
        { skillId: 'sk_2', skill: { name: 'GenAI', category: 'AI' } },
        { skillId: 'sk_3', skill: { name: 'RAG', category: 'AI' } },
      ] as any),
    };

    jobService = new JobService(
      mockJobRepo as unknown as JobRepository,
      mockSkillRepo as unknown as SkillRepository
    );
  });

  it('should return starter jobs when database has no jobs', async () => {
    const jobs = await jobService.getJobs();
    expect(jobs.length).toBeGreaterThan(0);
    expect(jobs[0].title).toBe('Junior AI Engineer');
    expect(jobs[0].company).toBe('Axious Labs');
  });

  it('should filter starter jobs by role keyword', async () => {
    const jobs = await jobService.getJobs('Machine Learning');
    expect(jobs.length).toBeGreaterThan(0);
    expect(jobs[0].title).toContain('Machine Learning');
  });

  it('should compute personalized job recommendations with match scores and skill gaps', async () => {
    const recommendations = await jobService.getRecommendedJobs('usr_test_123');

    expect(recommendations.length).toBeGreaterThan(0);
    const topJob = recommendations[0];
    expect(topJob.matchScore).toBeGreaterThanOrEqual(65);
    expect(topJob.matchedSkills).toContain('Python');
    expect(topJob.recommendationReason).toBeDefined();
    // Recommendations should be sorted descending by matchScore
    for (let i = 0; i < recommendations.length - 1; i++) {
      expect(recommendations[i].matchScore).toBeGreaterThanOrEqual(
        recommendations[i + 1].matchScore
      );
    }
  });

  it('should provide detailed match breakdown for a specific job', async () => {
    const matchAnalysis = await jobService.getJobMatchDetails('usr_test_123', 'job_01');

    expect(matchAnalysis.jobId).toBe('job_01');
    expect(matchAnalysis.matchScore).toBeGreaterThanOrEqual(60);
    expect(matchAnalysis.matchedSkills).toContain('Python');
    expect(matchAnalysis.recommendedPreparation.length).toBeGreaterThanOrEqual(0);
    expect(matchAnalysis.recommendationReason).toContain('strong foundations');
  });

  it('should search jobs by query keyword and location', async () => {
    const results = await jobService.searchJobs('Full-Stack', 'Remote');
    expect(results.length).toBeGreaterThan(0);
    expect(results[0].title).toContain('Full-Stack');
    expect(results[0].location).toContain('Remote');
  });

  it('should create a new job posting', async () => {
    const input = {
      title: 'Senior Agentic AI Engineer',
      company: 'Axious Labs',
      location: 'Remote',
      description: 'Architect multi-agent autonomous collaboration systems.',
      sourceUrl: 'https://careers.axiouslabs.org/jobs/lead-ai',
    };

    const created = await jobService.createJob(input);
    expect(created.id).toBe('job_created_1');
    expect(created.title).toBe(input.title);
    expect(mockJobRepo.create).toHaveBeenCalledWith(input);
  });
});
