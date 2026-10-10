import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/application_model.dart';

final applicationServiceProvider = Provider<ApplicationService>((ref) {
  return ApplicationService(ApiClient());
});

class ApplicationsNotifier extends StateNotifier<List<JobApplication>> {
  final ApplicationService _service;

  ApplicationsNotifier(this._service) : super(ApplicationService.defaultApplications) {
    fetchApplications();
  }

  Future<void> fetchApplications() async {
    final apps = await _service.getApplications();
    state = apps;
  }

  void updateApplicationStatus(String id, ApplicationStatus newStatus) {
    state = [
      for (final app in state)
        if (app.id == id) app.copyWith(status: newStatus) else app,
    ];
  }

  void updateApplicationNotes(String id, String notes) {
    state = [
      for (final app in state)
        if (app.id == id) app.copyWith(notes: notes) else app,
    ];
  }
}

final applicationsProvider =
    StateNotifierProvider<ApplicationsNotifier, List<JobApplication>>((ref) {
  final service = ref.watch(applicationServiceProvider);
  return ApplicationsNotifier(service);
});

class ApplicationService {
  final ApiClient apiClient;

  ApplicationService(this.apiClient);

  Future<List<JobApplication>> getApplications() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.applications);
      if (response.data != null && response.data['data'] != null) {
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((a) => JobApplication.fromJson(a as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }
    return defaultApplications;
  }

  static const List<JobApplication> defaultApplications = [
    JobApplication(
      id: 'app_01',
      jobId: 'job_01',
      title: 'Junior AI Engineer',
      company: 'Axious Labs',
      location: 'Remote',
      status: ApplicationStatus.interviewing,
      appliedDate: '3 days ago',
      notes: 'Completed initial technical screening with lead engineer Ravi Prakash.',
      rounds: [
        InterviewRoundInfo(
          roundName: 'Round 1: Python & LLM Fundamentals',
          scheduledDate: 'Oct 8, 2026',
          interviewer: 'Ravi Prakash (Tech Lead)',
          feedback: 'Excellent problem solving on LangGraph cyclic state machine.',
        ),
        InterviewRoundInfo(
          roundName: 'Round 2: System Architecture & Scaling',
          scheduledDate: 'Oct 14, 2026',
          interviewer: 'Axious Core Engineering Team',
          feedback: null,
        ),
      ],
    ),
    JobApplication(
      id: 'app_02',
      jobId: 'job_02',
      title: 'Associate Machine Learning Engineer',
      company: 'TechFlow Systems',
      location: 'San Francisco, CA',
      status: ApplicationStatus.applied,
      appliedDate: '1 week ago',
      notes: 'Application submitted with updated resume highlighting LangGraph experience.',
      rounds: [],
    ),
    JobApplication(
      id: 'app_03',
      jobId: 'job_03',
      title: 'Junior Full-Stack & AI Developer',
      company: 'Nexus Innovations',
      location: 'Remote',
      status: ApplicationStatus.offer,
      appliedDate: '2 weeks ago',
      notes: 'Received formal offer for summer engineering cohort!',
      rounds: [
        InterviewRoundInfo(
          roundName: 'Technical Architecture & Live Coding',
          scheduledDate: 'Sep 29, 2026',
          interviewer: 'Elena Rostova (Engineering Director)',
          feedback: 'Outstanding clean code practices and Flutter widget test coverage.',
        ),
      ],
    ),
  ];
}
