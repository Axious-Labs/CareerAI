import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/analytics/models/analytics_model.dart';
import 'package:careerai_mobile/features/analytics/services/analytics_service.dart';

void main() {
  group('Analytics Models Tests', () {
    test('SkillDemandItem serializes and deserializes accurately', () {
      const item = SkillDemandItem(
        skillName: 'Dart 3 & Flutter',
        demandScore: 92,
        growthPercentage: 28.4,
        category: 'Mobile Core',
        jobPostingsCount: 1650,
      );

      final json = item.toJson();
      expect(json['skillName'], 'Dart 3 & Flutter');
      expect(json['demandScore'], 92);
      expect(json['growthPercentage'], 28.4);

      final parsed = SkillDemandItem.fromJson(json);
      expect(parsed.skillName, item.skillName);
      expect(parsed.demandScore, item.demandScore);
      expect(parsed.jobPostingsCount, item.jobPostingsCount);
    });

    test('SalaryBenchmarkItem handles numbers and currency format accurately', () {
      const item = SalaryBenchmarkItem(
        role: 'Staff Flutter Architect',
        juniorSalary: 110000,
        midSalary: 165000,
        seniorSalary: 220000,
        currency: 'USD',
        location: 'Remote',
        yoyGrowth: 15.6,
      );

      final json = item.toJson();
      final parsed = SalaryBenchmarkItem.fromJson(json);

      expect(parsed.role, item.role);
      expect(parsed.juniorSalary, 110000);
      expect(parsed.midSalary, 165000);
      expect(parsed.seniorSalary, 220000);
      expect(parsed.yoyGrowth, 15.6);
    });

    test('ApplicationFunnelStats calculates conversion rates with zero division safety', () {
      const emptyFunnel = ApplicationFunnelStats(
        applied: 0,
        screening: 0,
        technicalInterview: 0,
        finalRound: 0,
        offers: 0,
        rejected: 0,
      );

      expect(emptyFunnel.interviewConversionRate, 0.0);
      expect(emptyFunnel.offerConversionRate, 0.0);

      const activeFunnel = ApplicationFunnelStats(
        applied: 40,
        screening: 20,
        technicalInterview: 10,
        finalRound: 5,
        offers: 4,
        rejected: 15,
      );

      expect(activeFunnel.interviewConversionRate, 50.0);
      expect(activeFunnel.offerConversionRate, 10.0);
    });

    test('CareerAnalyticsOverview parses full structure including nested objects', () {
      final json = {
        'careerHealthScore': 88,
        'profileCompleteness': 95,
        'marketCompetitiveness': 91,
        'salaryPercentile': 85,
        'highDemandSkills': [
          {
            'skillName': 'Flutter',
            'demandScore': 90,
            'growthPercentage': 20.0,
            'category': 'Mobile',
            'jobPostingsCount': 1000,
          }
        ],
        'salaryBenchmarks': [
          {
            'role': 'Lead Dev',
            'juniorSalary': 90000,
            'midSalary': 130000,
            'seniorSalary': 175000,
            'yoyGrowth': 10.0,
          }
        ],
        'funnelStats': {
          'applied': 20,
          'screening': 10,
          'technicalInterview': 5,
          'finalRound': 2,
          'offers': 1,
          'rejected': 5,
        },
        'strategicRecommendations': ['Enhance unit test coverage.'],
      };

      final overview = CareerAnalyticsOverview.fromJson(json);
      expect(overview.careerHealthScore, 88);
      expect(overview.profileCompleteness, 95);
      expect(overview.highDemandSkills.length, 1);
      expect(overview.salaryBenchmarks.length, 1);
      expect(overview.funnelStats.applied, 20);
      expect(overview.strategicRecommendations.first, 'Enhance unit test coverage.');
    });
  });

  group('AnalyticsService Unit Tests', () {
    test('fetchAnalytics returns rich career intelligence overview', () async {
      final service = AnalyticsService();
      final data = await service.fetchAnalytics();

      expect(data.careerHealthScore > 0, true);
      expect(data.highDemandSkills.isNotEmpty, true);
      expect(data.salaryBenchmarks.isNotEmpty, true);
      expect(data.strategicRecommendations.isNotEmpty, true);
    });
  });
}
