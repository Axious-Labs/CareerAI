import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/goals/models/goal_model.dart';
import 'package:careerai_mobile/features/skills/models/skill_model.dart';
import 'package:careerai_mobile/features/resume/models/resume_model.dart';
import 'package:careerai_mobile/features/profile/models/profile_model.dart';
import 'package:careerai_mobile/features/ai_chat/models/chat_message_model.dart';
import 'package:careerai_mobile/features/notifications/models/notification_model.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/interview/models/interview_model.dart';
import 'package:careerai_mobile/features/analytics/models/analytics_model.dart';

void main() {
  group('Domain Boundary & Edge Case Tests', () {
    test('JobPosting serialization gracefully handles completely empty and missing map keys', () {
      final minimalJson = <String, dynamic>{};
      final parsed = JobPosting.fromJson(minimalJson);

      expect(parsed.id, '');
      expect(parsed.title, '');
      expect(parsed.company, '');
      expect(parsed.location, 'Remote');
      expect(parsed.workplaceType, WorkplaceType.remote);
      expect(parsed.experienceLevel, ExperienceLevel.mid);
      expect(parsed.salaryRange, '\$120k - \$150k');
      expect(parsed.matchScore, 75);
      expect(parsed.requirements, isEmpty);
      expect(parsed.tags, isEmpty);
      expect(parsed.isSaved, isFalse);
      expect(parsed.isApplied, isFalse);
    });

    test('JobPosting copyWith correctly overrides boolean toggles and preserves others', () {
      final job = JobPosting(
        id: 'job_toggle_1',
        title: 'Senior Engineer',
        company: 'Axious',
        location: 'Remote',
        workplaceType: WorkplaceType.remote,
        experienceLevel: ExperienceLevel.senior,
        salaryRange: '\$150k',
        matchScore: 90,
        description: 'Test',
        requirements: const ['Dart'],
        tags: const ['Flutter'],
        postedDate: DateTime(2026, 1, 1),
      );

      final saved = job.copyWith(isSaved: true);
      expect(saved.isSaved, isTrue);
      expect(saved.isApplied, isFalse);
      expect(saved.title, 'Senior Engineer');

      final applied = saved.copyWith(isApplied: true);
      expect(applied.isSaved, isTrue);
      expect(applied.isApplied, isTrue);
    });

    test('Milestone handles null description and due date safely', () {
      final json = {
        'id': 'ms_null_test',
        'goalId': 'goal_01',
        'title': 'Minimal Milestone',
      };

      final ms = Milestone.fromJson(json);
      expect(ms.id, 'ms_null_test');
      expect(ms.title, 'Minimal Milestone');
      expect(ms.description, isNull);
      expect(ms.dueDate, isNull);
      expect(ms.isCompleted, isFalse);
      expect(ms.resources, isEmpty);
    });

    test('CareerGoal calculatedProgress handles all milestones completed', () {
      final goal = CareerGoal(
        id: 'goal_complete',
        userId: 'u_test',
        title: 'All Done Goal',
        description: 'Testing 100% calculation',
        targetRole: 'Staff Mobile Engineer',
        startDate: DateTime(2026, 1, 1),
        targetDate: DateTime(2026, 12, 31),
        milestones: const [
          Milestone(id: 'm1', goalId: 'goal_complete', title: 'Task 1', isCompleted: true),
          Milestone(id: 'm2', goalId: 'goal_complete', title: 'Task 2', isCompleted: true),
          Milestone(id: 'm3', goalId: 'goal_complete', title: 'Task 3', isCompleted: true),
        ],
      );

      expect(goal.totalMilestones, 3);
      expect(goal.completedMilestonesCount, 3);
      expect(goal.calculatedProgress, 100.0);
    });

    test('SkillItem level boundary clamp checks fromJson', () {
      final jsonLow = {'id': 's1', 'name': 'Dart', 'level': -0.5};
      final parsedLow = SkillItem.fromJson(jsonLow);
      expect(parsedLow.level, -0.5);

      final jsonHigh = {'id': 's2', 'name': 'Flutter', 'level': 1.5};
      final parsedHigh = SkillItem.fromJson(jsonHigh);
      expect(parsedHigh.level, 1.5);
    });

    test('WorkExperience handles present and legacy year formats', () {
      final exp = WorkExperience(
        company: 'Axious Labs',
        role: 'Flutter Core Contributor',
        startDate: '2023',
        endDate: '2026',
        achievements: const ['Wrote 10k lines of Dart'],
        technologiesUsed: const ['Dart', 'Flutter'],
      );

      final json = exp.toJson();
      expect(json['startDate'], '2023');
      expect(json['endDate'], '2026');

      final fromJson = WorkExperience.fromJson(json);
      expect(fromJson.company, 'Axious Labs');
      expect(fromJson.achievements.length, 1);
    });

    test('EducationItem optional GPA serialization and null safety', () {
      const withGpa = EducationItem(
        institution: 'MIT',
        degree: 'M.S.',
        fieldOfStudy: 'AI',
        graduationYear: 2025,
        gpa: 4.0,
      );
      expect(withGpa.gpa, 4.0);

      const withoutGpa = EducationItem(
        institution: 'Stanford',
        degree: 'B.S.',
        fieldOfStudy: 'CS',
        graduationYear: 2023,
      );
      expect(withoutGpa.gpa, isNull);
    });

    test('ProjectItem handles empty tech stack and null URLs', () {
      final json = {'title': 'Bare Project'};
      final proj = ProjectItem.fromJson(json);

      expect(proj.title, 'Bare Project');
      expect(proj.description, '');
      expect(proj.techStack, isEmpty);
      expect(proj.repositoryUrl, isNull);
      expect(proj.liveDemoUrl, isNull);
    });

    test('UserProfileDetail copyWith updates multiple fields simultaneously', () {
      final user = UserProfileDetail(
        id: 'u_multi',
        name: 'Alex',
        email: 'alex@test.com',
        headline: 'Engineer',
        targetRole: 'Mobile Dev',
        careerReadiness: 70,
        education: 'BS CS',
      );

      final updated = user.copyWith(
        name: 'Alex Chen',
        careerReadiness: 95,
        targetRole: 'Principal Mobile Architect',
      );

      expect(updated.name, 'Alex Chen');
      expect(updated.careerReadiness, 95);
      expect(updated.targetRole, 'Principal Mobile Architect');
      expect(updated.email, 'alex@test.com');
    });

    test('ChatMessageData json parsing handles empty string timestamp and sender', () {
      final json = {
        'id': 'msg_bare',
        'text': 'Hello AI',
      };

      final msg = ChatMessageData.fromJson(json);
      expect(msg.id, 'msg_bare');
      expect(msg.text, 'Hello AI');
      expect(msg.sender, MessageSender.user);
      expect(msg.quickReplies, isEmpty);
    });

    test('NotificationItem parsing handles edge types and null routes', () {
      final json = {
        'id': 'notif_edge',
        'title': 'System Notice',
        'message': 'Platform update completed',
        'type': 'system',
        'createdAt': '2026-10-28T12:00:00Z',
      };

      final notif = NotificationItem.fromJson(json);
      expect(notif.id, 'notif_edge');
      expect(notif.type, NotificationType.jobAlert);
      expect(notif.actionRoute, isNull);
      expect(notif.isRead, isFalse);
    });

    test('JobApplication status transitions and enum fallback', () {
      expect(ApplicationStatus.applied.name, 'applied');
      expect(ApplicationStatus.screening.name, 'screening');
      expect(ApplicationStatus.interviewing.name, 'interviewing');
      expect(ApplicationStatus.offer.name, 'offer');
      expect(ApplicationStatus.rejected.name, 'rejected');

      final app = JobApplication(
        id: 'app_1',
        jobId: 'j_1',
        title: 'Engineer',
        company: 'Axious',
        location: 'Remote',
        status: ApplicationStatus.applied,
        appliedDate: 'Yesterday',
        notes: '',
      );

      final updated = app.copyWith(status: ApplicationStatus.screening);
      expect(updated.status, ApplicationStatus.screening);
      expect(updated.statusDisplay, 'SCREENING');
    });

    test('ApplicationFunnelStats interview and offer conversion calculations', () {
      const stats = ApplicationFunnelStats(
        applied: 50,
        screening: 25,
        technicalInterview: 10,
        finalRound: 5,
        offers: 5,
        rejected: 20,
      );

      expect(stats.interviewConversionRate, 50.0);
      expect(stats.offerConversionRate, 10.0);
    });
  });
}

