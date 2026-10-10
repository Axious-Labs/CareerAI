import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class ResumeSkillChips extends StatelessWidget {
  final List<String> skills;
  final String title;
  final ValueChanged<String>? onSkillTapped;

  const ResumeSkillChips({
    super.key,
    required this.skills,
    this.title = 'Extracted Technical Skills',
    this.onSkillTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return ActionChip(
                backgroundColor: AppColors.surfaceLight,
                side: const BorderSide(color: AppColors.border),
                label: Text(
                  skill,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () => onSkillTapped?.call(skill),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
