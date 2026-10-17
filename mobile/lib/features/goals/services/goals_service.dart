import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/goal_model.dart';

class GoalsService {
  final ApiClient _apiClient;

  GoalsService([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  List<CareerGoal> get _defaultGoals => [
    CareerGoal(
      id: 'goal_1',
      userId: 'user_1',
      title: 'Master Flutter Advanced State Management & Architecture',
      description: 'Deep dive into Riverpod 2.0, code generation, custom linting, and offline caching patterns.',
      targetRole: 'Senior Flutter Engineer',
      category: GoalCategory.skillDevelopment,
      priority: GoalPriority.critical,
      status: GoalStatus.inProgress,
      progress: 60.0,
      startDate: DateTime.now().subtract(const Duration(days: 14)),
      targetDate: DateTime.now().add(const Duration(days: 20)),
      tags: const ['Flutter', 'Riverpod', 'Dart', 'Architecture'],
      milestones: [
        Milestone(
          id: 'ms_1_1',
          goalId: 'goal_1',
          title: 'Master StateNotifier and AsyncNotifier Provider Patterns',
          description: 'Build complete AsyncNotifier lifecycle handling error, loading, and refreshing states.',
          isCompleted: true,
          orderIndex: 0,
          resources: const [
            MilestoneResource(title: 'Riverpod 2.x Official Guide', url: 'https://riverpod.dev', type: 'documentation'),
          ],
        ),
        Milestone(
          id: 'ms_1_2',
          goalId: 'goal_1',
          title: 'Implement Network Interceptors and Token Refresh Flow',
          description: 'Configure Dio interceptors with automatic retry and secure storage synchronization.',
          isCompleted: true,
          orderIndex: 1,
          resources: const [
            MilestoneResource(title: 'Dio HTTP Architecture', url: 'https://pub.dev/packages/dio', type: 'article'),
          ],
        ),
        Milestone(
          id: 'ms_1_3',
          goalId: 'goal_1',
          title: 'Implement Unit, Widget, and Golden UI Tests',
          description: 'Achieve >85% code coverage with comprehensive test pump widget suites.',
          isCompleted: false,
          orderIndex: 2,
          dueDate: DateTime.now().add(const Duration(days: 7)),
        ),
      ],
    ),
    CareerGoal(
      id: 'goal_2',
      userId: 'user_1',
      title: 'Complete 30 Technical Interview Mock Simulations',
      description: 'Practice system design, DSA algorithms, and behavioral interview scenarios using AI feedback.',
      targetRole: 'Full Stack Mobile Engineer',
      category: GoalCategory.interviewPrep,
      priority: GoalPriority.high,
      status: GoalStatus.inProgress,
      progress: 40.0,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      targetDate: DateTime.now().add(const Duration(days: 35)),
      tags: ['Interview', 'System Design', 'Algorithms', 'AI Mock'],
      milestones: [
        Milestone(
          id: 'ms_2_1',
          goalId: 'goal_2',
          title: 'Complete 10 LeetCode Medium Data Structure Problems',
          description: 'Focus on sliding window, dynamic programming, and graphs.',
          isCompleted: true,
          orderIndex: 0,
        ),
        Milestone(
          id: 'ms_2_2',
          goalId: 'goal_2',
          title: 'Conduct 5 System Design Mock Sessions in CareerAI',
          description: 'Design scalable distributed systems for chat, newsfeed, and ride sharing.',
          isCompleted: false,
          orderIndex: 1,
          dueDate: DateTime.now().add(const Duration(days: 12)),
        ),
        Milestone(
          id: 'ms_2_3',
          goalId: 'goal_2',
          title: 'Behavioral STAR Method Story Bank Preparation',
          description: 'Prepare structured responses for 10 leadership and team conflict scenarios.',
          isCompleted: false,
          orderIndex: 2,
          dueDate: DateTime.now().add(const Duration(days: 20)),
        ),
      ],
    ),
    CareerGoal(
      id: 'goal_3',
      userId: 'user_1',
      title: 'Publish Production Portfolio App to App Store & Play Store',
      description: 'Build and deploy a full-featured open-source CareerAI companion with CI/CD automation.',
      targetRole: 'Mobile Tech Lead',
      category: GoalCategory.projectPortfolio,
      priority: GoalPriority.medium,
      status: GoalStatus.notStarted,
      progress: 0.0,
      startDate: DateTime.now(),
      targetDate: DateTime.now().add(const Duration(days: 60)),
      tags: ['DevOps', 'CI/CD', 'Fastlane', 'GitHub Actions'],
      milestones: [
        Milestone(
          id: 'ms_3_1',
          goalId: 'goal_3',
          title: 'Setup GitHub Actions CI/CD Pipeline for Automated Builds',
          isCompleted: false,
          orderIndex: 0,
        ),
        Milestone(
          id: 'ms_3_2',
          goalId: 'goal_3',
          title: 'Configure Fastlane for iOS TestFlight & Android Internal Tracks',
          isCompleted: false,
          orderIndex: 1,
        ),
      ],
    ),
  ];

  Future<List<CareerGoal>> fetchGoals() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.goals);
      if (response.statusCode == 200 && response.data is List) {
        final list = (response.data as List)
            .map((item) => CareerGoal.fromJson(item as Map<String, dynamic>))
            .toList();
        return list.isNotEmpty ? list : _defaultGoals;
      }
    } catch (_) {
      // Fallback gracefully to offline default goal list
    }
    return _defaultGoals;
  }

  Future<CareerGoal> createGoal(CareerGoal goal) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.goals,
        data: goal.toJson(),
      );
      if (response.statusCode == 201 && response.data is Map<String, dynamic>) {
        return CareerGoal.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {
      // Fallback
    }
    return goal;
  }

  Future<bool> toggleMilestone(String goalId, String milestoneId) async {
    try {
      final response = await _apiClient.dio.patch(
        '${ApiEndpoints.goals}/$goalId/milestones/$milestoneId/toggle',
      );
      return response.statusCode == 200;
    } catch (_) {
      return true; // Local optimistic success
    }
  }

  Future<bool> deleteGoal(String goalId) async {
    try {
      final response = await _apiClient.dio.delete('${ApiEndpoints.goals}/$goalId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return true;
    }
  }
}

