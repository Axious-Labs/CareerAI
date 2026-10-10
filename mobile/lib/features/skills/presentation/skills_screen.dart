import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/skill_model.dart';
import '../services/skills_service.dart';
import 'widgets/roadmap_timeline_widget.dart';

class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key});

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  bool _showGapAnalysis = false;
  List<SkillItem> _skills = SkillsService.defaultUserSkills;
  List<SkillGapItem> _gaps = SkillsService.defaultGaps;

  @override
  Widget build(BuildContext context) {
    final milestones = ref.watch(roadmapProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Skills & Competencies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Toggle View',
            onPressed: () {
              setState(() => _showGapAnalysis = !_showGapAnalysis);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Role Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.indigo, AppColors.surfaceLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: Colors.white, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Target Role: AI/ML Engineer',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 4),
                        Text(
                          'Readiness: 68% • 3 High-Impact Skill Gaps Identified',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab Selector
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showGapAnalysis ? AppColors.accent : AppColors.surface,
                      foregroundColor: !_showGapAnalysis ? AppColors.primary : AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _showGapAnalysis = false),
                    child: const Text('My Skills', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showGapAnalysis ? AppColors.accent : AppColors.surface,
                      foregroundColor: _showGapAnalysis ? AppColors.primary : AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _showGapAnalysis = true),
                    child: const Text('Skill Gap Analysis', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (!_showGapAnalysis) ...[
              // Skills List
              const Text('Assessed Competencies', style: AppTextStyles.h2),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _skills.length,
                itemBuilder: (context, index) {
                  final skill = _skills[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  skill.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                if (skill.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, size: 16, color: AppColors.accent),
                                ],
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                skill.proficiencyLabel,
                                style: const TextStyle(
                                  color: AppColors.accentLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(skill.category, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: skill.level,
                            backgroundColor: AppColors.surfaceLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ] else ...[
              // Skill Gap Analysis Cards
              const Text('Identified Skill Gaps', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              const Text(
                'Focusing on these domains maximizes job match percentage',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 12),
              ..._gaps.map((gap) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              gap.skillName,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: gap.importance == 'HIGH'
                                  ? AppColors.error.withValues(alpha: 0.2)
                                  : AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${gap.importance} PRIORITY',
                              style: TextStyle(
                                color: gap.importance == 'HIGH' ? AppColors.error : AppColors.warning,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(gap.rationale, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            'Estimated Time: ${gap.estimatedTimeToMaster}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),

            // Interactive Roadmap Timeline Widget
            RoadmapTimelineWidget(
              milestones: milestones,
              onToggleMilestone: (id) {
                ref.read(roadmapProvider.notifier).toggleMilestone(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
