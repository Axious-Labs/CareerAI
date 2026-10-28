import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/goals/models/goal_model.dart';
import 'package:careerai_mobile/features/skills/models/skill_model.dart';
import 'package:careerai_mobile/features/notifications/models/notification_model.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/ai_chat/models/chat_message_model.dart';
import 'test_helpers/mock_data_factories.dart';

void main() {
  group('MockDataFactory Unit Tests', () {
    test('createJobPosting generates realistic job model with defaults and overrides', () {
      final defaultJob = MockDataFactory.createJobPosting();
      expect(defaultJob.id, 'mock_job_default');
      expect(defaultJob.title, 'Staff Flutter Architect');
      expect(defaultJob.workplaceType, WorkplaceType.remote);
      expect(defaultJob.requirements.isNotEmpty, isTrue);
      expect(defaultJob.tags.contains('Flutter'), isTrue);

      final customJob = MockDataFactory.createJobPosting(
        id: 'custom_01',
        title: 'Lead AI Engineer',
        salaryRange: '\$180k - \$220k',
        isSaved: true,
      );
      expect(customJob.id, 'custom_01');
      expect(customJob.title, 'Lead AI Engineer');
      expect(customJob.salaryRange, '\$180k - \$220k');
      expect(customJob.isSaved, isTrue);
    });

    test('createCareerGoal initializes milestones and calculates progress properly', () {
      final goal = MockDataFactory.createCareerGoal();
      expect(goal.title.contains('Flutter Engine'), isTrue);
      expect(goal.priority, GoalPriority.critical);
      expect(goal.milestones.length, 2);
      expect(goal.calculatedProgress, 50.0);
    });

    test('createMilestone sets properties and nested resources', () {
      final ms = MockDataFactory.createMilestone(
        title: 'Verify Isolate Pools',
        isCompleted: true,
      );
      expect(ms.title, 'Verify Isolate Pools');
      expect(ms.isCompleted, isTrue);
      expect(ms.resources.isNotEmpty, isTrue);
      expect(ms.resources.first.title.contains('Flutter'), isTrue);
    });

    test('createSkillItem initializes proficiency metrics', () {
      final skill = MockDataFactory.createSkillItem(
        name: 'Dart Records & Patterns',
        proficiency: SkillProficiency.expert,
        level: 0.95,
      );
      expect(skill.name, 'Dart Records & Patterns');
      expect(skill.proficiency, SkillProficiency.expert);
      expect(skill.level, 0.95);
      expect(skill.isVerified, isTrue);
    });

    test('createRoadmapMilestone returns structured milestone roadmap step', () {
      final rm = MockDataFactory.createRoadmapMilestone(weekNumber: 3);
      expect(rm.weekNumber, 3);
      expect(rm.isCompleted, isTrue);
      expect(rm.recommendedResources.isNotEmpty, isTrue);
    });

    test('createUserProfile instantiates full nested portfolio and credentials', () {
      final profile = MockDataFactory.createUserProfile();
      expect(profile.name, 'Alex Chen');
      expect(profile.headline.contains('Flutter'), isTrue);
      expect(profile.careerReadiness, 88);
      expect(profile.preferences.remoteOnly, isTrue);
      expect(profile.certifications.isNotEmpty, isTrue);
      expect(profile.projects.isNotEmpty, isTrue);
      expect(profile.projects.first.starsCount, 420);
    });

    test('createChatMessage validates user vs assistant sender states', () {
      final userMsg = MockDataFactory.createChatMessage(sender: MessageSender.user);
      expect(userMsg.isUser, isTrue);

      final aiMsg = MockDataFactory.createChatMessage(
        sender: MessageSender.ai,
        text: 'Consider using Flutter DevTools timeline for micro-optimizations.',
      );
      expect(aiMsg.isUser, isFalse);
      expect(aiMsg.text.contains('DevTools'), isTrue);
    });

    test('createNotificationItem validates types and read status', () {
      final notif = MockDataFactory.createNotificationItem(isRead: true);
      expect(notif.isRead, isTrue);
      expect(notif.type, NotificationType.interviewReminder);
      expect(notif.actionRoute, '/applications');
    });

    test('createJobApplication verifies application rounds and status', () {
      final app = MockDataFactory.createJobApplication();
      expect(app.company, 'Axious Labs');
      expect(app.status, ApplicationStatus.interviewing);
      expect(app.rounds.isNotEmpty, isTrue);
      expect(app.rounds.first.roundName, 'Architecture Deep Dive');
    });

    test('createInterviewSession initializes mock interview question tree', () {
      final session = MockDataFactory.createInterviewSession();
      expect(session.sessionId, 'sess_mock_1');
      expect(session.difficulty, 'HARD');
      expect(session.questions.length, 1);
      expect(session.questions.first.expectedKeyPoints.contains('Flutter DevTools Timeline'), isTrue);
    });

    test('createResumeData instantiates valid structured resume metrics', () {
      final resume = MockDataFactory.createResumeData();
      expect(resume.id, 'res_mock_default');
      expect(resume.atsScore, 91);
      expect(resume.extractedSkills.contains('Flutter'), isTrue);
      expect(resume.experiences.isNotEmpty, isTrue);
      expect(resume.recommendedImprovements.isNotEmpty, isTrue);
    });
  });
}

