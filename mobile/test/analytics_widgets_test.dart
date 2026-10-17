import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/analytics/models/analytics_model.dart';
import 'package:careerai_mobile/features/analytics/services/analytics_service.dart';
import 'package:careerai_mobile/features/analytics/presentation/widgets/metric_summary_card.dart';
import 'package:careerai_mobile/features/analytics/presentation/widgets/skill_demand_bar.dart';
import 'package:careerai_mobile/features/analytics/presentation/widgets/salary_benchmark_card.dart';
import 'package:careerai_mobile/features/analytics/presentation/widgets/application_funnel_widget.dart';
import 'package:careerai_mobile/features/analytics/presentation/analytics_screen.dart';

class MockAnalyticsService extends AnalyticsService {
  @override
  Future<CareerAnalyticsOverview> fetchAnalytics() async {
    return const CareerAnalyticsOverview(
      careerHealthScore: 84,
      profileCompleteness: 92,
      marketCompetitiveness: 88,
      salaryPercentile: 82,
      highDemandSkills: [
        SkillDemandItem(
          skillName: 'Flutter & Dart Engine',
          demandScore: 94,
          growthPercentage: 24.5,
          category: 'Mobile Core',
          jobPostingsCount: 1420,
        ),
      ],
      salaryBenchmarks: [
        SalaryBenchmarkItem(
          role: 'Senior Flutter Specialist',
          juniorSalary: 95000,
          midSalary: 140000,
          seniorSalary: 185000,
          yoyGrowth: 12.4,
        ),
      ],
      funnelStats: ApplicationFunnelStats(
        applied: 28,
        screening: 14,
        technicalInterview: 8,
        finalRound: 4,
        offers: 2,
        rejected: 8,
      ),
      strategicRecommendations: [
        'Your profile matches 88% of Senior Flutter roles.',
      ],
    );
  }
}

void main() {
  group('Analytics Widgets Unit Tests', () {
    testWidgets('MetricSummaryCard renders title, value, subtitle, and trend', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MetricSummaryCard(
              title: 'Career Readiness',
              value: '92%',
              subtitle: 'Top 10% candidate pool',
              icon: Icons.trending_up,
              trendPercentage: 5.5,
            ),
          ),
        ),
      );

      expect(find.text('Career Readiness'), findsOneWidget);
      expect(find.text('92%'), findsOneWidget);
      expect(find.text('Top 10% candidate pool'), findsOneWidget);
      expect(find.text('+5.5%'), findsOneWidget);
    });

    testWidgets('SkillDemandBar renders skill name, demand score, and job postings count', (tester) async {
      const item = SkillDemandItem(
        skillName: 'Riverpod State Management',
        demandScore: 88,
        growthPercentage: 22.0,
        category: 'Architecture',
        jobPostingsCount: 840,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SkillDemandBar(item: item),
          ),
        ),
      );

      expect(find.text('Riverpod State Management'), findsOneWidget);
      expect(find.text('Architecture'), findsOneWidget);
      expect(find.text('+22.0%'), findsOneWidget);
      expect(find.text('840 active job postings'), findsOneWidget);
      expect(find.text('88/100 Demand Index'), findsOneWidget);
    });

    testWidgets('SalaryBenchmarkCard displays role, locations, and salary tier values', (tester) async {
      const benchmark = SalaryBenchmarkItem(
        role: 'Senior Flutter Specialist',
        juniorSalary: 95000,
        midSalary: 140000,
        seniorSalary: 185000,
        currency: 'USD',
        location: 'Global Remote',
        yoyGrowth: 12.4,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SalaryBenchmarkCard(item: benchmark),
          ),
        ),
      );

      expect(find.text('Senior Flutter Specialist'), findsOneWidget);
      expect(find.text('Global Remote'), findsOneWidget);
      expect(find.text('+12.4% YoY'), findsOneWidget);
      expect(find.text('Mid-Level'), findsOneWidget);
    });

    testWidgets('ApplicationFunnelWidget renders conversion stages and rate badge', (tester) async {
      const funnel = ApplicationFunnelStats(
        applied: 30,
        screening: 15,
        technicalInterview: 9,
        finalRound: 4,
        offers: 3,
        rejected: 10,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ApplicationFunnelWidget(funnel: funnel),
          ),
        ),
      );

      expect(find.text('Application Conversion Funnel'), findsOneWidget);
      expect(find.text('10.0% Offer Rate'), findsOneWidget);
      expect(find.text('Applied Jobs'), findsOneWidget);
      expect(find.text('Recruiter Screening'), findsOneWidget);
      expect(find.text('Job Offers Received'), findsOneWidget);
    });

    testWidgets('AnalyticsScreen loads and renders within ProviderScope', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            analyticsServiceProvider.overrideWithValue(MockAnalyticsService()),
          ],
          child: const MaterialApp(
            home: AnalyticsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Career Analytics & Intelligence'), findsOneWidget);
      expect(find.text('Performance Indicators'), findsOneWidget);
    });
  });
}
