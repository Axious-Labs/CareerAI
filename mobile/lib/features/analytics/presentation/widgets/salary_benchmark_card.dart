import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/analytics_model.dart';

class SalaryBenchmarkCard extends StatelessWidget {
  final SalaryBenchmarkItem item;

  const SalaryBenchmarkCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.compactSimpleCurrency(locale: 'en_US', name: item.currency);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.role,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.show_chart, size: 12, color: AppColors.accentLight),
                    const SizedBox(width: 4),
                    Text(
                      '+${item.yoyGrowth.toStringAsFixed(1)}% YoY',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(item.location, style: AppTextStyles.bodySmall),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSalaryPill(
                  label: 'Junior',
                  amount: currencyFormat.format(item.juniorSalary),
                  isHighlighted: false,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSalaryPill(
                  label: 'Mid-Level',
                  amount: currencyFormat.format(item.midSalary),
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSalaryPill(
                  label: 'Senior / Lead',
                  amount: currencyFormat.format(item.seniorSalary),
                  isHighlighted: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryPill({
    required String label,
    required String amount,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.accent.withValues(alpha: 0.15)
            : AppColors.surfaceLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? AppColors.accent : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isHighlighted ? AppColors.accentLight : AppColors.textSecondary,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.accentLight : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
