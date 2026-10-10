import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/skills/models/skill_model.dart';
import 'package:careerai_mobile/features/skills/presentation/widgets/roadmap_timeline_widget.dart';

void main() {
  group('RoadmapTimelineWidget Tests', () {
    testWidgets('RoadmapTimelineWidget renders steps and handles toggle milestone', (WidgetTester tester) async {
      String? toggledMilestoneId;

      final testMilestones = [
        const RoadmapMilestone(
          id: 'ms_widget_1',
          weekNumber: 1,
          title: 'LangGraph State Graphs',
          description: 'Build cyclic agent workflows with checkpointers',
          estimatedHours: '6 hrs',
          recommendedResources: ['LangGraph Guide'],
          isCompleted: true,
        ),
        const RoadmapMilestone(
          id: 'ms_widget_2',
          weekNumber: 2,
          title: 'Vector Search Optimization',
          description: 'HNSW indexing in PostgreSQL',
          estimatedHours: '8 hrs',
          recommendedResources: ['pgvector Docs'],
          isCompleted: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RoadmapTimelineWidget(
                milestones: testMilestones,
                onToggleMilestone: (id) {
                  toggledMilestoneId = id;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Personalized Learning Roadmap'), findsOneWidget);
      expect(find.text('1/2 Done'), findsOneWidget);
      expect(find.text('LangGraph State Graphs'), findsOneWidget);
      expect(find.text('Vector Search Optimization'), findsOneWidget);
      expect(find.text('Week 1'), findsOneWidget);
      expect(find.text('Week 2'), findsOneWidget);

      await tester.tap(find.text('Week 1'));
      await tester.pump();

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();
      expect(toggledMilestoneId, 'ms_widget_1');
    });
  });
}