import { ApplicationService } from '../src/services/application.service';
import { ApplicationRepository } from '../src/repositories/application.repository';
import { ApplicationStatus } from '@prisma/client';
import { NotFoundError, UnauthorizedError } from '../src/utils/errors';

describe('Application Lifecycle & Pipeline Analytics Tests', () => {
  let mockAppRepo: jest.Mocked<Partial<ApplicationRepository>>;
  let appService: ApplicationService;

  beforeEach(() => {
    mockAppRepo = {
      findByUserId: jest.fn().mockResolvedValue([]),
      findById: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockImplementation((data) =>
        Promise.resolve({
          id: 'app_created_1',
          ...data,
          appliedAt: new Date(),
        })
      ),
      updateStatus: jest.fn().mockImplementation((id, status, notes) =>
        Promise.resolve({
          id,
          userId: 'usr_test_1',
          jobId: 'job_01',
          status,
          notes: notes || 'Updated notes',
          appliedAt: new Date(),
        })
      ),
      updateNotes: jest.fn().mockImplementation((id, notes) =>
        Promise.resolve({
          id,
          userId: 'usr_test_1',
          jobId: 'job_01',
          status: ApplicationStatus.APPLIED,
          notes,
          appliedAt: new Date(),
        })
      ),
      delete: jest.fn().mockResolvedValue({
        id: 'app_test_1',
        userId: 'usr_test_1',
        jobId: 'job_01',
        status: ApplicationStatus.APPLIED,
        notes: null,
        appliedAt: new Date(),
      }),
    };

    appService = new ApplicationService(mockAppRepo as unknown as ApplicationRepository);
  });

  it('should return initial starter applications when database has no records', async () => {
    const apps = await appService.getUserApplications('usr_test_1');
    expect(apps.length).toBeGreaterThan(0);
    expect(apps[0].id).toBe('app_01');
    expect(apps[0].job.company).toBe('Axious Labs');
  });

  it('should create a new job application record', async () => {
    const input = {
      jobId: 'f47ac10b-58cc-4372-a567-0e02b2c3d479',
      status: 'APPLIED' as const,
      notes: 'Applied through company portal with tailored AI engineer resume.',
    };

    const created = await appService.createApplication('usr_test_1', input);
    expect(created.id).toBe('app_created_1');
    expect(created.status).toBe(ApplicationStatus.APPLIED);
    expect(mockAppRepo.create).toHaveBeenCalled();
  });

  it('should update application status and notes in repository', async () => {
    (mockAppRepo.findById as jest.Mock).mockResolvedValue({
      id: 'app_real_1',
      userId: 'usr_test_1',
      jobId: 'job_01',
      status: ApplicationStatus.APPLIED,
      notes: 'Initial',
      appliedAt: new Date(),
    });

    const updated = await appService.updateStatus(
      'usr_test_1',
      'app_real_1',
      ApplicationStatus.INTERVIEWING,
      'Scheduled Round 1 with Lead Architect Ravi Prakash'
    );

    expect(updated.status).toBe(ApplicationStatus.INTERVIEWING);
    expect(mockAppRepo.updateStatus).toHaveBeenCalledWith(
      'app_real_1',
      ApplicationStatus.INTERVIEWING,
      'Scheduled Round 1 with Lead Architect Ravi Prakash'
    );
  });

  it('should prevent updating another user application', async () => {
    (mockAppRepo.findById as jest.Mock).mockResolvedValue({
      id: 'app_other_user',
      userId: 'usr_other',
      jobId: 'job_01',
      status: ApplicationStatus.APPLIED,
      notes: '',
      appliedAt: new Date(),
    });

    await expect(
      appService.updateStatus(
        'usr_test_1',
        'app_other_user',
        ApplicationStatus.INTERVIEWING
      )
    ).rejects.toThrow(UnauthorizedError);
  });

  it('should update application notes successfully', async () => {
    (mockAppRepo.findById as jest.Mock).mockResolvedValue({
      id: 'app_notes_1',
      userId: 'usr_test_1',
      jobId: 'job_01',
      status: ApplicationStatus.APPLIED,
      notes: 'Old notes',
      appliedAt: new Date(),
    });

    const updated = await appService.updateNotes(
      'usr_test_1',
      'app_notes_1',
      'Followed up with recruiter on LinkedIn.'
    );

    expect(updated.notes).toBe('Followed up with recruiter on LinkedIn.');
    expect(mockAppRepo.updateNotes).toHaveBeenCalledWith(
      'app_notes_1',
      'Followed up with recruiter on LinkedIn.'
    );
  });

  it('should delete an application record', async () => {
    (mockAppRepo.findById as jest.Mock).mockResolvedValue({
      id: 'app_del_1',
      userId: 'usr_test_1',
      jobId: 'job_01',
      status: ApplicationStatus.REJECTED,
      notes: null,
      appliedAt: new Date(),
    });

    const result = await appService.deleteApplication('usr_test_1', 'app_del_1');
    expect(result.id).toBe('app_del_1');
    expect(mockAppRepo.delete).toHaveBeenCalledWith('app_del_1');
  });

  it('should compute comprehensive pipeline analytics and insights', async () => {
    const analytics = await appService.getApplicationAnalytics('usr_test_1');

    expect(analytics.totalApplications).toBeGreaterThan(0);
    expect(analytics.countsByStatus).toHaveProperty('INTERVIEWING');
    expect(analytics.countsByStatus).toHaveProperty('OFFER');
    expect(analytics.interviewRatePercentage).toBeGreaterThan(0);
    expect(analytics.offerRatePercentage).toBeGreaterThanOrEqual(0);
    expect(analytics.responseRatePercentage).toBeGreaterThan(0);
    expect(analytics.insights.length).toBeGreaterThan(0);
    expect(analytics.recentActivity.length).toBeGreaterThan(0);
  });
});
