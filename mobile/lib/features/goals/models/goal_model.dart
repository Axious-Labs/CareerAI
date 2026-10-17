import 'package:flutter/foundation.dart';

enum GoalCategory {
  skillDevelopment,
  jobSearch,
  interviewPrep,
  projectPortfolio,
  certification,
  networking;

  String get label {
    switch (this) {
      case GoalCategory.skillDevelopment:
        return 'Skill Mastery';
      case GoalCategory.jobSearch:
        return 'Job Search';
      case GoalCategory.interviewPrep:
        return 'Interview Prep';
      case GoalCategory.projectPortfolio:
        return 'Portfolio Project';
      case GoalCategory.certification:
        return 'Certification';
      case GoalCategory.networking:
        return 'Networking';
    }
  }

  static GoalCategory fromString(String? val) {
    if (val == null) return GoalCategory.skillDevelopment;
    final normalized = val.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
    for (final cat in GoalCategory.values) {
      if (cat.name.toLowerCase() == normalized) return cat;
    }
    return GoalCategory.skillDevelopment;
  }
}

enum GoalPriority {
  low,
  medium,
  high,
  critical;

  String get label {
    switch (this) {
      case GoalPriority.low:
        return 'Low Priority';
      case GoalPriority.medium:
        return 'Medium Priority';
      case GoalPriority.high:
        return 'High Priority';
      case GoalPriority.critical:
        return 'Critical Priority';
    }
  }

  static GoalPriority fromString(String? val) {
    if (val == null) return GoalPriority.medium;
    final normalized = val.toLowerCase();
    for (final p in GoalPriority.values) {
      if (p.name.toLowerCase() == normalized) return p;
    }
    return GoalPriority.medium;
  }
}

enum GoalStatus {
  notStarted,
  inProgress,
  completed,
  onHold;

  String get label {
    switch (this) {
      case GoalStatus.notStarted:
        return 'Not Started';
      case GoalStatus.inProgress:
        return 'In Progress';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.onHold:
        return 'On Hold';
    }
  }

  static GoalStatus fromString(String? val) {
    if (val == null) return GoalStatus.inProgress;
    final normalized = val.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
    for (final s in GoalStatus.values) {
      if (s.name.toLowerCase() == normalized) return s;
    }
    return GoalStatus.inProgress;
  }
}

@immutable
class MilestoneResource {
  final String title;
  final String url;
  final String type;

  const MilestoneResource({
    required this.title,
    required this.url,
    required this.type,
  });

  factory MilestoneResource.fromJson(Map<String, dynamic> json) {
    return MilestoneResource(
      title: json['title'] as String? ?? 'Learning Resource',
      url: json['url'] as String? ?? '',
      type: json['type'] as String? ?? 'article',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'type': type,
  };
}

@immutable
class Milestone {
  final String id;
  final String goalId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? dueDate;
  final int orderIndex;
  final List<MilestoneResource> resources;

  const Milestone({
    required this.id,
    required this.goalId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    this.orderIndex = 0,
    this.resources = const [],
  });

  Milestone copyWith({
    String? id,
    String? goalId,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    int? orderIndex,
    List<MilestoneResource>? resources,
  }) {
    return Milestone(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      orderIndex: orderIndex ?? this.orderIndex,
      resources: resources ?? this.resources,
    );
  }

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] as String? ?? UniqueKey().toString(),
      goalId: json['goalId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'].toString()) : null,
      orderIndex: json['orderIndex'] as int? ?? 0,
      resources: (json['resources'] as List<dynamic>?)
              ?.map((e) => MilestoneResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'dueDate': dueDate?.toIso8601String(),
    'orderIndex': orderIndex,
    'resources': resources.map((e) => e.toJson()).toList(),
  };
}

