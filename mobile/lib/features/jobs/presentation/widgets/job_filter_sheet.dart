import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../models/job_model.dart';

class JobFilterSheet extends StatefulWidget {
  final JobFilterState initialFilter;
  final ValueChanged<JobFilterState> onApply;

  const JobFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<JobFilterSheet> {
  late WorkplaceType? _selectedWorkplace;
  late int _minMatchScore;
  late String? _selectedTag;

  final List<String> _availableTags = const [
    'Python',
    'Flutter',
    'FastAPI',
    'Docker',
    'TypeScript',
    'PyTorch',
    'PostgreSQL',
    'GenAI',
  ];

  @override
  void initState() {
    super.initState();
    _selectedWorkplace = widget.initialFilter.workplaceType;
    _minMatchScore = widget.initialFilter.minMatchScore;
    _selectedTag = widget.initialFilter.selectedTag;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Opportunities', style: AppTextStyles.h2),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedWorkplace = null;
                    _minMatchScore = 0;
                    _selectedTag = null;
                  });
                },
                child: const Text('Reset', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Workplace Type
          const Text('Workplace Type', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildTypeChip('All', _selectedWorkplace == null, () {
                setState(() => _selectedWorkplace = null);
              }),
              const SizedBox(width: 8),
              _buildTypeChip('Remote', _selectedWorkplace == WorkplaceType.remote, () {
                setState(() => _selectedWorkplace = WorkplaceType.remote);
              }),
              const SizedBox(width: 8),
              _buildTypeChip('Hybrid', _selectedWorkplace == WorkplaceType.hybrid, () {
                setState(() => _selectedWorkplace = WorkplaceType.hybrid);
              }),
              const SizedBox(width: 8),
              _buildTypeChip('On-site', _selectedWorkplace == WorkplaceType.onsite, () {
                setState(() => _selectedWorkplace = WorkplaceType.onsite);
              }),
            ],
          ),
          const SizedBox(height: 18),

          // Min Match Score Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Minimum Match Score', style: AppTextStyles.h3),
              Text(
                '$_minMatchScore%',
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _minMatchScore.toDouble(),
            min: 0,
            max: 95,
            divisions: 19,
            activeColor: AppColors.accent,
            inactiveColor: AppColors.surfaceLight,
            onChanged: (val) {
              setState(() => _minMatchScore = val.toInt());
            },
          ),
          const SizedBox(height: 14),

          // Tech Skill Tag Filter
          const Text('Required Skill Focus', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTag == tag;
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                selectedColor: AppColors.accent.withValues(alpha: 0.25),
                backgroundColor: AppColors.surfaceLight,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  setState(() => _selectedTag = selected ? tag : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                widget.onApply(
                  widget.initialFilter.copyWith(
                    workplaceType: _selectedWorkplace,
                    minMatchScore: _minMatchScore,
                    selectedTag: _selectedTag,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.accent.withValues(alpha: 0.2),
      backgroundColor: AppColors.surfaceLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
