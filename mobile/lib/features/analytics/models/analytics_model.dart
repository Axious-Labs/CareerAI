import 'package:flutter/foundation.dart';

@immutable
class SkillDemandItem {
  final String skillName;
  final int demandScore; // 1 - 100
  final double growthPercentage;
  final String category;
  final int jobPostingsCount;

  const SkillDemandItem({
    required this.skillName,
    required this.demandScore,
    required this.growthPercentage,
    required this.category,
    required this.jobPostingsCount,
  });

  factory SkillDemandItem.fromJson(Map<String, dynamic> json) {
    return SkillDemandItem(
      skillName: json['skillName'] as String? ?? 'General Skill',
      demandScore: (json['demandScore'] as num?)?.toInt() ?? 50,
      growthPercentage: (json['growthPercentage'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'Technical',
      jobPostingsCount: (json['jobPostingsCount'] as num?)?.toInt() ?? 100,
    );
  }

  Map<String, dynamic> toJson() => {
    'skillName': skillName,
    'demandScore': demandScore,
    'growthPercentage': growthPercentage,
    'category': category,
    'jobPostingsCount': jobPostingsCount,
  };
}

@immutable
class SalaryBenchmarkItem {
  final String role;
  final int juniorSalary;
  final int midSalary;
  final int seniorSalary;
  final String currency;
  final String location;
  final double yoyGrowth;

  const SalaryBenchmarkItem({
    required this.role,
    required this.juniorSalary,
    required this.midSalary,
    required this.seniorSalary,
    this.currency = 'USD',
    this.location = 'Global Remote',
    required this.yoyGrowth,
  });

  factory SalaryBenchmarkItem.fromJson(Map<String, dynamic> json) {
    return SalaryBenchmarkItem(
      role: json['role'] as String? ?? 'Engineer',
      juniorSalary: (json['juniorSalary'] as num?)?.toInt() ?? 80000,
      midSalary: (json['midSalary'] as num?)?.toInt() ?? 120000,
      seniorSalary: (json['seniorSalary'] as num?)?.toInt() ?? 160000,
      currency: json['currency'] as String? ?? 'USD',
      location: json['location'] as String? ?? 'Global Remote',
      yoyGrowth: (json['yoyGrowth'] as num?)?.toDouble() ?? 5.5,
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'juniorSalary': juniorSalary,
    'midSalary': midSalary,
    'seniorSalary': seniorSalary,
    'currency': currency,
    'location': location,
    'yoyGrowth': yoyGrowth,
  };
}

@immutable
class ApplicationFunnelStats {
  final int applied;
  final int screening;
  final int technicalInterview;
  final int finalRound;
  final int offers;
  final int rejected;

  const ApplicationFunnelStats({
    required this.applied,
    required this.screening,
    required this.technicalInterview,
    required this.finalRound,
    required this.offers,
    required this.rejected,
  });

  double get interviewConversionRate {
    if (applied == 0) return 0.0;
    return (screening / applied) * 100.0;
  }

  double get offerConversionRate {
    if (applied == 0) return 0.0;
    return (offers / applied) * 100.0;
  }

  factory ApplicationFunnelStats.fromJson(Map<String, dynamic> json) {
    return ApplicationFunnelStats(
      applied: (json['applied'] as num?)?.toInt() ?? 0,
      screening: (json['screening'] as num?)?.toInt() ?? 0,
      technicalInterview: (json['technicalInterview'] as num?)?.toInt() ?? 0,
      finalRound: (json['finalRound'] as num?)?.toInt() ?? 0,
      offers: (json['offers'] as num?)?.toInt() ?? 0,
      rejected: (json['rejected'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'applied': applied,
    'screening': screening,
    'technicalInterview': technicalInterview,
    'finalRound': finalRound,
    'offers': offers,
    'rejected': rejected,
  };
}

@immutable
class CareerAnalyticsOverview {
  final int careerHealthScore; // 0 - 100
  final int profileCompleteness; // 0 - 100
  final int marketCompetitiveness; // 0 - 100
  final int salaryPercentile; // 0 - 100
  final List<SkillDemandItem> highDemandSkills;
  final List<SalaryBenchmarkItem> salaryBenchmarks;
  final ApplicationFunnelStats funnelStats;
  final List<String> strategicRecommendations;

  const CareerAnalyticsOverview({
    required this.careerHealthScore,
    required this.profileCompleteness,
    required this.marketCompetitiveness,
    required this.salaryPercentile,
    required this.highDemandSkills,
    required this.salaryBenchmarks,
    required this.funnelStats,
    required this.strategicRecommendations,
  });

  factory CareerAnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return CareerAnalyticsOverview(
      careerHealthScore: (json['careerHealthScore'] as num?)?.toInt() ?? 82,
      profileCompleteness: (json['profileCompleteness'] as num?)?.toInt() ?? 90,
      marketCompetitiveness: (json['marketCompetitiveness'] as num?)?.toInt() ?? 78,
      salaryPercentile: (json['salaryPercentile'] as num?)?.toInt() ?? 75,
      highDemandSkills: (json['highDemandSkills'] as List<dynamic>?)
              ?.map((e) => SkillDemandItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      salaryBenchmarks: (json['salaryBenchmarks'] as List<dynamic>?)
              ?.map((e) => SalaryBenchmarkItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      funnelStats: json['funnelStats'] != null
          ? ApplicationFunnelStats.fromJson(json['funnelStats'] as Map<String, dynamic>)
          : const ApplicationFunnelStats(
              applied: 24,
              screening: 12,
              technicalInterview: 6,
              finalRound: 3,
              offers: 2,
              rejected: 7,
            ),
      strategicRecommendations: (json['strategicRecommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'careerHealthScore': careerHealthScore,
    'profileCompleteness': profileCompleteness,
    'marketCompetitiveness': marketCompetitiveness,
    'salaryPercentile': salaryPercentile,
    'highDemandSkills': highDemandSkills.map((e) => e.toJson()).toList(),
    'salaryBenchmarks': salaryBenchmarks.map((e) => e.toJson()).toList(),
    'funnelStats': funnelStats.toJson(),
    'strategicRecommendations': strategicRecommendations,
  };
}
