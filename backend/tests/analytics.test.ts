import { AnalyticsService } from '../src/services/analytics.service';
import { AnalyticsRepository } from '../src/repositories/analytics.repository';

describe('Platform Analytics & Market Intelligence Service Tests', () => {
  let analyticsRepo: AnalyticsRepository;
  let analyticsService: AnalyticsService;

  beforeEach(() => {
    analyticsRepo = new AnalyticsRepository();
    analyticsService = new AnalyticsService(analyticsRepo);
  });

  it('should calculate platform overview metrics for a user', async () => {
    const overview = await analyticsService.getOverview('usr_test_lead');
    expect(overview.userId).toBe('usr_test_lead');
    expect(overview.profileReadinessScore).toBeGreaterThan(0);
    expect(overview.marketDemandScore).toBeGreaterThan(80);
    expect(overview.hiringVelocity).toBe('ACCELERATING');
    expect(overview.recentActivitySummary.skillsVerified).toBeGreaterThan(0);
  });

  it('should retrieve market trends for all tech roles', async () => {
    const trends = (await analyticsService.getMarketTrends()) as any[];
    expect(trends.length).toBeGreaterThanOrEqual(4);
    expect(trends[0].demandScore).toBeDefined();
    expect(trends[0].topRequestedSkills.length).toBeGreaterThan(0);
  });

  it('should retrieve market trends for a specific role', async () => {
    const trend = (await analyticsService.getMarketTrends('Backend Engineer')) as any;
    expect(trend).toBeDefined();
    expect(trend.role).toBe('Backend Engineer');
    expect(trend.topRequestedSkills).toContain('TypeScript');
  });

  it('should calculate salary benchmarks for an AI/ML Engineer with skills premium', async () => {
    const benchmark = await analyticsService.calculateSalaryBenchmark({
      role: 'AI/ML Engineer',
      level: 'SENIOR',
      skills: ['LangGraph', 'PyTorch'],
    });

    expect(benchmark.role).toBe('AI/ML Engineer');
    expect(benchmark.level).toBe('SENIOR');
    expect(benchmark.baseSalaryRange.min).toBeGreaterThan(150000);
    expect(benchmark.baseSalaryRange.median).toBe(220000);
    expect(benchmark.baseSalaryRange.currency).toBe('USD');
    expect(benchmark.bonusEstimate.estimatedBonusUSD).toBeGreaterThan(0);
    expect(benchmark.skillsPremium.length).toBe(2);
    expect(benchmark.skillsPremium[0].estimatedValueBoostPercentage).toBe(12);
  });

  it('should calculate application funnel conversion metrics', async () => {
    const funnel = await analyticsService.getApplicationFunnel(20);
    expect(funnel.length).toBe(4);
    expect(funnel[0].stage).toBe('Applied');
    expect(funnel[0].count).toBe(20);
    expect(funnel[0].conversionRatePercentage).toBe(100);

    const offers = funnel.find((f) => f.stage === 'Offers');
    expect(offers).toBeDefined();
    expect(offers!.count).toBeGreaterThan(0);
  });
});

