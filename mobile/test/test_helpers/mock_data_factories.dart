import 'package:careerai_mobile/features/jobs/models/job_model.dart';
import 'package:careerai_mobile/features/goals/models/goal_model.dart';
import 'package:careerai_mobile/features/skills/models/skill_model.dart';
import 'package:careerai_mobile/features/resume/models/resume_model.dart';
import 'package:careerai_mobile/features/profile/models/profile_model.dart';
import 'package:careerai_mobile/features/ai_chat/models/chat_message_model.dart';
import 'package:careerai_mobile/features/notifications/models/notification_model.dart';
import 'package:careerai_mobile/features/applications/models/application_model.dart';
import 'package:careerai_mobile/features/interview/models/interview_model.dart';

/// Centralized test fixtures and mock data factory for unit and widget test suites.
class MockDataFactory {
  MockDataFactory._();

  static JobPosting createJobPosting({
    String id = 'mock_job_default',
    String title = 'Staff Flutter Architect',
    String company = 'Axious Labs',
    String location = 'San Francisco, CA',
    WorkplaceType workplaceType = WorkplaceType.remote,
    ExperienceLevel experienceLevel = ExperienceLevel.senior,
    String salaryRange = '\$160k - \$210k',
    int matchScore = 96,
    String description = 'Lead architectural direction for Flutter mobile application.',
    List<String>? requirements,
    List<String>? tags,
    DateTime? postedDate,
    bool isSaved = false,
    bool isApplied = false,
  }) {
    return JobPosting(
      id: id,
      title: title,
      company: company,
      location: location,
      workplaceType: workplaceType,
      experienceLevel: experienceLevel,
      salaryRange: salaryRange,
      matchScore: matchScore,
      description: description,
      requirements: requirements ?? const ['5+ years Flutter experience', 'Riverpod state management'],
      tags: tags ?? const ['Flutter', 'Riverpod', 'Dart', 'CI/CD'],
      postedDate: postedDate ?? DateTime(2026, 10, 20),
      isSaved: isSaved,
      isApplied: isApplied,
    );
  }

  static CareerGoal createCareerGoal({
    String id = 'mock_goal_default',
    String userId = 'user_test_1',
    String title = 'Master Flutter Engine & Custom Render Objects',
    String description = 'Deep dive into Flutter rendering pipeline and custom shaders.',
    String targetRole = 'Principal Mobile Engineer',
    GoalCategory category = GoalCategory.skillDevelopment,
    GoalPriority priority = GoalPriority.critical,
    GoalStatus status = GoalStatus.inProgress,
    DateTime? startDate,
    DateTime? targetDate,
    List<Milestone>? milestones,
  }) {
    return CareerGoal(
      id: id,
      userId: userId,
      title: title,
      description: description,
      targetRole: targetRole,
      category: category,
      priority: priority,
      status: status,
      startDate: startDate ?? DateTime(2026, 10, 1),
      targetDate: targetDate ?? DateTime(2026, 12, 31),
      milestones: milestones ??
          [
            createMilestone(id: 'ms_1', goalId: id, title: 'Learn RenderBox Layout', isCompleted: true),
            createMilestone(id: 'ms_2', goalId: id, title: 'Implement Custom Shaders', isCompleted: false),
          ],
    );
  }

  static Milestone createMilestone({
    String id = 'ms_default_1',
    String goalId = 'goal_default_1',
    String title = 'Milestone Title',
    String? description = 'Detailed milestone roadmap objective description',
    bool isCompleted = false,
    DateTime? dueDate,
    int orderIndex = 0,
    List<MilestoneResource>? resources,
  }) {
    return Milestone(
      id: id,
      goalId: goalId,
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate ?? DateTime(2026, 11, 15),
      orderIndex: orderIndex,
      resources: resources ??
          const [
            MilestoneResource(
              title: 'Flutter Architectural Overview',
              url: 'https://docs.flutter.dev/resources/architectural-overview',
              type: 'documentation',
            ),
          ],
    );
  }

  static SkillItem createSkillItem({
    String id = 'skill_default_1',
    String name = 'Flutter & Dart Engine',
    String category = 'Mobile Engineering',
    SkillProficiency proficiency = SkillProficiency.advanced,
    double level = 0.90,
    bool isVerified = true,
    int endorsedCount = 34,
  }) {
    return SkillItem(
      id: id,
      name: name,
      category: category,
      proficiency: proficiency,
      level: level,
      isVerified: isVerified,
      endorsedCount: endorsedCount,
    );
  }

  static RoadmapMilestone createRoadmapMilestone({
    String id = 'roadmap_default_1',
    int weekNumber = 1,
    String title = 'Advanced Flutter Architecture',
    String description = 'Riverpod state graph modeling and repository patterns',
    String estimatedHours = '8 hrs',
    List<String>? recommendedResources,
    bool isCompleted = true,
  }) {
    return RoadmapMilestone(
      id: id,
      weekNumber: weekNumber,
      title: title,
      description: description,
      estimatedHours: estimatedHours,
      recommendedResources: recommendedResources ?? const ['Flutter Riverpod Docs', 'Clean Architecture in Dart'],
      isCompleted: isCompleted,
    );
  }

