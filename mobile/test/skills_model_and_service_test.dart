import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/skills/models/skill_model.dart';
import 'package:careerai_mobile/features/skills/services/skills_service.dart';

void main() {
  group('Skills & Learning Roadmap Model Tests', () {
    test('SkillItem serialization and proficiency mapping', () {
      final json = {
        'id': 'sk_test_1',
        'name': 'Dart Concurrency & Isolates',
        'category': 'Mobile Engineering',
        'proficiency': 'advanced',
        'level': 0.85,
        'isVerified': true,
        'endorsedCount': 15,
      };

      final skill = SkillItem.fromJson(json);
      expect(skill.name, 'Dart Concurrency & Isolates');
      expect(skill.proficiency, SkillProficiency.advanced);
      expect(skill.proficiencyLabel, 'Advanced');
      expect(skill.level, 0.85);
      expect(skill.isVerified, isTrue);
      expect(skill.endorsedCount, 15);
    });

    test('RoadmapMilestone serialization and completion toggling', () {
      final json = {
        'id': 'ms_test_1',
        'weekNumber': 1,
        'title': 'Master Vector Indices',
        'description': 'Understand HNSW graph structure',
        'estimatedHours': '6 hrs',
        'recommendedResources': ['HNSW Paper', 'pgvector Docs'],
        'isCompleted': false,
      };

      final milestone = RoadmapMilestone.fromJson(json);
      expect(milestone.weekNumber, 1);
      expect(milestone.isCompleted, isFalse);

      final toggled = milestone.copyWith(isCompleted: true);
      expect(toggled.isCompleted, isTrue);
    });

    test('SkillGapItem serialization and priority level verification', () {
      final json = {
        'skillName': 'LangGraph Multi-Agent Workflows',
        'importance': 'HIGH',
        'estimatedTimeToMaster': '2 weeks',
        'rationale': 'Crucial for cyclic agent orchestration',
      };

      final gap = SkillGapItem.fromJson(json);
      expect(gap.skillName, 'LangGraph Multi-Agent Workflows');
      expect(gap.importance, 'HIGH');
      expect(gap.estimatedTimeToMaster, '2 weeks');
    });
  });

  group('SkillsService & RoadmapNotifier Tests', () {
    test('RoadmapNotifier milestone completion state updates', () {
      final service = SkillsService(ApiClient());
      final notifier = RoadmapNotifier(service);

      final defaultMs = SkillsService.defaultRoadmap;
      expect(defaultMs.isNotEmpty, isTrue);

      final targetId = defaultMs.first.id;
      final initialCompletion = defaultMs.first.isCompleted;

      notifier.toggleMilestone(targetId);
      final updatedMilestone = notifier.state.firstWhere((m) => m.id == targetId);
      expect(updatedMilestone.isCompleted, !initialCompletion);
    });
  });
}
