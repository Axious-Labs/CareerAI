import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final List<Map<String, dynamic>> _jobs = [
    {
      'id': 'job_01',
      'title': 'Junior AI Engineer',
      'company': 'Axious Labs',
      'location': 'Remote',
      'matchScore': 88,
      'description': 'Build next-generation career intelligence agents, RAG pipelines, and LLM integrations.',
      'tags': ['Python', 'FastAPI', 'GenAI'],
    },
    {
      'id': 'job_02',
      'title': 'Associate Machine Learning Engineer',
      'company': 'TechFlow Systems',
      'location': 'San Francisco, CA (Hybrid)',
      'matchScore': 82,
      'description': 'Develop data pipelines, fine-tune open weights LLMs, and optimize inference latency.',
      'tags': ['PyTorch', 'Docker', 'Python'],
    },
    {
      'id': 'job_03',
      'title': 'Junior Full-Stack & AI Developer',
      'company': 'Nexus Innovations',
      'location': 'Remote',
      'matchScore': 76,
      'description': 'Build modern Flutter frontends and TypeScript backends powered by generative AI.',
      'tags': ['Flutter', 'TypeScript', 'Node.js'],
    },
  ];

  void _applyToJob(String title, String company) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied to $title at $company! Tracked in Applications.'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () => context.push('/applications'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Discover Jobs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          final matchScore = job['matchScore'] as int;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('${job['company']} • ${job['location']}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Text(
                        '$matchScore% Match',
                        style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(job['description'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: (job['tags'] as List<String>).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(tag, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: const Text('View Details', style: TextStyle(color: AppColors.textPrimary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _applyToJob(job['title'], job['company']),
                        child: const Text('Track Application'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