  static UserProfileDetail createUserProfile({
    String id = 'user_default_1',
    String name = 'Alex Chen',
    String email = 'alex.chen@axiouslabs.ai',
    String headline = 'Staff Flutter Engineer & Mobile AI Systems Architect',
    String targetRole = 'Staff Flutter Engineer',
    int careerReadiness = 88,
    String education = 'B.S. in Computer Science',
    CareerPreferences? preferences,
    List<CertificationItem>? certifications,
    List<PortfolioProject>? projects,
  }) {
    return UserProfileDetail(
      id: id,
      name: name,
      email: email,
      headline: headline,
      targetRole: targetRole,
      careerReadiness: careerReadiness,
      education: education,
      preferences: preferences ??
          const CareerPreferences(
            targetRole: 'Staff Flutter Engineer',
            location: 'Remote',
            remoteOnly: true,
            expectedMinSalary: 165000,
          ),
      certifications: certifications ??
          [
            CertificationItem(
              id: 'cert_mock_1',
              name: 'Google Cloud Professional Cloud Architect',
              issuer: 'Google Cloud',
              issueDate: DateTime(2026, 4, 1),
              credentialUrl: 'https://cloud.google.com/certification',
            ),
          ],
      projects: projects ??
          const [
            PortfolioProject(
              id: 'proj_mock_1',
              title: 'CareerAI Mobile Engine',
              description: 'AI Career platform app powered by Flutter and Riverpod',
              repoUrl: 'https://github.com/Axious-Labs/CareerAI',
              techStack: ['Flutter', 'Dart', 'Riverpod', 'Dio'],
              starsCount: 420,
            ),
          ],
    );
  }

  static ChatMessageData createChatMessage({
    String id = 'msg_mock_1',
    String text = 'How can I optimize Flutter widget rebuild cycles?',
    MessageSender sender = MessageSender.user,
    String timestamp = '10:30 AM',
    List<String>? quickReplies,
  }) {
    return ChatMessageData(
      id: id,
      text: text,
      sender: sender,
      timestamp: timestamp,
      quickReplies: quickReplies ?? const ['Use const constructors', 'Selector with Riverpod'],
    );
  }

  static NotificationItem createNotificationItem({
    String id = 'notif_mock_1',
    String title = 'Interview Schedule Confirmed',
    String message = 'Round 2 System Architecture scheduled with Axious Labs team lead.',
    NotificationType type = NotificationType.interviewReminder,
    DateTime? createdAt,
    bool isRead = false,
    String? actionRoute = '/applications',
  }) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      type: type,
      createdAt: createdAt ?? DateTime.now(),
      isRead: isRead,
      actionRoute: actionRoute,
    );
  }

  static JobApplication createJobApplication({
    String id = 'app_mock_1',
    String jobId = 'job_mock_1',
    String title = 'Staff Mobile Engineer',
    String company = 'Axious Labs',
    String location = 'San Francisco, CA',
    ApplicationStatus status = ApplicationStatus.interviewing,
    String appliedDate = '3 days ago',
    String notes = 'Passed initial portfolio screen with distinction',
    List<InterviewRoundInfo>? rounds,
  }) {
    return JobApplication(
      id: id,
      jobId: jobId,
      title: title,
      company: company,
      location: location,
      status: status,
      appliedDate: appliedDate,
      notes: notes,
      rounds: rounds ??
          const [
            InterviewRoundInfo(
              roundName: 'Architecture Deep Dive',
              scheduledDate: 'Nov 2, 2026',
              interviewer: 'Tech Lead',
              feedback: 'Great command of Dart isolate boundaries',
            ),
          ],
    );
  }

  static InterviewSessionData createInterviewSession({
    String sessionId = 'sess_mock_1',
    String targetRole = 'Staff Flutter Engineer',
    String difficulty = 'HARD',
    int totalQuestions = 1,
    String instructions = 'Respond clearly focusing on architecture and trade-offs.',
    List<InterviewQuestion>? questions,
  }) {
    return InterviewSessionData(
      sessionId: sessionId,
      targetRole: targetRole,
      difficulty: difficulty,
      totalQuestions: totalQuestions,
      instructions: instructions,
      questions: questions ??
          [
            InterviewQuestion(
              id: 'q_mock_1',
              category: 'Performance Optimization',
              question: 'How do you diagnose and eliminate frame drops (jank) in Flutter?',
              expectedKeyPoints: const [
                'Flutter DevTools Timeline',
                'RepaintBoundary',
                'Isolates for heavy computation',
                'Const widget constructors',
              ],
              sampleAnswerGuide: 'Profile UI and Raster threads using DevTools.',
            ),
          ],
    );
  }
}

