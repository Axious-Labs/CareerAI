import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onEditNotes;
  final ValueChanged<ApplicationStatus>? onStatusChanged;

  const ApplicationCard({
    super.key,
    required this.application,
    this.onEditNotes,
    this.onStatusChanged,
  });

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return AppColors.info;
      case ApplicationStatus.underReview:
        return AppColors.accent;
      case ApplicationStatus.interviewing:
        return AppColors.warning;
      case ApplicationStatus.offer:
        return AppColors.success;
      case ApplicationStatus.rejected:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Role, Status, Applied Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  application.statusDisplay,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${application.company} • ${application.location}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),

          // Application Notes Box
          if (application.notes.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_outlined,
                      size: 16, color: AppColors.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      application.notes,
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                  if (onEditNotes != null)
                    InkWell(
                      onTap: onEditNotes,
                      child: const Icon(Icons.edit_outlined,
                          size: 14, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),

          // Interview Rounds Accordion / List
          if (application.rounds.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Interview Process', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            ...application.rounds.map((round) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_available,
                        size: 18, color: AppColors.accentLight),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            round.roundName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${round.scheduledDate} • ${round.interviewer}',
                            style: AppTextStyles.bodySmall,
                          ),
                          if (round.feedback != null)
                            Text(
                              'Feedback: ${round.feedback}',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Applied ${application.appliedDate}', style: AppTextStyles.bodySmall),
              PopupMenuButton<ApplicationStatus>(
                tooltip: 'Update Status',
                color: AppColors.surface,
                onSelected: onStatusChanged,
                itemBuilder: (ctx) => ApplicationStatus.values.map((status) {
                  return PopupMenuItem(
                    value: status,
                    child: Text(
                      status.name.toUpperCase(),
                      style: TextStyle(color: _getStatusColor(status)),
                    ),
                  );
                }).toList(),
                child: Row(
                  children: const [
                    Text('Update Status',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        )),
                    Icon(Icons.arrow_drop_down, color: AppColors.accent, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
