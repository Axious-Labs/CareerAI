import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/goal_model.dart';
import 'milestone_tile.dart';

class GoalCard extends StatefulWidget {
  final CareerGoal goal;
  final Function(String milestoneId) onToggleMilestone;
  final VoidCallback? onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onToggleMilestone,
    this.onDelete,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool _isExpanded = false;

  Color _getPriorityColor(GoalPriority priority) {
    switch (priority) {
      case GoalPriority.critical:
        return AppColors.error;
      case GoalPriority.high:
        return AppColors.warning;
      case GoalPriority.medium:
        return AppColors.info;
      case GoalPriority.low:
        return AppColors.textMuted;
    }
  }

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.completed:
        return AppColors.success;
      case GoalStatus.inProgress:
        return AppColors.accent;
      case GoalStatus.notStarted:
        return AppColors.textMuted;
      case GoalStatus.onHold:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final progress = goal.calculatedProgress;
    final priorityColor = _getPriorityColor(goal.priority);
    final statusColor = _getStatusColor(goal.status);
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goal.status == GoalStatus.completed
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category, Priority, and Status Badges
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          goal.category.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentLight,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: priorityColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          goal.priority.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: priorityColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          goal.status.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.textMuted),
                    onPressed: widget.onDelete,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Delete Goal',
                  ),
              ],
            ),
          ),

          // Title & Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (goal.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    goal.description,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Progress Bar with Percentage and Remaining Days
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${goal.completedMilestonesCount} of ${goal.totalMilestones} Milestones Completed',
                      style: AppTextStyles.bodySmall,
                    ),
                    Text(
                      '${progress.toInt()}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: progress >= 100 ? AppColors.success : AppColors.accentLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (progress / 100.0).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 100 ? AppColors.success : AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Target Role & Target Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(goal.targetRole, style: AppTextStyles.bodySmall),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      size: 14,
                      color: goal.isOverdue ? AppColors.error : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(goal.targetDate),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: goal.isOverdue ? AppColors.error : AppColors.textSecondary,
                        fontWeight: goal.isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Expandable Milestones Section
          if (goal.milestones.isNotEmpty) ...[
            const Divider(color: AppColors.border, height: 1),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isExpanded ? 'Hide Milestones' : 'View Milestones (${goal.milestones.length})',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.accentLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: AppColors.accentLight,
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  children: goal.milestones.map((m) {
                    return MilestoneTile(
                      milestone: m,
                      onToggle: (_) => widget.onToggleMilestone(m.id),
                    );
                  }).toList(),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
