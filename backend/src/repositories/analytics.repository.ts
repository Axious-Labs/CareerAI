import { SeniorityLevel } from '../schemas/analytics.schema';

export interface RoleMarketInsight {
  role: string;
  demandScore: number; // 0-100
  hiringVelocity: 'ACCELERATING' | 'STABLE' | 'MODERATE' | 'DECLINING';
  averageAnnualGrowthPercentage: number;
  openPositionsCount: number;
  topRequestedSkills: string[];
  salaryBands: Record<SeniorityLevel, { min: number; median: number; max: number }>;
}

export interface ApplicationFunnelMetric {
  stage: string;
  count: number;
  conversionRatePercentage: number;
}

export class AnalyticsRepository {
  private static marketInsights: Map<string, RoleMarketInsight> = new Map();

  constructor() {
    this.seedMarketInsights();
  }

  private seedMarketInsights(): void {
    if (AnalyticsRepository.marketInsights.size > 0) return;

    const insights: RoleMarketInsight[] = [
      {
        role: 'AI/ML Engineer',
        demandScore: 96,
        hiringVelocity: 'ACCELERATING',
        averageAnnualGrowthPercentage: 42.5,
        openPositionsCount: 14850,
        topRequestedSkills: ['LangGraph', 'PyTorch', 'Vector Databases', 'RAG Pipelines', 'Docker', 'FastAPI'],
        salaryBands: {
          ENTRY: { min: 85000, median: 105000, max: 125000 },
          JUNIOR: { min: 105000, median: 125000, max: 145000 },
          MID: { min: 140000, median: 165000, max: 190000 },
          SENIOR: { min: 185000, median: 220000, max: 260000 },
          LEAD: { min: 225000, median: 265000, max: 310000 },
          PRINCIPAL: { min: 280000, median: 335000, max: 420000 },
        },
      },
      {
        role: 'Backend Engineer',
        demandScore: 91,
        hiringVelocity: 'STABLE',
        averageAnnualGrowthPercentage: 18.2,
        openPositionsCount: 22400,
        topRequestedSkills: ['Node.js', 'TypeScript', 'PostgreSQL', 'Redis', 'Kubernetes', 'REST & GraphQL'],
        salaryBands: {
          ENTRY: { min: 70000, median: 88000, max: 105000 },
          JUNIOR: { min: 90000, median: 110000, max: 130000 },
          MID: { min: 125000, median: 148000, max: 172000 },
          SENIOR: { min: 165000, median: 195000, max: 230000 },
          LEAD: { min: 200000, median: 240000, max: 285000 },
          PRINCIPAL: { min: 250000, median: 300000, max: 375000 },
        },
      },
      {
        role: 'Full Stack Engineer',
        demandScore: 89,
        hiringVelocity: 'STABLE',
        averageAnnualGrowthPercentage: 16.5,
        openPositionsCount: 26800,
        topRequestedSkills: ['React', 'Next.js', 'Node.js', 'TypeScript', 'PostgreSQL', 'AWS'],
        salaryBands: {
          ENTRY: { min: 72000, median: 90000, max: 108000 },
          JUNIOR: { min: 92000, median: 112000, max: 132000 },
          MID: { min: 128000, median: 152000, max: 176000 },
          SENIOR: { min: 168000, median: 198000, max: 235000 },
          LEAD: { min: 205000, median: 245000, max: 290000 },
          PRINCIPAL: { min: 255000, median: 310000, max: 380000 },
        },
      },
      {
        role: 'Mobile Flutter Developer',
        demandScore: 84,
        hiringVelocity: 'MODERATE',
        averageAnnualGrowthPercentage: 21.0,
        openPositionsCount: 9800,
        topRequestedSkills: ['Flutter', 'Dart', 'Riverpod', 'Clean Architecture', 'CI/CD Pipelines', 'REST APIs'],
        salaryBands: {
          ENTRY: { min: 65000, median: 82000, max: 98000 },
          JUNIOR: { min: 85000, median: 102000, max: 120000 },
          MID: { min: 118000, median: 138000, max: 160000 },
          SENIOR: { min: 152000, median: 180000, max: 215000 },
          LEAD: { min: 185000, median: 220000, max: 260000 },
          PRINCIPAL: { min: 230000, median: 275000, max: 340000 },
        },
      },
    ];

    for (const insight of insights) {
      AnalyticsRepository.marketInsights.set(insight.role.toLowerCase(), insight);
    }
  }

  async getAllMarketInsights(): Promise<RoleMarketInsight[]> {
    return Array.from(AnalyticsRepository.marketInsights.values());
  }

  async getInsightForRole(role: string): Promise<RoleMarketInsight | null> {
    const normalized = role.toLowerCase().trim();
    for (const [key, val] of AnalyticsRepository.marketInsights.entries()) {
      if (normalized.includes(key) || key.includes(normalized)) {
        return val;
      }
    }
    // Fallback to default AI/ML Engineer
    return AnalyticsRepository.marketInsights.get('ai/ml engineer') || null;
  }

  async getApplicationFunnelMetrics(totalApplications: number): Promise<ApplicationFunnelMetric[]> {
    const total = Math.max(totalApplications, 12);
    const reviewing = Math.round(total * 0.65);
    const interviewing = Math.round(total * 0.28);
    const offers = Math.max(1, Math.round(total * 0.12));

    return [
      { stage: 'Applied', count: total, conversionRatePercentage: 100 },
      { stage: 'Reviewing', count: reviewing, conversionRatePercentage: Math.round((reviewing / total) * 100) },
      { stage: 'Interviewing', count: interviewing, conversionRatePercentage: Math.round((interviewing / total) * 100) },
      { stage: 'Offers', count: offers, conversionRatePercentage: Math.round((offers / total) * 100) },
    ];
  }
}

