import { AnalyticsRepository, RoleMarketInsight, ApplicationFunnelMetric } from '../repositories/analytics.repository';
import { SalaryBenchmarkQueryInput } from '../schemas/analytics.schema';

export interface SalaryBenchmarkResult {
  role: string;
  level: string;
  baseSalaryRange: {
    min: number;
    median: number;
    max: number;
    currency: string;
  };
  bonusEstimate: {
    medianBonusPercentage: number;
    estimatedBonusUSD: number;
  };
  skillsPremium: Array<{
    skill: string;
    estimatedValueBoostPercentage: number;
  }>;
  marketCompetitiveness: string;
}

export interface PlatformOverviewMetrics {
  userId: string;
  profileReadinessScore: number;
  activeApplicationsCount: number;
  interviewPassProbability: number;
  topTargetRole: string;
  marketDemandScore: number;
  hiringVelocity: string;
  recentActivitySummary: {
    interviewsCompleted: number;
    goalsAchieved: number;
    skillsVerified: number;
  };
}

export class AnalyticsService {
  constructor(private analyticsRepo: AnalyticsRepository) {}

  async getOverview(userId: string): Promise<PlatformOverviewMetrics> {
    const defaultInsight = await this.analyticsRepo.getInsightForRole('AI/ML Engineer');

    return {
      userId,
      profileReadinessScore: 88,
      activeApplicationsCount: 5,
      interviewPassProbability: 76,
      topTargetRole: defaultInsight?.role || 'AI/ML Engineer',
      marketDemandScore: defaultInsight?.demandScore || 95,
      hiringVelocity: defaultInsight?.hiringVelocity || 'ACCELERATING',
      recentActivitySummary: {
        interviewsCompleted: 3,
        goalsAchieved: 2,
        skillsVerified: 8,
      },
    };
  }

  async getMarketTrends(role?: string): Promise<RoleMarketInsight | RoleMarketInsight[]> {
    if (role) {
      const insight = await this.analyticsRepo.getInsightForRole(role);
      return insight || (await this.analyticsRepo.getAllMarketInsights())[0];
    }
    return this.analyticsRepo.getAllMarketInsights();
  }

  async calculateSalaryBenchmark(input: SalaryBenchmarkQueryInput): Promise<SalaryBenchmarkResult> {
    const insight = await this.analyticsRepo.getInsightForRole(input.role);
    const band = insight?.salaryBands[input.level] || {
      min: 100000,
      median: 135000,
      max: 170000,
    };

    const requestedSkills = input.skills || ['Python', 'Docker'];
    const skillsPremium = requestedSkills.map((s) => ({
      skill: s,
      estimatedValueBoostPercentage: ['LangGraph', 'RAG', 'Kubernetes', 'PyTorch'].includes(s)
        ? 12
        : 6,
    }));

    const medianBonusPercentage = input.level === 'SENIOR' || input.level === 'LEAD' || input.level === 'PRINCIPAL' ? 15 : 10;
    const estimatedBonusUSD = Math.round(band.median * (medianBonusPercentage / 100));

    return {
      role: input.role,
      level: input.level,
      baseSalaryRange: {
        min: band.min,
        median: band.median,
        max: band.max,
        currency: 'USD',
      },
      bonusEstimate: {
        medianBonusPercentage,
        estimatedBonusUSD,
      },
      skillsPremium,
      marketCompetitiveness:
        band.median > 150000 ? 'HIGH_DEMAND_COMPETITIVE' : 'STANDARD_MARKET',
    };
  }

  async getApplicationFunnel(totalApplications = 12): Promise<ApplicationFunnelMetric[]> {
    return this.analyticsRepo.getApplicationFunnelMetrics(totalApplications);
  }
}

