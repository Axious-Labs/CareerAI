class ApiEndpoints {
  // Base Gateway URL (points to Node.js Backend Gateway)
  static const String baseUrl = 'http://localhost:5000/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // User & Profile
  static const String userMe = '/users/me';

  // Skills
  static const String skills = '/skills';
  static const String userSkills = '/skills/user';

  // Resumes
  static const String uploadResume = '/resumes/upload';
  static const String resumes = '/resumes';

  // Jobs & Applications
  static const String jobs = '/jobs';
  static const String applications = '/applications';

  // Career Intelligence & AI
  static const String chat = '/chat';
  static const String careerAnalyze = '/career/analyze';
  static const String skillGap = '/career/skill-gap';
  static const String roadmap = '/career/roadmap';

  // Mock Technical Interviews
  static const String startInterview = '/interviews/start';
  static const String evaluateAnswer = '/interviews/evaluate';
  static const String interviewHistory = '/interviews/history';

  // Career Goals & Milestones
  static const String goals = '/goals';
  static const String goalSummary = '/goals/summary';

  // Analytics & Market Intelligence
  static const String analytics = '/analytics/overview';
  static const String salaryBenchmarks = '/analytics/salaries';

  // Notifications & Alerts
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/read';
}
