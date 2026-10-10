enum WorkplaceType {
  remote,
  hybrid,
  onsite,
}

enum ExperienceLevel {
  entry,
  mid,
  senior,
  lead,
}

class JobPosting {
  final String id;
  final String title;
  final String company;
  final String location;
  final WorkplaceType workplaceType;
  final ExperienceLevel experienceLevel;
  final String salaryRange;
  final int matchScore;
  final String description;
  final List<String> requirements;
  final List<String> tags;
  final DateTime postedDate;
  final bool isSaved;
  final bool isApplied;

  const JobPosting({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.workplaceType,
    required this.experienceLevel,
    required this.salaryRange,
    required this.matchScore,
    required this.description,
    required this.requirements,
    required this.tags,
    required this.postedDate,
    this.isSaved = false,
    this.isApplied = false,
  });

  JobPosting copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    WorkplaceType? workplaceType,
    ExperienceLevel? experienceLevel,
    String? salaryRange,
    int? matchScore,
    String? description,
    List<String>? requirements,
    List<String>? tags,
    DateTime? postedDate,
    bool? isSaved,
    bool? isApplied,
  }) {
    return JobPosting(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      workplaceType: workplaceType ?? this.workplaceType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salaryRange: salaryRange ?? this.salaryRange,
      matchScore: matchScore ?? this.matchScore,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      tags: tags ?? this.tags,
      postedDate: postedDate ?? this.postedDate,
      isSaved: isSaved ?? this.isSaved,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? 'Remote',
      workplaceType: WorkplaceType.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['workplaceType'] ?? '').toString().toLowerCase(),
        orElse: () => WorkplaceType.remote,
      ),
      experienceLevel: ExperienceLevel.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['experienceLevel'] ?? '').toString().toLowerCase(),
        orElse: () => ExperienceLevel.mid,
      ),
      salaryRange: json['salaryRange'] as String? ?? '\$120k - \$150k',
      matchScore: (json['matchScore'] as num?)?.toInt() ?? 75,
      description: json['description'] as String? ?? '',
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      postedDate: json['postedDate'] != null
          ? DateTime.tryParse(json['postedDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isSaved: json['isSaved'] as bool? ?? false,
      isApplied: json['isApplied'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'workplaceType': workplaceType.name,
      'experienceLevel': experienceLevel.name,
      'salaryRange': salaryRange,
      'matchScore': matchScore,
      'description': description,
      'requirements': requirements,
      'tags': tags,
      'postedDate': postedDate.toIso8601String(),
      'isSaved': isSaved,
      'isApplied': isApplied,
    };
  }

  String get workplaceLabel {
    switch (workplaceType) {
      case WorkplaceType.remote:
        return 'Remote';
      case WorkplaceType.hybrid:
        return 'Hybrid';
      case WorkplaceType.onsite:
        return 'On-site';
    }
  }

  String get experienceLabel {
    switch (experienceLevel) {
      case ExperienceLevel.entry:
        return 'Entry Level';
      case ExperienceLevel.mid:
        return 'Mid Level';
      case ExperienceLevel.senior:
        return 'Senior';
      case ExperienceLevel.lead:
        return 'Lead';
    }
  }
}

class JobFilterState {
  final String searchQuery;
  final WorkplaceType? workplaceType;
  final int minMatchScore;
  final String? selectedTag;

  const JobFilterState({
    this.searchQuery = '',
    this.workplaceType,
    this.minMatchScore = 0,
    this.selectedTag,
  });

  JobFilterState copyWith({
    String? searchQuery,
    WorkplaceType? workplaceType,
    int? minMatchScore,
    String? selectedTag,
  }) {
    return JobFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      workplaceType: workplaceType ?? this.workplaceType,
      minMatchScore: minMatchScore ?? this.minMatchScore,
      selectedTag: selectedTag ?? this.selectedTag,
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      workplaceType != null ||
      minMatchScore > 0 ||
      selectedTag != null;
}
