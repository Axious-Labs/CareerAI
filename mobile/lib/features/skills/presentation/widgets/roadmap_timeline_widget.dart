import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/skill_model.dart';

class RoadmapTimelineWidget extends StatelessWidget {
  final List<RoadmapMilestone> milestones;
  final ValueChanged<String>? onToggleMilestone;

  const RoadmapTimelineWidget({
    super.key,
    required this.milestones,
    this.onToggleMilestone,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const Center(
        child: Text('No roadmap milestones generated yet', style: AppTextStyles.bodyMedium),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Personalized Learning Roadmap', style: AppTextStyles.h3),
            Text(
              '${milestones.where((m) => m.isCompleted).length}/${milestones.length} Done',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...milestones.asMap().entries.map((entry) {
          final index = entry.key;
          final milestone = entry.value;
          final isLast = index == milestones.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline indicator column
                Column(
                  children: [
                    InkWell(
                      onTap: () => onToggleMilestone?.call(milestone.id),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: milestone.isCompleted
                              ? AppColors.success
                              : AppColors.surfaceLight,
                          border: Border.all(
                            color: milestone.isCompleted
                                ? AppColors.success
                                : AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          milestone.isCompleted ? Icons.check : Icons.circle_outlined,
                          size: 16,
                          color: milestone.isCompleted ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: milestone.isCompleted
                              ? AppColors.success.withValues(alpha: 0.5)
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Milestone Content Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: milestone.isCompleted
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.indigo.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Week ${milestone.weekNumber}',
                                style: const TextStyle(
                                  color: AppColors.indigo,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Text(
                              milestone.estimatedHours,
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          milestone.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: milestone.isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            decoration: milestone.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          milestone.description,
                          style: AppTextStyles.bodySmall,
                        ),
                        if (milestone.recommendedResources.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: milestone.recommendedResources.map((res) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '• $res',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
