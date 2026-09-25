import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  final List<Map<String, dynamic>> _applications = const [
    {
      'id': 'app_01',
      'title': 'Junior AI Engineer',
      'company': 'Axious Labs',
      'location': 'Remote',
      'status': 'INTERVIEWING',
      'appliedDate': '3 days ago',
      'notes': 'Completed initial technical screening with lead engineer Ravi Prakash.',
    },
    {
      'id': 'app_02',
      'title': 'Associate Machine Learning Engineer',
      'company': 'TechFlow Systems',
      'location': 'San Francisco, CA',
      'status': 'APPLIED',
      'appliedDate': '1 week ago',
      'notes': 'Application submitted with updated resume highlighting LangGraph experience.',
    },
    {
      'id': 'app_03',
      'title': 'Junior Full-Stack & AI Developer',
      'company': 'Nexus Innovations',
      'location': 'Remote',
      'status': 'OFFER',
      'appliedDate': '2 weeks ago',
      'notes': 'Received formal offer for summer engineering cohort!',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPLIED':
        return AppColors.info;
      case 'INTERVIEWING':
        return AppColors.warning;
      case 'OFFER':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Application Tracker')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _applications.length,
        itemBuilder: (context, index) {
          final app = _applications[index];
          final statusColor = _getStatusColor(app['status']);

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
                          Text(app['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text('${app['company']} • ${app['location']}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        app['status'],
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notes, size: 16, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          app['notes'],
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Applied ${app['appliedDate']}', style: AppTextStyles.bodySmall),
              ],
            ),
          );
        },
      ),
    );
  }
}
