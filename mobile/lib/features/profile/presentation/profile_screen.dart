import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import 'widgets/certification_card.dart';
import 'widgets/edit_profile_dialog.dart';
import 'widgets/portfolio_project_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showEditDialog(BuildContext context, UserProfileDetail profile) {
    showDialog(
      context: context,
      builder: (ctx) => EditProfileDialog(
        initialProfile: profile,
        onSave: (updated) {
          ref.read(profileNotifierProvider.notifier).updateProfile(updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Profile'),
        actions: [
          profileAsync.whenOrNull(
            data: (profile) => IconButton(
              icon: const Icon(Icons.edit, color: AppColors.accentLight),
              onPressed: () => _showEditDialog(context, profile),
              tooltip: 'Edit Profile',
            ),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, stack) => Center(child: Text('Error loading profile: $err')),
        data: (profile) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    children: [
                      // Avatar & Edit Action
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                              child: Text(
                                profile.name.isNotEmpty ? profile.name[0] : 'U',
                                style: const TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => _showEditDialog(context, profile),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, size: 14, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(profile.name, style: AppTextStyles.h2),
                      const SizedBox(height: 4),
                      Text(profile.headline, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 4),
                      Text(profile.email, style: AppTextStyles.bodySmall),
                      const SizedBox(height: 16),

                      // Career Readiness Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.speed, color: AppColors.accent, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Career Readiness',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${profile.careerReadiness}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.accentLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: profile.careerReadiness / 100.0,
                                      minHeight: 6,
                                      backgroundColor: AppColors.surfaceLight,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.accent,
                    labelColor: AppColors.accentLight,
                    unselectedLabelColor: AppColors.textSecondary,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Projects'),
                      Tab(text: 'Certificates'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Overview
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileTile(
                        icon: Icons.track_changes,
                        title: 'Target Role',
                        subtitle: profile.targetRole,
                        onTap: () {},
                      ),
                      _buildProfileTile(
                        icon: Icons.school,
                        title: 'Education',
                        subtitle: profile.education,
                        onTap: () {},
                      ),
                      _buildProfileTile(
                        icon: Icons.description,
                        title: 'Active Resume',
                        subtitle: 'Uploaded & ATS Optimized',
                        onTap: () => context.push('/resume'),
                      ),
                      _buildProfileTile(
                        icon: Icons.attach_money,
                        title: 'Expected Salary',
                        subtitle: '\$${profile.preferences.expectedMinSalary} USD / year',
                        onTap: () {},
                      ),
                      _buildProfileTile(
                        icon: Icons.location_on_outlined,
                        title: 'Work Mode',
                        subtitle: profile.preferences.remoteOnly ? 'Remote Only' : profile.preferences.location,
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // Tab 2: Projects
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: profile.projects.map((p) => PortfolioProjectCard(project: p)).toList(),
                ),

                // Tab 3: Certifications
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: profile.certifications.map((c) => CertificationCard(item: c)).toList(),
                ),
              ],
            ),
          );
        },
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

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
