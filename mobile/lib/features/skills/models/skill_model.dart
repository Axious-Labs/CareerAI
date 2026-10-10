enum SkillProficiency {
  beginner,
  intermediate,
  advanced,
  expert,
}

class SkillItem {
  final String id;
  final String name;
  final String category;
  final SkillProficiency proficiency;
  final double level; // 0.0 to 1.0
  final bool isVerified;
  final int endorsedCount;

  const SkillItem({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    required this.level,
    this.isVerified = false,
    this.endorsedCount = 0,
  });

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      proficiency: SkillProficiency.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['proficiency'] ?? '').toString().toLowerCase(),
        orElse: () => SkillProficiency.intermediate,
      ),
      level: (json['level'] as num?)?.toDouble() ?? 0.6,
      isVerified: json['isVerified'] as bool? ?? false,
      endorsedCount: (json['endorsedCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'proficiency': proficiency.name,
      'level': level,
      'isVerified': isVerified,
      'endorsedCount': endorsedCount,
    };
  }

  String get proficiencyLabel {
    switch (proficiency) {
      case SkillProficiency.beginner:
        return 'Beginner';
      case SkillProficiency.intermediate:
        return 'Intermediate';
      case SkillProficiency.advanced:
        return 'Advanced';
      case SkillProficiency.expert:
        return 'Expert';
    }
  }
}

class RoadmapMilestone {
  final String id;
  final int weekNumber;
  final String title;
  final String description;
  final String estimatedHours;
  final List<String> recommendedResources;
  final bool isCompleted;

  const RoadmapMilestone({
    required this.id,
    required this.weekNumber,
    required this.title,
    required this.description,
    required this.estimatedHours,
    required this.recommendedResources,
    this.isCompleted = false,
  });

  RoadmapMilestone copyWith({
    String? id,
    int? weekNumber,
    String? title,
    String? description,
    String? estimatedHours,
    List<String>? recommendedResources,
    bool? isCompleted,
  }) {
    return RoadmapMilestone(
      id: id ?? this.id,
      weekNumber: weekNumber ?? this.weekNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      recommendedResources: recommendedResources ?? this.recommendedResources,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory RoadmapMilestone.fromJson(Map<String, dynamic> json) {
    return RoadmapMilestone(
      id: json['id'] as String? ?? '',
      weekNumber: (json['weekNumber'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      estimatedHours: json['estimatedHours'] as String? ?? '5 hrs',
      recommendedResources: (json['recommendedResources'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weekNumber': weekNumber,
      'title': title,
      'description': description,
      'estimatedHours': estimatedHours,
      'recommendedResources': recommendedResources,
      'isCompleted': isCompleted,
    };
  }
}

class SkillGapItem {
  final String skillName;
  final String importance; // HIGH, MEDIUM, LOW
  final String estimatedTimeToMaster;
  final String rationale;

  const SkillGapItem({
    required this.skillName,
    required this.importance,
    required this.estimatedTimeToMaster,
    required this.rationale,
  });

  factory SkillGapItem.fromJson(Map<String, dynamic> json) {
    return SkillGapItem(
      skillName: json['skillName'] as String? ?? '',
      importance: json['importance'] as String? ?? 'MEDIUM',
      estimatedTimeToMaster: json['estimatedTimeToMaster'] as String? ?? '2 weeks',
      rationale: json['rationale'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skillName': skillName,
      'importance': importance,
      'estimatedTimeToMaster': estimatedTimeToMaster,
      'rationale': rationale,
    };
  }
}