@immutable
class CareerGoal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String targetRole;
  final GoalCategory category;
  final GoalPriority priority;
  final GoalStatus status;
  final double progress; // 0.0 - 100.0
  final DateTime startDate;
  final DateTime targetDate;
  final List<Milestone> milestones;
  final List<String> tags;

  const CareerGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetRole,
    this.category = GoalCategory.skillDevelopment,
    this.priority = GoalPriority.medium,
    this.status = GoalStatus.inProgress,
    this.progress = 0.0,
    required this.startDate,
    required this.targetDate,
    this.milestones = const [],
    this.tags = const [],
  });

  int get totalMilestones => milestones.length;
  int get completedMilestonesCount => milestones.where((m) => m.isCompleted).length;

  double get calculatedProgress {
    if (milestones.isEmpty) return progress;
    return (completedMilestonesCount / milestones.length) * 100.0;
  }

  bool get isOverdue {
    if (status == GoalStatus.completed) return false;
    return DateTime.now().isAfter(targetDate);
  }

  int get daysRemaining {
    final diff = targetDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  CareerGoal copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? targetRole,
    GoalCategory? category,
    GoalPriority? priority,
    GoalStatus? status,
    double? progress,
    DateTime? startDate,
    DateTime? targetDate,
    List<Milestone>? milestones,
    List<String>? tags,
  }) {
    return CareerGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      targetRole: targetRole ?? this.targetRole,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      milestones: milestones ?? this.milestones,
      tags: tags ?? this.tags,
    );
  }

  factory CareerGoal.fromJson(Map<String, dynamic> json) {
    final parsedMilestones = (json['milestones'] as List<dynamic>?)
            ?.map((e) => Milestone.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];

    return CareerGoal(
      id: json['id'] as String? ?? UniqueKey().toString(),
      userId: json['userId'] as String? ?? 'user_1',
      title: json['title'] as String? ?? 'Untitled Career Goal',
      description: json['description'] as String? ?? '',
      targetRole: json['targetRole'] as String? ?? 'Software Engineer',
      category: GoalCategory.fromString(json['category'] as String?),
      priority: GoalPriority.fromString(json['priority'] as String?),
      status: GoalStatus.fromString(json['status'] as String?),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'].toString()) ?? DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 30)),
      milestones: parsedMilestones,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'description': description,
    'targetRole': targetRole,
    'category': category.name,
    'priority': priority.name,
    'status': status.name,
    'progress': progress,
    'startDate': startDate.toIso8601String(),
    'targetDate': targetDate.toIso8601String(),
    'milestones': milestones.map((e) => e.toJson()).toList(),
    'tags': tags,
  };
}

@immutable
class GoalSummaryStats {
  final int totalGoals;
  final int completedGoals;
  final int inProgressGoals;
  final int totalMilestones;
  final int completedMilestones;
  final double averageProgress;

  const GoalSummaryStats({
    required this.totalGoals,
    required this.completedGoals,
    required this.inProgressGoals,
    required this.totalMilestones,
    required this.completedMilestones,
    required this.averageProgress,
  });

  factory GoalSummaryStats.fromGoals(List<CareerGoal> goals) {
    if (goals.isEmpty) {
      return const GoalSummaryStats(
        totalGoals: 0,
        completedGoals: 0,
        inProgressGoals: 0,
        totalMilestones: 0,
        completedMilestones: 0,
        averageProgress: 0.0,
      );
    }

    int completedG = 0;
    int inProgressG = 0;
    int totalM = 0;
    int completedM = 0;
    double progressSum = 0;

    for (final g in goals) {
      if (g.status == GoalStatus.completed) {
        completedG++;
      } else {
        inProgressG++;
      }
      totalM += g.totalMilestones;
      completedM += g.completedMilestonesCount;
      progressSum += g.calculatedProgress;
    }

    return GoalSummaryStats(
      totalGoals: goals.length,
      completedGoals: completedG,
      inProgressGoals: inProgressG,
      totalMilestones: totalM,
      completedMilestones: completedM,
      averageProgress: (progressSum / goals.length).roundToDouble(),
    );
  }
}
