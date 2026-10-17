import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/goal_model.dart';

class MilestoneTile extends StatelessWidget {
  final Milestone milestone;
  final ValueChanged<bool?> onToggle;

  const MilestoneTile({
    super.key,
    required this.milestone,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = milestone.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDone
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isDone,
            onChanged: onToggle,
            activeColor: AppColors.success,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDone ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (milestone.description != null && milestone.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    milestone.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDone ? AppColors.textMuted : AppColors.textSecondary,
                    ),
                  ),
                ],
                if (milestone.resources.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: milestone.resources.map((res) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.link, size: 12, color: AppColors.accentLight),
                            const SizedBox(width: 4),
                            Text(
                              res.title,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.accentLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
