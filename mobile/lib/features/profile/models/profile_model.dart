import 'package:flutter/foundation.dart';

@immutable
class CertificationItem {
  final String id;
  final String name;
  final String issuer;
  final DateTime issueDate;
  final String? credentialUrl;

  const CertificationItem({
    required this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.credentialUrl,
  });

  factory CertificationItem.fromJson(Map<String, dynamic> json) {
    return CertificationItem(
      id: json['id'] as String? ?? UniqueKey().toString(),
      name: json['name'] as String? ?? '',
      issuer: json['issuer'] as String? ?? '',
      issueDate: json['issueDate'] != null
          ? DateTime.tryParse(json['issueDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      credentialUrl: json['credentialUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'issuer': issuer,
    'issueDate': issueDate.toIso8601String(),
    'credentialUrl': credentialUrl,
  };
}

@immutable
class PortfolioProject {
  final String id;
  final String title;
  final String description;
  final String? repoUrl;
  final String? liveDemoUrl;
  final List<String> techStack;
  final int starsCount;

  const PortfolioProject({
    required this.id,
    required this.title,
    required this.description,
    this.repoUrl,
    this.liveDemoUrl,
    this.techStack = const [],
    this.starsCount = 0,
  });

  factory PortfolioProject.fromJson(Map<String, dynamic> json) {
    return PortfolioProject(
      id: json['id'] as String? ?? UniqueKey().toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      repoUrl: json['repoUrl'] as String?,
      liveDemoUrl: json['liveDemoUrl'] as String?,
      techStack: (json['techStack'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      starsCount: (json['starsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'repoUrl': repoUrl,
    'liveDemoUrl': liveDemoUrl,
    'techStack': techStack,
    'starsCount': starsCount,
  };
}

@immutable
class CareerPreferences {
  final String targetRole;
  final String location;
  final bool remoteOnly;
  final int expectedMinSalary;
  final String currency;

  const CareerPreferences({
    required this.targetRole,
    required this.location,
    this.remoteOnly = true,
    required this.expectedMinSalary,
    this.currency = 'USD',
  });

  factory CareerPreferences.fromJson(Map<String, dynamic> json) {
    return CareerPreferences(
      targetRole: json['targetRole'] as String? ?? 'Senior Flutter Engineer',
      location: json['location'] as String? ?? 'San Francisco, CA / Remote',
      remoteOnly: json['remoteOnly'] as bool? ?? true,
      expectedMinSalary: (json['expectedMinSalary'] as num?)?.toInt() ?? 140000,
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() => {
    'targetRole': targetRole,
    'location': location,
    'remoteOnly': remoteOnly,
    'expectedMinSalary': expectedMinSalary,
    'currency': currency,
  };
}

@immutable
class UserProfileDetail {
  final String id;
  final String name;
  final String email;
  final String headline;
  final String targetRole;
  final int careerReadiness;
  final String education;
  final List<CertificationItem> certifications;
  final List<PortfolioProject> projects;
  final CareerPreferences preferences;

  const UserProfileDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.headline,
    required this.targetRole,
    required this.careerReadiness,
    required this.education,
    this.certifications = const [],
    this.projects = const [],
    required this.preferences,
  });

  UserProfileDetail copyWith({
    String? id,
    String? name,
    String? email,
    String? headline,
    String? targetRole,
    int? careerReadiness,
    String? education,
    List<CertificationItem>? certifications,
    List<PortfolioProject>? projects,
    CareerPreferences? preferences,
  }) {
    return UserProfileDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      headline: headline ?? this.headline,
      targetRole: targetRole ?? this.targetRole,
      careerReadiness: careerReadiness ?? this.careerReadiness,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      projects: projects ?? this.projects,
      preferences: preferences ?? this.preferences,
    );
  }

  factory UserProfileDetail.fromJson(Map<String, dynamic> json) {
    return UserProfileDetail(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Alex Chen',
      email: json['email'] as String? ?? 'alex.chen@university.edu',
      headline: json['headline'] as String? ?? 'Cross-Platform Engineer & AI Systems Architect',
      targetRole: json['targetRole'] as String? ?? 'Senior Flutter Engineer',
      careerReadiness: (json['careerReadiness'] as num?)?.toInt() ?? 78,
      education: json['education'] as String? ?? 'B.S. in Computer Science',
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => CertificationItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => PortfolioProject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      preferences: json['preferences'] != null
          ? CareerPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : const CareerPreferences(
              targetRole: 'Senior Flutter Engineer',
              location: 'Remote',
              expectedMinSalary: 140000,
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'headline': headline,
    'targetRole': targetRole,
    'careerReadiness': careerReadiness,
    'education': education,
    'certifications': certifications.map((e) => e.toJson()).toList(),
    'projects': projects.map((e) => e.toJson()).toList(),
    'preferences': preferences.toJson(),
  };
}
