import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../models/goal_model.dart';
import '../services/goals_service.dart';
import 'widgets/create_goal_dialog.dart';
import 'widgets/goal_card.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => CreateGoalDialog(
        onGoalCreated: (newGoal) {
          ref.read(goalsNotifierProvider.notifier).addGoal(newGoal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(goalsNotifierProvider);
    final filteredGoals = ref.watch(filteredGoalsProvider);
    final activeFilter = ref.watch(goalFilterCategoryProvider);
    final stats = ref.watch(goalSummaryStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Goals & Roadmaps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.accentLight),
            onPressed: () => _showCreateDialog(context, ref),
            tooltip: 'Add Goal',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primary,
        onPressed: () => _showCreateDialog(context, ref),
        icon: const Icon(Icons.add_task),
        label: const Text('New Goal', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(goalsNotifierProvider.notifier).loadGoals(),
        color: AppColors.accent,
        child: goalsState.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 1. Career Goal Summary Metrics Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surface,
                          AppColors.surfaceLight.withValues(alpha: 0.7),
                        ],
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
                            const Text(
                              'Goal Execution Intelligence',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${stats.averageProgress.toInt()}% On Track',
                                style: const TextStyle(
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem('Total Goals', '${stats.totalGoals}', Icons.flag),
                            _buildSummaryItem('Active', '${stats.inProgressGoals}', Icons.timelapse),
                            _buildSummaryItem('Completed', '${stats.completedGoals}', Icons.task_alt),
                            _buildSummaryItem(
                              'Milestones',
                              '${stats.completedMilestones}/${stats.totalMilestones}',
                              Icons.checklist_rtl,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (stats.averageProgress / 100.0).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: AppColors.secondary,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'All Categories',
                          isSelected: activeFilter == null,
                          onSelected: () =>
                              ref.read(goalFilterCategoryProvider.notifier).state = null,
                        ),
                        ...GoalCategory.values.map((cat) {
                          return _buildFilterChip(
                            label: cat.label,
                            isSelected: activeFilter == cat,
                            onSelected: () =>
                                ref.read(goalFilterCategoryProvider.notifier).state = cat,
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Goal List / Empty State
                  if (filteredGoals.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.track_changes, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No Career Goals Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Set ambitious targets and track your milestones to accelerate your career growth.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  else
                    ...filteredGoals.map((goal) {
                      return GoalCard(
                        goal: goal,
                        onToggleMilestone: (mId) {
                          ref.read(goalsNotifierProvider.notifier).toggleMilestone(goal.id, mId);
                        },
                        onDelete: () {
                          ref.read(goalsNotifierProvider.notifier).deleteGoal(goal.id);
                        },
                      );
                    }),
                  const SizedBox(height: 60),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.accentLight),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accent.withValues(alpha: 0.25),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.accentLight : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.accent : AppColors.border,
        ),
      ),
    );
  }
}
