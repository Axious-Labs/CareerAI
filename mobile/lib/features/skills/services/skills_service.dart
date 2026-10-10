import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/skill_model.dart';

final skillsServiceProvider = Provider<SkillsService>((ref) {
  return SkillsService(ApiClient());
});

class RoadmapNotifier extends StateNotifier<List<RoadmapMilestone>> {
  final SkillsService _service;

  RoadmapNotifier(this._service) : super(SkillsService.defaultRoadmap) {
    fetchRoadmap();
  }

  Future<void> fetchRoadmap() async {
    final roadmap = await _service.getRoadmapMilestones();
    state = roadmap;
  }

  void toggleMilestone(String milestoneId) {
    state = [
      for (final m in state)
        if (m.id == milestoneId) m.copyWith(isCompleted: !m.isCompleted) else m,
    ];
  }
}

final roadmapProvider =
    StateNotifierProvider<RoadmapNotifier, List<RoadmapMilestone>>((ref) {
  final service = ref.watch(skillsServiceProvider);
  return RoadmapNotifier(service);
});

class SkillsService {
  final ApiClient apiClient;

  SkillsService(this.apiClient);

  Future<List<SkillItem>> getUserSkills() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.userSkills);
      if (response.data != null && response.data['data'] != null) {
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((s) => SkillItem.fromJson(s as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }
    return defaultUserSkills;
  }

  Future<List<SkillGapItem>> getSkillGaps() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.skillGap);
      if (response.data != null && response.data['data'] != null) {
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((g) => SkillGapItem.fromJson(g as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }
    return defaultGaps;
  }

  Future<List<RoadmapMilestone>> getRoadmapMilestones() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.roadmap);
      if (response.data != null && response.data['data'] != null) {
        final list = response.data['data'] as List<dynamic>;
        return list
            .map((m) => RoadmapMilestone.fromJson(m as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback
    }
    return defaultRoadmap;
  }

  static const List<SkillItem> defaultUserSkills = [
    SkillItem(
      id: 'sk_1',
      name: 'Python',
      category: 'Programming Languages',
      proficiency: SkillProficiency.advanced,
      level: 0.88,
      isVerified: true,
      endorsedCount: 12,
    ),
    SkillItem(
      id: 'sk_2',
      name: 'Flutter & Dart',
      category: 'Mobile Engineering',
      proficiency: SkillProficiency.advanced,
      level: 0.85,
      isVerified: true,
      endorsedCount: 9,
    ),
    SkillItem(
      id: 'sk_3',
      name: 'FastAPI & Node.js',
      category: 'Backend Architecture',
      proficiency: SkillProficiency.intermediate,
      level: 0.72,
      isVerified: false,
      endorsedCount: 5,
    ),
    SkillItem(
      id: 'sk_4',
      name: 'Generative AI & LLMs',
      category: 'Artificial Intelligence',
      proficiency: SkillProficiency.intermediate,
      level: 0.68,
      isVerified: true,
      endorsedCount: 7,
    ),
    SkillItem(
      id: 'sk_5',
      name: 'Docker & Containers',
      category: 'DevOps & Infrastructure',
      proficiency: SkillProficiency.intermediate,
      level: 0.65,
      isVerified: false,
      endorsedCount: 4,
    ),
    SkillItem(
      id: 'sk_6',
      name: 'PostgreSQL & pgvector',
      category: 'Data Storage',
      proficiency: SkillProficiency.intermediate,
      level: 0.60,
      isVerified: false,
      endorsedCount: 3,
    ),
  ];

  static const List<SkillGapItem> defaultGaps = [
    SkillGapItem(
      skillName: 'LangGraph & Multi-Agent Loops',
      importance: 'HIGH',
      estimatedTimeToMaster: '2 weeks',
      rationale:
          'Essential for constructing autonomous agents with self-correcting iterative loops.',
    ),
    SkillGapItem(
      skillName: 'pgvector & Hybrid Semantic Search',
      importance: 'HIGH',
      estimatedTimeToMaster: '1 week',
      rationale:
          'Critical for scaling retrieval augmented generation beyond simple naive nearest neighbor search.',
    ),
    SkillGapItem(
      skillName: 'Model Quantization (AWQ/GPTQ) & vLLM',
      importance: 'MEDIUM',
      estimatedTimeToMaster: '3 weeks',
      rationale:
          'Reduces inference costs and latency in high-throughput enterprise deployments.',
    ),
  ];

  static const List<RoadmapMilestone> defaultRoadmap = [
    RoadmapMilestone(
      id: 'ms_1',
      weekNumber: 1,
      title: 'LangGraph Core Concepts & State Graphs',
      description:
          'Learn cyclical graphs, state transitions, conditional edges, and persistence checkpoints.',
      estimatedHours: '8 hrs',
      recommendedResources: [
        'LangGraph official quickstart guide',
        'Multi-agent collaboration patterns repo',
      ],
      isCompleted: true,
    ),
    RoadmapMilestone(
      id: 'ms_2',
      weekNumber: 2,
      title: 'pgvector Indexing (HNSW vs IVF) & RAG Evaluation',
      description:
          'Configure PostgreSQL pgvector, run Ragas evaluation metrics, and optimize recall at latency bounds.',
      estimatedHours: '10 hrs',
      recommendedResources: [
        'Postgres pgvector index benchmark docs',
        'Ragas framework tutorial for context recall',
      ],
      isCompleted: true,
    ),
    RoadmapMilestone(
      id: 'ms_3',
      weekNumber: 3,
      title: 'vLLM Serving & Quantized Deployment',
      description:
          'Set up local vLLM server with continuous batching and PagedAttention for low latency.',
      estimatedHours: '12 hrs',
      recommendedResources: [
        'vLLM high-throughput engine documentation',
        'TensorRT-LLM and HuggingFace TGI comparison',
      ],
      isCompleted: false,
    ),
    RoadmapMilestone(
      id: 'ms_4',
      weekNumber: 4,
      title: 'Full Autonomous Agent Integration Project',
      description:
          'Build end-to-end multi-agent evaluation bot and publish code to GitHub with automated CI/CD.',
      estimatedHours: '15 hrs',
      recommendedResources: [
        'Axious Labs CareerAI Agent Architecture Guidelines',
      ],
      isCompleted: false,
    ),
  ];
}
