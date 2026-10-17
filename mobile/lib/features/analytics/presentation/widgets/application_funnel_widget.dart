import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/analytics_model.dart';

class ApplicationFunnelWidget extends StatelessWidget {
  final ApplicationFunnelStats funnel;

  const ApplicationFunnelWidget({super.key, required this.funnel});

  @override
  Widget build(BuildContext context) {
    final maxVal = funnel.applied > 0 ? funnel.applied : 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                'Application Conversion Funnel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${funnel.offerConversionRate.toStringAsFixed(1)}% Offer Rate',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStageRow('Applied Jobs', funnel.applied, maxVal, AppColors.info),
          _buildStageRow('Recruiter Screening', funnel.screening, maxVal, AppColors.accent),
          _buildStageRow('Technical Rounds', funnel.technicalInterview, maxVal, AppColors.indigo),
          _buildStageRow('Final Executive Round', funnel.finalRound, maxVal, AppColors.warning),
          _buildStageRow('Job Offers Received', funnel.offers, maxVal, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildStageRow(String stageName, int count, int maxVal, Color stageColor) {
    final ratio = (count / maxVal).clamp(0.05, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stageName, style: AppTextStyles.bodySmall),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: stageColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 7,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(stageColor),
            ),
          ),
        ],
      ),
    );
  }
}
