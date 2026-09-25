import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final userName = user?.name ?? 'Alex';
    final targetRole = user?.targetRole ?? 'AI/ML Engineer';
    final readiness = user?.careerReadiness ?? 68;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.accent, size: 24),
            const SizedBox(width: 8),
            const Text('CareerAI', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Axious Labs',
                style: TextStyle(color: AppColors.accentLight, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.textPrimary),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Greeting
            Text('Hello, $userName', style: AppTextStyles.h1),
            const SizedBox(height: 16),

            // 2. Target Role & Career Readiness Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceLight.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Target Role', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(
                            targetRole,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentLight,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent),
                        ),
                        child: Text(
                          '$readiness%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Career Readiness', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: readiness / 100,
                      minHeight: 10,
                      backgroundColor: AppColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Skills Progress Section
            const Text('Skills', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            _buildSkillBar('Python', 0.80, '80%'),
            _buildSkillBar('Flutter', 0.70, '70%'),
            _buildSkillBar('GenAI', 0.60, '60%'),
            _buildSkillBar('ML', 0.40, '40%'),
            const SizedBox(height: 24),

            // 4. Today's Career Plan Section
            const Text("Today's Career Plan", style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildPlanItem(title: 'Complete Transformers lesson', completed: true),
                  const Divider(color: AppColors.border, height: 1),
                  _buildPlanItem(title: 'Solve 2 DSA problems', completed: true),
                  const Divider(color: AppColors.border, height: 1),
                  _buildPlanItem(title: 'Apply to 3 relevant jobs', completed: false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Quick Actions Section
            const Text('Quick Actions', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildActionButton(
                  context,
                  title: 'Analyze Resume',
                  icon: Icons.upload_file,
                  route: '/resume',
                ),
                _buildActionButton(
                  context,
                  title: 'Skill Gap',
                  icon: Icons.compare_arrows,
                  route: '/skills',
                ),
                _buildActionButton(
                  context,
                  title: 'Find Jobs',
                  icon: Icons.work_outline,
                  route: '/jobs',
                ),
                _buildActionButton(
                  context,
                  title: 'AI Career Assistant',
                  icon: Icons.chat_bubble_outline,
                  route: '/ai-chat',
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/skills');
              break;
            case 2:
              context.push('/jobs');
              break;
            case 3:
              context.push('/applications');
              break;
            case 4:
              context.push('/ai-chat');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Skills'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Chat'),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String skillName, double progress, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skillName, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
              Text(label, style: const TextStyle(color: AppColors.accentLight, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem({required String title, required bool completed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? AppColors.success : AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: completed ? AppColors.textPrimary : AppColors.textSecondary,
                decoration: completed ? TextDecoration.lineThrough : null,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
