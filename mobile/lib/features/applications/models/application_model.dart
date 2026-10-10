enum ApplicationStatus {
  applied,
  underReview,
  interviewing,
  offer,
  rejected,
}

class InterviewRoundInfo {
  final String roundName;
  final String scheduledDate;
  final String interviewer;
  final String? feedback;

  const InterviewRoundInfo({
    required this.roundName,
    required this.scheduledDate,
    required this.interviewer,
    this.feedback,
  });

  factory InterviewRoundInfo.fromJson(Map<String, dynamic> json) {
    return InterviewRoundInfo(
      roundName: json['roundName'] as String? ?? 'Technical Round',
      scheduledDate: json['scheduledDate'] as String? ?? 'TBD',
      interviewer: json['interviewer'] as String? ?? 'Engineering Team',
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundName': roundName,
      'scheduledDate': scheduledDate,
      'interviewer': interviewer,
      if (feedback != null) 'feedback': feedback,
    };
  }
}

class JobApplication {
  final String id;
  final String jobId;
  final String title;
  final String company;
  final String location;
  final ApplicationStatus status;
  final String appliedDate;
  final String notes;
  final List<InterviewRoundInfo> rounds;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.title,
    required this.company,
    required this.location,
    required this.status,
    required this.appliedDate,
    required this.notes,
    this.rounds = const [],
  });

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? title,
    String? company,
    String? location,
    ApplicationStatus? status,
    String? appliedDate,
    String? notes,
    List<InterviewRoundInfo>? rounds,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      notes: notes ?? this.notes,
      rounds: rounds ?? this.rounds,
    );
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] ?? '').toString().toLowerCase();
    ApplicationStatus parsedStatus = ApplicationStatus.applied;
    if (statusStr == 'interviewing') parsedStatus = ApplicationStatus.interviewing;
    if (statusStr == 'offer') parsedStatus = ApplicationStatus.offer;
    if (statusStr == 'rejected') parsedStatus = ApplicationStatus.rejected;
    if (statusStr == 'under_review') parsedStatus = ApplicationStatus.underReview;

    return JobApplication(
      id: json['id'] as String? ?? '',
      jobId: json['jobId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? 'Remote',
      status: parsedStatus,
      appliedDate: json['appliedDate'] as String? ?? 'Recently',
      notes: json['notes'] as String? ?? '',
      rounds: (json['rounds'] as List<dynamic>?)
              ?.map((r) => InterviewRoundInfo.fromJson(r as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'title': title,
      'company': company,
      'location': location,
      'status': status.name,
      'appliedDate': appliedDate,
      'notes': notes,
      'rounds': rounds.map((r) => r.toJson()).toList(),
    };
  }

  String get statusDisplay {
    switch (status) {
      case ApplicationStatus.applied:
        return 'APPLIED';
      case ApplicationStatus.underReview:
        return 'UNDER REVIEW';
      case ApplicationStatus.interviewing:
        return 'INTERVIEWING';
      case ApplicationStatus.offer:
        return 'OFFER';
      case ApplicationStatus.rejected:
        return 'REJECTED';
    }
  }
}
