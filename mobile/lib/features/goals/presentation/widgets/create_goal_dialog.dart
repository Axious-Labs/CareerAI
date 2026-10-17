import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/goal_model.dart';

class CreateGoalDialog extends StatefulWidget {
  final Function(CareerGoal newGoal) onGoalCreated;

  const CreateGoalDialog({super.key, required this.onGoalCreated});

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _roleController = TextEditingController(text: 'Senior Flutter Engineer');
  final _milestoneController = TextEditingController();

  GoalCategory _selectedCategory = GoalCategory.skillDevelopment;
  GoalPriority _selectedPriority = GoalPriority.high;
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));
  final List<String> _milestoneTitles = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _roleController.dispose();
    _milestoneController.dispose();
    super.dispose();
  }

  void _addMilestone() {
    final text = _milestoneController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _milestoneTitles.add(text);
        _milestoneController.clear();
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final goalId = 'goal_${DateTime.now().millisecondsSinceEpoch}';
    final milestones = _milestoneTitles.asMap().entries.map((entry) {
      return Milestone(
        id: '${goalId}_ms_${entry.key}',
        goalId: goalId,
        title: entry.value,
        orderIndex: entry.key,
        isCompleted: false,
      );
    }).toList();

    final newGoal = CareerGoal(
      id: goalId,
      userId: 'user_1',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      targetRole: _roleController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      status: GoalStatus.inProgress,
      progress: 0.0,
      startDate: DateTime.now(),
      targetDate: _targetDate,
      milestones: milestones,
      tags: [_selectedCategory.label, _selectedPriority.label],
    );

    widget.onGoalCreated(newGoal);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 650),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create Career Goal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Goal Title',
                      hintText: 'e.g. Master Clean Architecture in Flutter',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a goal title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Describe key deliverables and focus areas...',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _roleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Target Career Role',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<GoalCategory>(
                          value: _selectedCategory,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: AppColors.secondary,
                            border: OutlineInputBorder(),
                          ),
                          items: GoalCategory.values.map((cat) {
                            return DropdownMenuItem(value: cat, child: Text(cat.label));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<GoalPriority>(
                          value: _selectedPriority,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            filled: true,
                            fillColor: AppColors.secondary,
                            border: OutlineInputBorder(),
                          ),
                          items: GoalPriority.values.map((p) {
                            return DropdownMenuItem(value: p, child: Text(p.label));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedPriority = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Milestones Checklist', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _milestoneController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: 'Add milestone step...',
                            filled: true,
                            fillColor: AppColors.secondary,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onSubmitted: (_) => _addMilestone(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: _addMilestone,
                        style: IconButton.styleFrom(backgroundColor: AppColors.accent),
                      ),
                    ],
                  ),
                  if (_milestoneTitles.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ..._milestoneTitles.asMap().entries.map((entry) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline, color: AppColors.accent, size: 18),
                        title: Text(entry.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textMuted, size: 16),
                          onPressed: () {
                            setState(() {
                              _milestoneTitles.removeAt(entry.key);
                            });
                          },
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save & Track Goal', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
