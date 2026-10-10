import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/application_model.dart';
import '../services/application_service.dart';
import 'widgets/application_card.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  ApplicationStatus? _filterStatus;

  void _showEditNotesDialog(JobApplication app) {
    final controller = TextEditingController(text: app.notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Edit Notes: ${app.company}', style: AppTextStyles.h3),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter internal notes, interview prep tips...',
            hintStyle: TextStyle(color: AppColors.textMuted),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () {
              ref
                  .read(applicationsProvider.notifier)
                  .updateApplicationNotes(app.id, controller.text.trim());
              Navigator.of(ctx).pop();
            },
            child: const Text('Save Note', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allApps = ref.watch(applicationsProvider);
    final apps = _filterStatus == null
        ? allApps
        : allApps.where((a) => a.status == _filterStatus).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Application Tracker'),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All Applications'),
                  selected: _filterStatus == null,
                  onSelected: (_) => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                ...ApplicationStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(status.name.toUpperCase()),
                      selected: _filterStatus == status,
                      onSelected: (selected) {
                        setState(() => _filterStatus = selected ? status : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Applications List
          Expanded(
            child: apps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.assignment_outlined, size: 54, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text('No applications matching this filter', style: AppTextStyles.h3),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return ApplicationCard(
                        application: app,
                        onEditNotes: () => _showEditNotesDialog(app),
                        onStatusChanged: (newStatus) {
                          ref
                              .read(applicationsProvider.notifier)
                              .updateApplicationStatus(app.id, newStatus);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
