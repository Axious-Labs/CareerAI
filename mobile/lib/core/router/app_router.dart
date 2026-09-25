import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/resume/presentation/resume_screen.dart';
import '../../features/skills/presentation/skills_screen.dart';
import '../../features/jobs/presentation/jobs_screen.dart';
import '../../features/applications/presentation/applications_screen.dart';
import '../../features/ai_chat/presentation/ai_chat_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/resume',
        builder: (context, state) => const ResumeScreen(),
      ),
      GoRoute(
        path: '/skills',
        builder: (context, state) => const SkillsScreen(),
      ),
      GoRoute(
        path: '/jobs',
        builder: (context, state) => const JobsScreen(),
      ),
      GoRoute(
        path: '/applications',
        builder: (context, state) => const ApplicationsScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AiChatScreen(),
      ),
    ],
  );
}
