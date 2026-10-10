class WorkExperience {
  final String company;
  final String role;
  final String startDate;
  final String endDate;
  final List<String> achievements;
  final List<String> technologiesUsed;

  const WorkExperience({
    required this.company,
    required this.role,
    required this.startDate,
    required this.endDate,
    required this.achievements,
    required this.technologiesUsed,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      company: json['company'] as String? ?? '',
      role: json['role'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? 'Present',
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      technologiesUsed: (json['technologiesUsed'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'startDate': startDate,
      'endDate': endDate,
      'achievements': achievements,
      'technologiesUsed': technologiesUsed,
    };
  }
}

class EducationItem {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final int graduationYear;
  final double? gpa;

  const EducationItem({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.gpa,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      institution: json['institution'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      fieldOfStudy: json['fieldOfStudy'] as String? ?? '',
      graduationYear: (json['graduationYear'] as num?)?.toInt() ?? 2025,
      gpa: (json['gpa'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institution': institution,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'graduationYear': graduationYear,
      if (gpa != null) 'gpa': gpa,
    };
  }
}

class ProjectItem {
  final String title;
  final String description;
  final List<String> techStack;
  final String? repositoryUrl;
  final String? liveDemoUrl;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.techStack,
    this.repositoryUrl,
    this.liveDemoUrl,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      techStack: (json['techStack'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      repositoryUrl: json['repositoryUrl'] as String?,
      liveDemoUrl: json['liveDemoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'techStack': techStack,
      if (repositoryUrl != null) 'repositoryUrl': repositoryUrl,
      if (liveDemoUrl != null) 'liveDemoUrl': liveDemoUrl,
    };
  }
}

class ResumeData {
  final String id;
  final String fileName;
  final int fileSizeBytes;
  final DateTime uploadedAt;
  final String status;
  final int atsScore;
  final int keywordMatchPercentage;
  final int readabilityScore;
  final String summary;
  final List<String> extractedSkills;
  final List<WorkExperience> experiences;
  final List<EducationItem> education;
  final List<ProjectItem> projects;
  final List<String> recommendedImprovements;

  const ResumeData({
    required this.id,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploadedAt,
    required this.status,
    required this.atsScore,
    required this.keywordMatchPercentage,
    required this.readabilityScore,
    required this.summary,
    required this.extractedSkills,
    required this.experiences,
    required this.education,
    required this.projects,
    required this.recommendedImprovements,
  });

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      id: json['id'] as String? ?? 'res_001',
      fileName: json['fileName'] as String? ?? 'resume.pdf',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 245000,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] as String? ?? 'PARSED',
      atsScore: (json['atsScore'] as num?)?.toInt() ?? 82,
      keywordMatchPercentage:
          (json['keywordMatchPercentage'] as num?)?.toInt() ?? 78,
      readabilityScore: (json['readabilityScore'] as num?)?.toInt() ?? 88,
      summary: json['summary'] as String? ?? '',
      extractedSkills: (json['extractedSkills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => EducationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recommendedImprovements:
          (json['recommendedImprovements'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSizeBytes': fileSizeBytes,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status,
      'atsScore': atsScore,
      'keywordMatchPercentage': keywordMatchPercentage,
      'readabilityScore': readabilityScore,
      'summary': summary,
      'extractedSkills': extractedSkills,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'recommendedImprovements': recommendedImprovements,
    };
  }

  String get formattedFileSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
