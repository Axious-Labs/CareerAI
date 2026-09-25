import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  bool _showGapAnalysis = false;

  final List<Map<String, dynamic>> _skills = [
    {'name': 'Python', 'category': 'Programming Languages', 'proficiency': 'Advanced', 'level': 0.85},
    {'name': 'Flutter & Dart', 'category': 'Mobile Development', 'proficiency': 'Intermediate', 'level': 0.70},
    {'name': 'TypeScript', 'category': 'Programming Languages', 'proficiency': 'Intermediate', 'level': 0.65},
    {'name': 'FastAPI & Node.js', 'category': 'Backend Development', 'proficiency': 'Intermediate', 'level': 0.65},
    {'name': 'Generative AI & LLMs', 'category': 'Artificial Intelligence', 'proficiency': 'Intermediate', 'level': 0.60},
    {'name': 'Machine Learning', 'category': 'Machine Learning', 'proficiency': 'Beginner', 'level': 0.40},
    {'name': 'Docker', 'category': 'DevOps & Cloud', 'proficiency': 'Intermediate', 'level': 0.60},
  ];

  final List<Map<String, String>> _gaps = [
    {'skill': 'LangGraph', 'importance': 'HIGH', 'time': '2 weeks', 'desc': 'Essential for agentic workflow orchestration'},
    {'skill': 'Vector Databases (FAISS/pgvector)', 'importance': 'HIGH', 'time': '1 week', 'desc': 'Critical for semantic RAG search'},
    {'skill': 'Kubernetes & MLOps', 'importance': 'MEDIUM', 'time': '3 weeks', 'desc': 'Deploying models at scale'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Skills & Competencies')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skill Gap Analysis Banner Button
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
                        Text('Target Role: AI/ML Engineer', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        SizedBox(height: 2),
                        Text('Benchmark against industry standards', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _showGapAnalysis = !_showGapAnalysis);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Text(_showGapAnalysis ? 'Hide Gaps' : 'Analyze'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gap Analysis Results (if toggled)
            if (_showGapAnalysis) ...[
              const Text('Identified Skill Gaps', style: AppTextStyles.h2),
              const SizedBox(height: 12),
              ..._gaps.map((gap) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: gap['importance'] == 'HIGH'
                                ? AppColors.error.withOpacity(0.2)
                                : AppColors.warning.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            gap['importance']!,
                            style: TextStyle(
                              color: gap['importance'] == 'HIGH' ? AppColors.error : AppColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(gap['skill']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(gap['desc']!, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        Text(gap['time']!, style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
            ],

            // Current Skills List
            const Text('Your Skills Profile', style: AppTextStyles.h2),
            const SizedBox(height: 12),
            ..._skills.map((skill) => Container(
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
                          Text(skill['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(skill['proficiency'], style: const TextStyle(color: AppColors.accentLight, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(skill['category'], style: AppTextStyles.bodySmall),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: skill['level'],
                          minHeight: 6,
                          backgroundColor: AppColors.background,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
