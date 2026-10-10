import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/job_model.dart';
import '../services/jobs_service.dart';
import 'widgets/job_card.dart';
import 'widgets/job_filter_sheet.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  final _searchController = TextEditingController();
  bool _showSavedOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    final currentFilter = ref.read(jobFilterProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => JobFilterSheet(
        initialFilter: currentFilter,
        onApply: (newFilter) {
          ref.read(jobFilterProvider.notifier).state = newFilter;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allJobs = ref.watch(filteredJobsProvider);
    final jobs = _showSavedOnly ? allJobs.where((j) => j.isSaved).toList() : allJobs;
    final filter = ref.watch(jobFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Matched Opportunities'),
        actions: [
          IconButton(
            icon: Icon(
              _showSavedOnly ? Icons.bookmark : Icons.bookmark_outline,
              color: _showSavedOnly ? AppColors.accent : AppColors.textPrimary,
            ),
            tooltip: _showSavedOnly ? 'Show All' : 'Show Saved',
            onPressed: () {
              setState(() => _showSavedOnly = !_showSavedOnly);
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (filter.hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Filter Jobs',
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search roles, skills, or companies...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(jobFilterProvider.notifier).update(
                                (s) => s.copyWith(searchQuery: ''),
                              );
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accent),
                ),
              ),
              onChanged: (val) {
                ref.read(jobFilterProvider.notifier).update(
                      (s) => s.copyWith(searchQuery: val),
                    );
              },
            ),
          ),

          // Active Filter Chips
          if (filter.hasActiveFilters || _showSavedOnly)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  if (_showSavedOnly)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: const Text('Saved Only'),
                        onDeleted: () => setState(() => _showSavedOnly = false),
                        deleteIconColor: AppColors.accent,
                      ),
                    ),
                  if (filter.workplaceType != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(filter.workplaceType!.name.toUpperCase()),
                        onDeleted: () => ref.read(jobFilterProvider.notifier).update(
                              (s) => s.copyWith(workplaceType: null),
                            ),
                      ),
                    ),
                  if (filter.minMatchScore > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text('>= ${filter.minMatchScore}% Match'),
                        onDeleted: () => ref.read(jobFilterProvider.notifier).update(
                              (s) => s.copyWith(minMatchScore: 0),
                            ),
                      ),
                    ),
                  if (filter.selectedTag != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text('Tag: ${filter.selectedTag}'),
                        onDeleted: () => ref.read(jobFilterProvider.notifier).update(
                              (s) => s.copyWith(selectedTag: null),
                            ),
                      ),
                    ),
                ],
              ),
            ),

          // Jobs List
          Expanded(
            child: jobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.work_off_outlined, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text('No opportunities matching your criteria', style: AppTextStyles.h3),
                        const SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _showSavedOnly = false);
                            ref.read(jobFilterProvider.notifier).state = const JobFilterState();
                          },
                          child: const Text('Clear All Filters', style: TextStyle(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        onToggleSave: () {
                          ref.read(jobsListProvider.notifier).toggleSaveJob(job.id);
                        },
                        onApply: () {
                          ref.read(jobsListProvider.notifier).markApplied(job.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Applied to ${job.title} at ${job.company}!'),
                              backgroundColor: AppColors.success,
                              action: SnackBarAction(
                                label: 'Tracker',
                                textColor: Colors.white,
                                onPressed: () => context.push('/applications'),
                              ),
                            ),
                          );
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
