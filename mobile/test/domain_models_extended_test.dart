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
  group('Extended Domain Models & Data Serialization Tests', () {
    test('JobPosting handles empty tags, missing requirements, and edge case dates', () {
      final json = {
        'id': 'job_edge_01',
        'title': 'Junior Mobile Engineer',
        'company': 'Axious',
        'location': 'New York',
        'workplaceType': 'hybrid',
        'experienceLevel': 'entry',
        'salaryRange': '\$90k - \$110k',
        'matchScore': 72,
        'description': 'Mobile engineering entry role.',
      };

      final job = JobPosting.fromJson(json);
      expect(job.workplaceType, WorkplaceType.hybrid);
      expect(job.workplaceLabel, 'Hybrid');
      expect(job.experienceLevel, ExperienceLevel.entry);
      expect(job.experienceLabel, 'Entry-level');
      expect(job.requirements, isEmpty);
      expect(job.tags, isEmpty);
      expect(job.isSaved, isFalse);
      expect(job.isApplied, isFalse);

      final exported = job.toJson();
      expect(exported['id'], 'job_edge_01');
      expect(exported['workplaceType'], 'hybrid');
    });

    test('JobPosting workplace and experience enums fallback to sensible defaults', () {
      expect(WorkplaceType.remote.label, 'Remote');
      expect(WorkplaceType.hybrid.label, 'Hybrid');
      expect(WorkplaceType.onsite.label, 'On-site');

      expect(ExperienceLevel.entry.label, 'Entry-level');
      expect(ExperienceLevel.mid.label, 'Mid-level');
      expect(ExperienceLevel.senior.label, 'Senior');
      expect(ExperienceLevel.lead.label, 'Lead / Principal');
    });

    test('CareerGoal milestones progress computation with zero milestones', () {
      final goalNoMilestones = CareerGoal(
        id: 'goal_empty_ms',
        userId: 'u_test',
        title: 'Empty Milestones Goal',
        description: 'Goal without milestones',
        targetRole: 'Architect',
        startDate: DateTime(2026, 1, 1),
        targetDate: DateTime(2026, 6, 1),
        milestones: const [],
      );

      expect(goalNoMilestones.totalMilestones, 0);
      expect(goalNoMilestones.completedMilestones, 0);
      expect(goalNoMilestones.calculatedProgress, 0.0);
    });

    test('CareerGoal handles overdue and remaining days computation', () {
      final baseDate = DateTime(2026, 10, 28);
      final futureGoal = CareerGoal(
        id: 'goal_future',
        userId: 'u_1',
        title: 'Future Goal',
        description: 'Description',
        targetRole: 'Lead',
        startDate: baseDate,
        targetDate: baseDate.add(const Duration(days: 14)),
      );

      expect(futureGoal.daysRemaining, greaterThanOrEqualTo(0));
      expect(futureGoal.isOverdue, isFalse);
    });

    test('MilestoneResource serializes and handles missing type string', () {
      final json = {'title': 'Documentation Guide', 'url': 'https://guide.dev'};
      final res = MilestoneResource.fromJson(json);
      expect(res.title, 'Documentation Guide');
      expect(res.type, 'resource');

      final out = res.toJson();
      expect(out['type'], 'resource');
    });

    test('SkillItem proficiency label mapping and verified state toggling', () {
      const skill = SkillItem(
        id: 'sk_1',
        name: 'Riverpod',
        category: 'State Management',
        proficiency: SkillProficiency.expert,
        level: 0.95,
        isVerified: true,
      );

      expect(skill.proficiencyLabel, 'Expert');
      expect(skill.proficiency, SkillProficiency.expert);

      final beginner = skill.copyWith(proficiency: SkillProficiency.beginner, level: 0.3);
      expect(beginner.proficiencyLabel, 'Beginner');
      expect(beginner.level, 0.3);

      final intermediate = skill.copyWith(proficiency: SkillProficiency.intermediate);
      expect(intermediate.proficiencyLabel, 'Intermediate');

      final advanced = skill.copyWith(proficiency: SkillProficiency.advanced);
      expect(advanced.proficiencyLabel, 'Advanced');
    });

    test('RoadmapMilestone copyWith preserves unmutated properties', () {
      const milestone = RoadmapMilestone(
        id: 'rm_01',
        weekNumber: 2,
        title: 'Learn Isolates',
        description: 'Spawn Dart background isolates',
        estimatedHours: '5 hrs',
        recommendedResources: ['Dart Docs'],
        isCompleted: false,
      );

      final completed = milestone.copyWith(isCompleted: true);
      expect(completed.id, 'rm_01');
      expect(completed.weekNumber, 2);
      expect(completed.title, 'Learn Isolates');
      expect(completed.isCompleted, true);
    });

    test('SkillGapItem toJson and fromJson consistency', () {
      final map = {
        'skillName': 'Dart C FFI',
        'importance': 'CRITICAL',
        'estimatedTimeToMaster': '3 weeks',
        'rationale': 'Native bindings for high performance',
      };

      final gap = SkillGapItem.fromJson(map);
      expect(gap.skillName, 'Dart C FFI');
      expect(gap.importance, 'CRITICAL');
      expect(gap.estimatedTimeToMaster, '3 weeks');

      final exported = gap.toJson();
      expect(exported['skillName'], 'Dart C FFI');
      expect(exported['importance'], 'CRITICAL');
    });

    test('ResumeData parsed metrics and calculations', () {
      final resume = ResumeData(
        id: 'r_01',
        fileName: 'resume.pdf',
        fileSizeBytes: 204800,
        uploadedAt: DateTime.now(),
        status: 'ANALYZED',
        atsScore: 92,
        keywordMatchPercentage: 88,
        readabilityScore: 95,
        summary: 'Expert mobile architect.',
        extractedSkills: const ['Flutter', 'Riverpod'],
        experiences: const [],
        education: const [],
        projects: const [],
      );

      expect(resume.formattedFileSize, contains('KB'));
      expect(resume.atsScore, 92);
      expect(resume.extractedSkills.length, 2);
    });

    test('WorkExperience date calculations and presentation', () {
      final exp = WorkExperience(
        company: 'Axious Labs',
        role: 'Mobile Architect',
        startDate: '2024-01-01',
        endDate: 'Present',
        achievements: const ['Built core Flutter client', '99.9% crash-free sessions'],
        technologiesUsed: const ['Flutter', 'Dart', 'Dio'],
      );

      expect(exp.company, 'Axious Labs');
      expect(exp.achievements.length, 2);
      expect(exp.technologiesUsed.length, 3);

      final json = exp.toJson();
      expect(json['role'], 'Mobile Architect');
      expect(json['endDate'], 'Present');
    });

    test('UserProfileDetail copyWith and CareerPreferences JSON serialization', () {
      const prefs = CareerPreferences(
        targetRole: 'Principal Engineer',
        location: 'Remote',
        remoteOnly: true,
        expectedMinSalary: 190000,
      );

      final json = prefs.toJson();
      expect(json['targetRole'], 'Principal Engineer');
      expect(json['expectedMinSalary'], 190000);

      final parsed = CareerPreferences.fromJson(json);
      expect(parsed.targetRole, prefs.targetRole);
      expect(parsed.expectedMinSalary, prefs.expectedMinSalary);
    });

    test('ChatMessageData formatting and quick replies support', () {
      final message = ChatMessageData(
        id: 'chat_01',
        text: 'How do I architect Flutter apps cleanly?',
        sender: MessageSender.user,
        timestamp: '11:00 AM',
        quickReplies: const ['Repository Pattern', 'Riverpod Notifiers'],
      );

      expect(message.isUser, isTrue);
      expect(message.quickReplies.length, 2);

      final json = message.toJson();
      expect(json['sender'], 'user');
      expect(json['quickReplies'], isA<List>());

      final fromJson = ChatMessageData.fromJson(json);
      expect(fromJson.text, message.text);
      expect(fromJson.sender, MessageSender.user);
    });

    test('NotificationItem handles category and relative route targeting', () {
      final item = NotificationItem(
        id: 'notif_001',
        title: 'New Interview Round',
        message: 'Your system architecture interview is confirmed',
        type: NotificationType.interviewReminder,
        createdAt: DateTime.now(),
        actionRoute: '/interview-prep',
      );

      expect(item.type, NotificationType.interviewReminder);
      expect(item.actionRoute, '/interview-prep');
      expect(item.isRead, isFalse);

      final readItem = item.copyWith(isRead: true);
      expect(readItem.isRead, isTrue);
    });

    test('JobApplication round info serializes correctly', () {
      const round = InterviewRoundInfo(
        roundName: 'Live Coding Round',
        scheduledDate: '2026-11-05',
        interviewer: 'Axious Staff Engineer',
        feedback: 'Excellent clean code conventions',
      );

      final json = round.toJson();
      expect(json['roundName'], 'Live Coding Round');
      expect(json['interviewer'], 'Axious Staff Engineer');

      final fromJson = InterviewRoundInfo.fromJson(json);
      expect(fromJson.roundName, round.roundName);
      expect(fromJson.feedback, round.feedback);
    });

    test('InterviewQuestion and AnswerEvaluationResult properties integrity', () {
      final question = InterviewQuestion(
        id: 'q_01',
        category: 'Architecture',
        question: 'Explain Flutter widget lifecycle and state management tradeoffs.',
        expectedKeyPoints: const ['didUpdateWidget', 'StatefulWidget vs Stateless', 'Riverpod'],
        sampleAnswerGuide: 'Cover rebuild scopes and performance optimizations.',
      );

      expect(question.expectedKeyPoints.length, 3);
      final json = question.toJson();
      expect(json['category'], 'Architecture');

      final eval = AnswerEvaluationResult(
        sessionId: 'sess_123',
        questionId: 'q_01',
        score: 95,
        feedback: 'Outstanding technical depth and clarity.',
        strengths: const ['Deep architectural knowledge', 'Clear verbal expression'],
        areasForImprovement: const ['Mention automated widget testing'],
      );

      expect(eval.score, 95);
      expect(eval.strengths.length, 2);
      expect(eval.areasForImprovement.first, contains('widget testing'));
    });

    test('CareerAnalyticsOverview serializes nested skill demands and salary benchmarks', () {
      const overview = CareerAnalyticsOverview(
        careerHealthScore: 89,
        profileCompleteness: 94,
        marketCompetitiveness: 91,
        salaryPercentile: 86,
        highDemandSkills: [
          SkillDemandItem(
            skillName: 'Flutter Riverpod',
            demandScore: 92,
            growthPercentage: 21.5,
            category: 'Mobile',
            jobPostingsCount: 1200,
          ),
        ],
        salaryBenchmarks: [
          SalaryBenchmarkItem(
            role: 'Senior Flutter Developer',
            juniorSalary: 95000,
            midSalary: 140000,
            seniorSalary: 185000,
            yoyGrowth: 11.2,
          ),
        ],
        funnelStats: ApplicationFunnelStats(
          applied: 30,
          screening: 15,
          technicalInterview: 8,
          finalRound: 4,
          offers: 2,
          rejected: 9,
        ),
        strategicRecommendations: ['Increase portfolio stars count'],
      );

      final json = overview.toJson();
      expect(json['careerHealthScore'], 89);
      expect((json['highDemandSkills'] as List).length, 1);
      expect((json['salaryBenchmarks'] as List).length, 1);

      final fromJson = CareerAnalyticsOverview.fromJson(json);
      expect(fromJson.careerHealthScore, 89);
      expect(fromJson.funnelStats.interviewConversionRate, 50.0);
    });
  });
}

