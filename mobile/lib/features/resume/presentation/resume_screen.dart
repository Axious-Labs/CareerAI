import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../services/resume_service.dart';
import 'widgets/resume_score_card.dart';
import 'widgets/resume_skill_chips.dart';

class ResumeScreen extends ConsumerStatefulWidget {
  const ResumeScreen({super.key});

  @override
  ConsumerState<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends ConsumerState<ResumeScreen> {
  bool _isUploading = false;

  Future<void> _handleUpload() async {
    setState(() => _isUploading = true);
    final success = await ref.read(resumeStateProvider.notifier).uploadNewResume(
          'Updated_Profile_Resume_2026.pdf',
          List.filled(265000, 0),
        );
    if (mounted) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Resume uploaded and processed by CareerAI GenAI Service!'
                : 'Upload failed. Please check connection.',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumeState = ref.watch(resumeStateProvider);
    final resume = resumeState.currentResume ?? ResumeService.defaultSampleResume;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Resume Intelligence'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Re-analyze',
            onPressed: () =>
                ref.read(resumeStateProvider.notifier).loadInitialResume(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Banner
            InkWell(
              onTap: _isUploading ? null : _handleUpload,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    _isUploading
                        ? const SizedBox(
                            height: 48,
                            width: 48,
                            child: CircularProgressIndicator(color: AppColors.accent),
                          )
                        : const Icon(
                            Icons.cloud_upload_outlined,
                            size: 48,
                            color: AppColors.accent,
                          ),
                    const SizedBox(height: 12),
                    Text(
                      _isUploading ? 'Analyzing Resume with GenAI...' : 'Upload Updated Resume',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'PDF or DOCX (Max 10MB) • Scanned for ATS optimization',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Active File Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resume.fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Size: ${resume.formattedFileSize} • Status: ${resume.status}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      resume.status,
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ATS Score Breakdown
            ResumeScoreCard(
              atsScore: resume.atsScore,
              keywordMatch: resume.keywordMatchPercentage,
              readability: resume.readabilityScore,
            ),
            const SizedBox(height: 20),

            // Extracted Skills
            ResumeSkillChips(
              skills: resume.extractedSkills,
              onSkillTapped: (skill) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Skill selected: $skill'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // AI Recommendations Card
            Container(
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
                    children: const [
                      Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Text('AI Optimization Recommendations', style: AppTextStyles.h3),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...resume.recommendedImprovements.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.accent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(tip, style: AppTextStyles.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
