import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  bool _isUploading = false;
  String _resumeName = 'Alex_Chen_Resume_2026.pdf';
  String _status = 'PARSED';

  final List<String> _extractedSkills = [
    'Python',
    'Flutter',
    'FastAPI',
    'Docker',
    'PostgreSQL',
    'Git',
    'Machine Learning',
    'Problem Solving',
  ];

  void _simulateUpload() {
    setState(() => _isUploading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _resumeName = 'Updated_Resume_2026.pdf';
          _status = 'PARSED';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resume uploaded and parsed successfully by GenAI Service!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Resume Intelligence')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Zone
            InkWell(
              onTap: _isUploading ? null : _simulateUpload,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.5), style: BorderStyle.solid, width: 1.5),
                ),
                child: Column(
                  children: [
                    if (_isUploading)
                      const CircularProgressIndicator(color: AppColors.accent)
                    else ...[
                      const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.accent),
                      const SizedBox(height: 12),
                      const Text('Upload Candidate Resume', style: AppTextStyles.h3),
                      const SizedBox(height: 4),
                      const Text('Supports PDF, DOCX (Max 5MB)', style: AppTextStyles.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Active Resume Card
            const Text('Active Resume', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_resumeName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 2),
                            const Text('Uploaded Today • 248 KB', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _status,
                          style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 12),
                  const Text('Extracted Skills (by GenAI)', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _extractedSkills.map((skill) {
                      return Chip(
                        label: Text(skill, style: const TextStyle(fontSize: 12, color: AppColors.accentLight)),
                        backgroundColor: AppColors.surfaceLight,
                        side: const BorderSide(color: AppColors.border),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI Parsing Summary
            const Text('GenAI Analysis Summary', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'Demonstrates a strong foundation in mobile architecture and Python backend services. '
                'Recommended to showcase project work involving vector stores and autonomous agents to strengthen alignment with target AI/ML roles.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
