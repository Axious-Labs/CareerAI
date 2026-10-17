import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../services/analytics_service.dart';
import 'widgets/application_funnel_widget.dart';
import 'widgets/metric_summary_card.dart';
import 'widgets/salary_benchmark_card.dart';
import 'widgets/skill_demand_bar.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsOverviewProvider);
    final selectedTimeframe = ref.watch(selectedTimeframeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Analytics & Intelligence'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range, color: AppColors.accentLight),
            onSelected: (val) {
              ref.read(selectedTimeframeProvider.notifier).state = val;
            },
            color: AppColors.surface,
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'Last 30 Days', child: Text('Last 30 Days', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 'Last 90 Days', child: Text('Last 90 Days', style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: 'This Year', child: Text('This Year', style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text('Unable to load analytics: $err', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(analyticsOverviewProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Timeframe & Subheading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Performance Indicators', style: AppTextStyles.h3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedTimeframe,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. 2x2 Grid of Key KPI Cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    MetricSummaryCard(
                      title: 'Career Health',
                      value: '${data.careerHealthScore}%',
                      subtitle: 'Overall Profile Standing',
                      icon: Icons.favorite_border,
                      accentColor: AppColors.accent,
                      trendPercentage: 4.8,
                    ),
                    MetricSummaryCard(
                      title: 'Competitiveness',
                      value: '${data.marketCompetitiveness}%',
                      subtitle: 'Talent Market Fit',
                      icon: Icons.trending_up,
                      accentColor: AppColors.success,
                      trendPercentage: 7.2,
                    ),
                    MetricSummaryCard(
                      title: 'Completeness',
                      value: '${data.profileCompleteness}%',
                      subtitle: 'Resume & Portfolio Depth',
                      icon: Icons.verified_user_outlined,
                      accentColor: AppColors.info,
                    ),
                    MetricSummaryCard(
                      title: 'Salary Bracket',
                      value: 'Top ${100 - data.salaryPercentile}%',
                      subtitle: '${data.salaryPercentile}th Percentile Benchmark',
                      icon: Icons.attach_money,
                      accentColor: AppColors.warning,
                      trendPercentage: 12.0,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 3. AI Strategic Recommendations
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surface,
                        AppColors.surfaceLight.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.accentLight, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'AI Career Roadmap Recommendations',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...data.strategicRecommendations.map((rec) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4, right: 8),
                                child: Icon(Icons.check_circle_outline, color: AppColors.accent, size: 14),
                              ),
                              Expanded(
                                child: Text(
                                  rec,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. In-Demand Skills Trajectory
                const Text('Market Skill Demand Index', style: AppTextStyles.h3),
                const SizedBox(height: 4),
                const Text('Real-time demand signals analyzed across tech postings', style: AppTextStyles.bodySmall),
                const SizedBox(height: 12),
                ...data.highDemandSkills.map((s) => SkillDemandBar(item: s)),

                const SizedBox(height: 24),

                // 5. Application Funnel
                ApplicationFunnelWidget(funnel: data.funnelStats),

                const SizedBox(height: 24),

                // 6. Salary Benchmarks
                const Text('Global Salary Benchmarks', style: AppTextStyles.h3),
                const SizedBox(height: 4),
                const Text('Compensation trends for related engineering roles', style: AppTextStyles.bodySmall),
                const SizedBox(height: 12),
                ...data.salaryBenchmarks.map((b) => SalaryBenchmarkCard(item: b)),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
