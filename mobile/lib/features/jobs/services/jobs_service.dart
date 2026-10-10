import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/job_model.dart';

final jobsServiceProvider = Provider<JobsService>((ref) {
  return JobsService(ApiClient());
});

class JobsListNotifier extends StateNotifier<List<JobPosting>> {
  final JobsService _service;

  JobsListNotifier(this._service) : super(JobsService.defaultJobList) {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final jobs = await _service.getRecommendedJobs();
    state = jobs;
  }

  void toggleSaveJob(String jobId) {
    state = [
      for (final job in state)
        if (job.id == jobId) job.copyWith(isSaved: !job.isSaved) else job,
    ];
  }

  void markApplied(String jobId) {
    state = [
      for (final job in state)
        if (job.id == jobId) job.copyWith(isApplied: true) else job,
    ];
  }
}

final jobsListProvider =
    StateNotifierProvider<JobsListNotifier, List<JobPosting>>((ref) {
  final service = ref.watch(jobsServiceProvider);
  return JobsListNotifier(service);
});

final jobFilterProvider = StateProvider<JobFilterState>((ref) {
  return const JobFilterState();
});

final filteredJobsProvider = Provider<List<JobPosting>>((ref) {
  final jobs = ref.watch(jobsListProvider);
  final filter = ref.watch(jobFilterProvider);

  return jobs.where((job) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final matchTitle = job.title.toLowerCase().contains(q);
      final matchCompany = job.company.toLowerCase().contains(q);
      final matchTag = job.tags.any((t) => t.toLowerCase().contains(q));
      if (!matchTitle && !matchCompany && !matchTag) return false;
    }

    if (filter.workplaceType != null &&
        job.workplaceType != filter.workplaceType) {
      return false;
    }

    if (job.matchScore < filter.minMatchScore) {
      return false;
    }

    if (filter.selectedTag != null &&
        !job.tags.contains(filter.selectedTag)) {
      return false;
    }

    return true;
  }).toList();
});

class JobsService {
  final ApiClient apiClient;

  JobsService(this.apiClient);

  Future<List<JobPosting>> getRecommendedJobs() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.jobs);
      if (response.data != null && response.data['data'] != null) {
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((j) => JobPosting.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }
    return defaultJobList;
  }

  static final List<JobPosting> defaultJobList = [
    JobPosting(
      id: 'job_01',
      title: 'Junior AI Engineer',
      company: 'Axious Labs',
      location: 'Remote',
      workplaceType: WorkplaceType.remote,
      experienceLevel: ExperienceLevel.entry,
      salaryRange: '\$115,000 - \$135,000',
      matchScore: 92,
      description:
          'Design and orchestrate agentic workflows, LangGraph graphs, and LLM-powered candidate interview modules.',
      requirements: const [
        'Proficiency with Python, FastAPI, and asynchronous concurrency',
        'Familiarity with LangChain / LangGraph orchestration',
        'Understanding of RAG embeddings and vector databases',
      ],
      tags: const ['Python', 'FastAPI', 'GenAI', 'LangGraph'],
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JobPosting(
      id: 'job_02',
      title: 'Associate Machine Learning Engineer',
      company: 'TechFlow Systems',
      location: 'San Francisco, CA (Hybrid)',
      workplaceType: WorkplaceType.hybrid,
      experienceLevel: ExperienceLevel.mid,
      salaryRange: '\$130,000 - \$160,000',
      matchScore: 84,
      description:
          'Deploy high-throughput inference endpoints, optimize latency with vLLM and quantization, and monitor model drift.',
      requirements: const [
        'Hands-on experience with PyTorch and huggingface models',
        'Docker containerization and Kubernetes orchestration',
        'Model quantization (AWQ, GPTQ) and caching strategies',
      ],
      tags: const ['PyTorch', 'Docker', 'Python', 'vLLM'],
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    JobPosting(
      id: 'job_03',
      title: 'Junior Full-Stack & AI Developer',
      company: 'Nexus Innovations',
      location: 'Remote',
      workplaceType: WorkplaceType.remote,
      experienceLevel: ExperienceLevel.entry,
      salaryRange: '\$105,000 - \$125,000',
      matchScore: 78,
      description:
          'Build elegant mobile experiences using Flutter and scalable REST/GraphQL APIs on Node.js and TypeScript.',
      requirements: const [
        'Strong knowledge of Flutter, Riverpod, and Dart best practices',
        'Experience building TypeScript backends with Express/NestJS',
        'Git workflow, PR reviews, and automated CI/CD pipeline setup',
      ],
      tags: const ['Flutter', 'TypeScript', 'Node.js', 'Riverpod'],
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    JobPosting(
      id: 'job_04',
      title: 'Cloud & MLOps Specialist',
      company: 'DataSphere Cloud',
      location: 'Seattle, WA (On-site)',
      workplaceType: WorkplaceType.onsite,
      experienceLevel: ExperienceLevel.mid,
      salaryRange: '\$140,000 - \$175,000',
      matchScore: 71,
      description:
          'Manage infrastructure as code, automated continuous deployment for AI pipelines, and Postgres vector stores.',
      requirements: const [
        'Terraform or AWS CloudFormation expertise',
        'PostgreSQL with pgvector extension management',
        'Observability with Prometheus, Grafana, and OpenTelemetry',
      ],
      tags: const ['AWS', 'Kubernetes', 'PostgreSQL', 'Terraform'],
      postedDate: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];
}
