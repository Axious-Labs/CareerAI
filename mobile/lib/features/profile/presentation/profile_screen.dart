import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.accent.withOpacity(0.2),
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0] : 'U',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'Alex Chen', style: AppTextStyles.h2),
            const SizedBox(height: 4),
            Text(user?.email ?? 'alex.chen@university.edu', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            _buildProfileTile(
              icon: Icons.track_changes,
              title: 'Target Role',
              subtitle: user?.targetRole ?? 'AI/ML Engineer',
              onTap: () {},
            ),
            _buildProfileTile(
              icon: Icons.speed,
              title: 'Career Readiness',
              subtitle: '${user?.careerReadiness ?? 68}% Prepared',
              onTap: () {},
            ),
            _buildProfileTile(
              icon: Icons.description,
              title: 'Active Resume',
              subtitle: 'Alex_Chen_Resume_2026.pdf',
              onTap: () => context.push('/resume'),
            ),
            _buildProfileTile(
              icon: Icons.school,
              title: 'Education',
              subtitle: 'B.S. in Computer Science',
              onTap: () {},
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
