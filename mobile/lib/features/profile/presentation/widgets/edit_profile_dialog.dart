import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/profile_model.dart';

class EditProfileDialog extends StatefulWidget {
  final UserProfileDetail initialProfile;
  final Function(UserProfileDetail updatedProfile) onSave;

  const EditProfileDialog({
    super.key,
    required this.initialProfile,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _headlineController;
  late final TextEditingController _roleController;
  late final TextEditingController _educationController;
  late final TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _headlineController = TextEditingController(text: widget.initialProfile.headline);
    _roleController = TextEditingController(text: widget.initialProfile.targetRole);
    _educationController = TextEditingController(text: widget.initialProfile.education);
    _salaryController = TextEditingController(
      text: widget.initialProfile.preferences.expectedMinSalary.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _headlineController.dispose();
    _roleController.dispose();
    _educationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final parsedSalary = int.tryParse(_salaryController.text.trim()) ??
        widget.initialProfile.preferences.expectedMinSalary;

    final updated = widget.initialProfile.copyWith(
      name: _nameController.text.trim(),
      headline: _headlineController.text.trim(),
      targetRole: _roleController.text.trim(),
      education: _educationController.text.trim(),
      preferences: CareerPreferences(
        targetRole: _roleController.text.trim(),
        location: widget.initialProfile.preferences.location,
        remoteOnly: widget.initialProfile.preferences.remoteOnly,
        expectedMinSalary: parsedSalary,
      ),
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
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
                        'Edit Career Profile',
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
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _headlineController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Professional Headline',
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _educationController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Highest Degree / Education',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Expected Minimum Salary (\$USD)',
                      filled: true,
                      fillColor: AppColors.secondary,
                      border: OutlineInputBorder(),
                    ),
                  ),
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
                      child: const Text(
                        'Save Profile Changes',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
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
