import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/goals/models/goal_model.dart';
import 'package:careerai_mobile/features/goals/services/goals_service.dart';
import 'package:careerai_mobile/features/goals/presentation/widgets/goal_card.dart';
import 'package:careerai_mobile/features/goals/presentation/widgets/milestone_tile.dart';
import 'package:careerai_mobile/features/goals/presentation/goals_screen.dart';

class MockGoalsService extends GoalsService {
  @override
  Future<List<CareerGoal>> fetchGoals() async {
    return [
      CareerGoal(
        id: 'mock_goal_1',
        userId: 'u1',
        title: 'Master Flutter State Management',
        description: 'Complete all async state management patterns',
        targetRole: 'Senior Flutter Dev',
        priority: GoalPriority.critical,
        category: GoalCategory.skillDevelopment,
        startDate: DateTime.now(),
        targetDate: DateTime.now().add(const Duration(days: 15)),
        milestones: const [
          Milestone(id: 'ms_sub_1', goalId: 'mock_goal_1', title: 'StateNotifier Test', isCompleted: true),
        ],
      ),
    ];
  }
}

void main() {
  group('Goal Widgets Unit Tests', () {
    testWidgets('MilestoneTile renders correctly and responds to toggle checkbox', (tester) async {
      bool? toggledValue;
      final testMilestone = Milestone(
        id: 'ms_tile_test',
        goalId: 'goal_tile_test',
        title: 'Review System Architecture Diagrams',
        description: 'Analyze microservices and data pipelines',
        isCompleted: false,
        resources: const [
          MilestoneResource(title: 'AWS Docs', url: 'https://aws.amazon.com', type: 'guide'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MilestoneTile(
              milestone: testMilestone,
              onToggle: (val) {
                toggledValue = val;
              },
            ),
          ),
        ),
      );

      expect(find.text('Review System Architecture Diagrams'), findsOneWidget);
      expect(find.text('Analyze microservices and data pipelines'), findsOneWidget);
      expect(find.text('AWS Docs'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggledValue, true);
    });

    testWidgets('GoalCard renders badges, progress, and expands milestone checklist', (tester) async {
      String? toggledMilestoneId;
      final testGoal = CareerGoal(
        id: 'goal_card_1',
        userId: 'u1',
        title: 'Master Riverpod 2.0',
        description: 'Complete all async state management patterns',
        targetRole: 'Senior Flutter Dev',
        priority: GoalPriority.critical,
        category: GoalCategory.skillDevelopment,
        startDate: DateTime.now(),
        targetDate: DateTime.now().add(const Duration(days: 15)),
        milestones: const [
          Milestone(id: 'ms_sub_1', goalId: 'goal_card_1', title: 'StateNotifier Test', isCompleted: true),
          Milestone(id: 'ms_sub_2', goalId: 'goal_card_1', title: 'AsyncNotifier Test', isCompleted: false),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: GoalCard(
                goal: testGoal,
                onToggleMilestone: (mId) {
                  toggledMilestoneId = mId;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Master Riverpod 2.0'), findsOneWidget);
      expect(find.text('Critical Priority'), findsOneWidget);
      expect(find.text('Skill Mastery'), findsOneWidget);
      expect(find.text('Senior Flutter Dev'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);

      // Expand Milestones
      expect(find.text('View Milestones (2)'), findsOneWidget);
      await tester.tap(find.text('View Milestones (2)'));
      await tester.pump();

      expect(find.text('StateNotifier Test'), findsOneWidget);
      expect(find.text('AsyncNotifier Test'), findsOneWidget);

      // Tap on second milestone
      final checkboxes = find.byType(Checkbox);
      expect(checkboxes, findsNWidgets(2));
      await tester.tap(checkboxes.at(1));
      await tester.pump();

      expect(toggledMilestoneId, 'ms_sub_2');
    });

    testWidgets('GoalsScreen renders with ProviderScope and displays intelligence banner', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsServiceProvider.overrideWithValue(MockGoalsService()),
          ],
          child: const MaterialApp(
            home: GoalsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Career Goals & Roadmaps'), findsOneWidget);
      expect(find.text('Goal Execution Intelligence'), findsOneWidget);
      expect(find.text('All Categories'), findsOneWidget);
    });
  });
}