// -----------------------------------------------------------------------------
// Riverpod State Management
// -----------------------------------------------------------------------------

class GoalsState {
  final List<CareerGoal> goals;
  final bool isLoading;
  final String? errorMessage;

  const GoalsState({
    this.goals = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  GoalsState copyWith({
    List<CareerGoal>? goals,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GoalsState(
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class GoalsNotifier extends StateNotifier<GoalsState> {
  final GoalsService _service;

  GoalsNotifier(this._service) : super(const GoalsState(isLoading: true)) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final goals = await _service.fetchGoals();
      state = state.copyWith(goals: goals, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load career goals: $e',
      );
    }
  }

  Future<void> toggleMilestone(String goalId, String milestoneId) async {
    final updatedGoals = state.goals.map((goal) {
      if (goal.id != goalId) return goal;

      final updatedMilestones = goal.milestones.map((ms) {
        if (ms.id != milestoneId) return ms;
        return ms.copyWith(isCompleted: !ms.isCompleted);
      }).toList();

      final completedCount = updatedMilestones.where((m) => m.isCompleted).length;
      final newProgress = updatedMilestones.isEmpty
          ? goal.progress
          : (completedCount / updatedMilestones.length) * 100.0;
      final newStatus = newProgress >= 100.0
          ? GoalStatus.completed
          : (newProgress > 0 ? GoalStatus.inProgress : GoalStatus.notStarted);

      return goal.copyWith(
        milestones: updatedMilestones,
        progress: newProgress,
        status: newStatus,
      );
    }).toList();

    state = state.copyWith(goals: updatedGoals);
    await _service.toggleMilestone(goalId, milestoneId);
  }

  Future<void> addGoal(CareerGoal newGoal) async {
    final created = await _service.createGoal(newGoal);
    state = state.copyWith(goals: [created, ...state.goals]);
  }

  Future<void> deleteGoal(String goalId) async {
    final filtered = state.goals.where((g) => g.id != goalId).toList();
    state = state.copyWith(goals: filtered);
    await _service.deleteGoal(goalId);
  }

  Future<void> updateGoalProgress(String goalId, double progress) async {
    final updated = state.goals.map((g) {
      if (g.id != goalId) return g;
      final status = progress >= 100.0 ? GoalStatus.completed : GoalStatus.inProgress;
      return g.copyWith(progress: progress, status: status);
    }).toList();
    state = state.copyWith(goals: updated);
  }
}

final goalsServiceProvider = Provider<GoalsService>((ref) => GoalsService());

final goalsNotifierProvider = StateNotifierProvider<GoalsNotifier, GoalsState>((ref) {
  final service = ref.watch(goalsServiceProvider);
  return GoalsNotifier(service);
});

final goalFilterCategoryProvider = StateProvider<GoalCategory?>((ref) => null);

final filteredGoalsProvider = Provider<List<CareerGoal>>((ref) {
  final goalsState = ref.watch(goalsNotifierProvider);
  final filterCategory = ref.watch(goalFilterCategoryProvider);

  if (filterCategory == null) {
    return goalsState.goals;
  }
  return goalsState.goals.where((g) => g.category == filterCategory).toList();
});

final goalSummaryStatsProvider = Provider<GoalSummaryStats>((ref) {
  final goals = ref.watch(goalsNotifierProvider).goals;
  return GoalSummaryStats.fromGoals(goals);
});
