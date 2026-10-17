import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/goals/models/goal_model.dart';
import 'package:careerai_mobile/features/goals/services/goals_service.dart';

void main() {
  group('Goal Models & Enums Tests', () {
    test('GoalCategory fromString parses all variants and handles null/invalid gracefully', () {
      expect(GoalCategory.fromString('skillDevelopment'), GoalCategory.skillDevelopment);
      expect(GoalCategory.fromString('job_search'), GoalCategory.jobSearch);
      expect(GoalCategory.fromString('interview prep'), GoalCategory.interviewPrep);
      expect(GoalCategory.fromString('projectPortfolio'), GoalCategory.projectPortfolio);
      expect(GoalCategory.fromString('certification'), GoalCategory.certification);
      expect(GoalCategory.fromString('networking'), GoalCategory.networking);
      expect(GoalCategory.fromString(null), GoalCategory.skillDevelopment);
      expect(GoalCategory.fromString('unknown_category'), GoalCategory.skillDevelopment);
    });

    test('GoalPriority fromString parses priority and provides display labels', () {
      expect(GoalPriority.fromString('low'), GoalPriority.low);
      expect(GoalPriority.fromString('medium'), GoalPriority.medium);
      expect(GoalPriority.fromString('high'), GoalPriority.high);
      expect(GoalPriority.fromString('critical'), GoalPriority.critical);
      expect(GoalPriority.fromString(null), GoalPriority.medium);

      expect(GoalPriority.critical.label, 'Critical Priority');
      expect(GoalPriority.high.label, 'High Priority');
      expect(GoalPriority.medium.label, 'Medium Priority');
      expect(GoalPriority.low.label, 'Low Priority');
    });

    test('GoalStatus fromString parses status and provides labels', () {
      expect(GoalStatus.fromString('notStarted'), GoalStatus.notStarted);
      expect(GoalStatus.fromString('in_progress'), GoalStatus.inProgress);
      expect(GoalStatus.fromString('completed'), GoalStatus.completed);
      expect(GoalStatus.fromString('on_hold'), GoalStatus.onHold);
      expect(GoalStatus.fromString(null), GoalStatus.inProgress);
    });

    test('MilestoneResource serializes and deserializes correctly', () {
      final resource = MilestoneResource(
        title: 'Riverpod Docs',
        url: 'https://riverpod.dev',
        type: 'documentation',
      );

      final json = resource.toJson();
      expect(json['title'], 'Riverpod Docs');
      expect(json['url'], 'https://riverpod.dev');
      expect(json['type'], 'documentation');

      final fromJson = MilestoneResource.fromJson(json);
      expect(fromJson.title, resource.title);
      expect(fromJson.url, resource.url);
      expect(fromJson.type, resource.type);
    });

    test('Milestone copyWith and JSON round-trip preserve all properties', () {
      final ms = Milestone(
        id: 'ms_1',
        goalId: 'goal_100',
        title: 'Learn Dart 3 Records',
        description: 'Explore pattern matching and destructuring',
        isCompleted: false,
        dueDate: DateTime(2026, 12, 1),
        orderIndex: 1,
        resources: const [
          MilestoneResource(title: 'Dart Tour', url: 'https://dart.dev', type: 'guide'),
        ],
      );

      final updated = ms.copyWith(isCompleted: true);
      expect(updated.isCompleted, true);
      expect(updated.title, ms.title);

      final json = ms.toJson();
      final deserialized = Milestone.fromJson(json);
      expect(deserialized.id, ms.id);
      expect(deserialized.goalId, ms.goalId);
      expect(deserialized.title, ms.title);
      expect(deserialized.resources.length, 1);
    });

    test('CareerGoal calculatedProgress calculates accurate completion percentage', () {
      final goalWithMilestones = CareerGoal(
        id: 'goal_calc',
        userId: 'u1',
        title: 'Test Goal',
        description: 'Testing calculation',
        targetRole: 'Flutter Dev',
        startDate: DateTime.now(),
        targetDate: DateTime.now().add(const Duration(days: 10)),
        milestones: const [
          Milestone(id: '1', goalId: 'goal_calc', title: 'Step 1', isCompleted: true),
          Milestone(id: '2', goalId: 'goal_calc', title: 'Step 2', isCompleted: false),
          Milestone(id: '3', goalId: 'goal_calc', title: 'Step 3', isCompleted: true),
          Milestone(id: '4', goalId: 'goal_calc', title: 'Step 4', isCompleted: false),
        ],
      );

      expect(goalWithMilestones.totalMilestones, 4);
      expect(goalWithMilestones.completedMilestonesCount, 2);
      expect(goalWithMilestones.calculatedProgress, 50.0);
    });

    test('CareerGoal isOverdue detects target date overrun when not completed', () {
      final overdueGoal = CareerGoal(
        id: 'goal_overdue',
        userId: 'u1',
        title: 'Past Goal',
        description: 'Overdue',
        targetRole: 'Dev',
        status: GoalStatus.inProgress,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        targetDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(overdueGoal.isOverdue, true);

      final completedGoal = overdueGoal.copyWith(status: GoalStatus.completed);
      expect(completedGoal.isOverdue, false);
    });

    test('GoalSummaryStats calculates aggregate totals and averages across goals', () {
      final goals = [
        CareerGoal(
          id: 'g1',
          userId: 'u1',
          title: 'Goal 1',
          description: '',
          targetRole: 'Role',
          status: GoalStatus.completed,
          startDate: DateTime.now(),
          targetDate: DateTime.now().add(const Duration(days: 5)),
          milestones: const [
            Milestone(id: 'm1', goalId: 'g1', title: 'M1', isCompleted: true),
          ],
        ),
        CareerGoal(
          id: 'g2',
          userId: 'u1',
          title: 'Goal 2',
          description: '',
          targetRole: 'Role',
          status: GoalStatus.inProgress,
          startDate: DateTime.now(),
          targetDate: DateTime.now().add(const Duration(days: 10)),
          milestones: const [
            Milestone(id: 'm2', goalId: 'g2', title: 'M2', isCompleted: false),
            Milestone(id: 'm3', goalId: 'g2', title: 'M3', isCompleted: true),
          ],
        ),
      ];

      final stats = GoalSummaryStats.fromGoals(goals);
      expect(stats.totalGoals, 2);
      expect(stats.completedGoals, 1);
      expect(stats.inProgressGoals, 1);
      expect(stats.totalMilestones, 3);
      expect(stats.completedMilestones, 2);
      expect(stats.averageProgress, 75.0);
    });
  });

  group('GoalsService & Notifier Tests', () {
    test('GoalsService provides robust default fallback goals', () async {
      final service = GoalsService();
      final goals = await service.fetchGoals();
      expect(goals.isNotEmpty, true);
      expect(goals.any((g) => g.title.contains('Flutter')), true);
    });

    test('GoalsNotifier initializes and toggles milestone states with progress update', () async {
      final service = GoalsService();
      final notifier = GoalsNotifier(service);

      await notifier.loadGoals();
      expect(notifier.state.goals.isNotEmpty, true);

      final initialGoal = notifier.state.goals.first;
      final initialMilestone = initialGoal.milestones.first;
      final originalCompleted = initialMilestone.isCompleted;

      await notifier.toggleMilestone(initialGoal.id, initialMilestone.id);

      final updatedGoal = notifier.state.goals.firstWhere((g) => g.id == initialGoal.id);
      final updatedMilestone = updatedGoal.milestones.firstWhere((m) => m.id == initialMilestone.id);

      expect(updatedMilestone.isCompleted, !originalCompleted);
    });

    test('GoalsNotifier adds and removes career goals seamlessly', () async {
      final service = GoalsService();
      final notifier = GoalsNotifier(service);
      await notifier.loadGoals();

      final initialCount = notifier.state.goals.length;
      final newGoal = CareerGoal(
        id: 'new_test_goal_999',
        userId: 'u1',
        title: 'New Unit Test Goal',
        description: 'Test addition',
        targetRole: 'Staff Engineer',
        startDate: DateTime.now(),
        targetDate: DateTime.now().add(const Duration(days: 15)),
      );

      await notifier.addGoal(newGoal);
      expect(notifier.state.goals.length, initialCount + 1);
      expect(notifier.state.goals.first.id, 'new_test_goal_999');

      await notifier.deleteGoal('new_test_goal_999');
      expect(notifier.state.goals.length, initialCount);
      expect(notifier.state.goals.any((g) => g.id == 'new_test_goal_999'), false);
    });
  });
}
