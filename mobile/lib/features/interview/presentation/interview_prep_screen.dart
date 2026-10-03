import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/interview_model.dart';
import '../services/interview_service.dart';

class InterviewPrepScreen extends ConsumerStatefulWidget {
  const InterviewPrepScreen({super.key});

  @override
  ConsumerState<InterviewPrepScreen> createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends ConsumerState<InterviewPrepScreen> {
  String _selectedRole = 'AI/ML Engineer';
  String _selectedDifficulty = 'MID';
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isEvaluating = false;

  InterviewSessionData? _sessionData;
  final TextEditingController _answerController = TextEditingController();
  final Map<int, AnswerEvaluationResult> _evaluations = {};

  final List<String> _roles = [
    'AI/ML Engineer',
    'Full Stack Engineer',
    'Mobile Flutter Developer',
    'Backend Engineer',
  ];

  final List<String> _difficulties = ['JUNIOR', 'MID', 'SENIOR'];

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    setState(() => _isLoading = true);
    final service = ref.read(interviewServiceProvider);
    final session = await service.startInterview(
      targetRole: _selectedRole,
      difficulty: _selectedDifficulty,
    );
    if (mounted) {
      setState(() {
        _sessionData = session;
        _currentIndex = 0;
        _evaluations.clear();
        _answerController.clear();
        _isLoading = false;
      });
    }
  }

  Future<void> _evaluateCurrentAnswer() async {
    if (_sessionData == null || _answerController.text.trim().isEmpty) return;

    setState(() => _isEvaluating = true);
    final currentQuestion = _sessionData!.questions[_currentIndex];
    final service = ref.read(interviewServiceProvider);

    final result = await service.evaluateAnswer(
      sessionId: _sessionData!.sessionId,
      questionId: currentQuestion.id,
      questionText: currentQuestion.question,
      candidateAnswer: _answerController.text.trim(),
      targetRole: _selectedRole,
    );

    if (mounted) {
      setState(() {
        _evaluations[_currentIndex] = result;
        _isEvaluating = false;
      });
    }
  }

  void _nextQuestion() {
    if (_sessionData != null && _currentIndex < _sessionData!.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _answerController.clear();
      });
    }
  }

  void _prevQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _answerController.clear();
      });
    }
  }

  void _showSessionSummary() {
    final scoredList = _evaluations.values.toList();
    final avgScore = scoredList.isNotEmpty
        ? (scoredList.map((e) => e.score).reduce((a, b) => a + b) / scoredList.length).round()
        : 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assessment Summary', style: AppTextStyles.h2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accent),
                    ),
                    child: Text(
                      '$avgScore% Score',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Target Role: $_selectedRole ($_selectedDifficulty Level)',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                avgScore >= 80
                  ? 'Strong technical readiness demonstrated. You have high alignment with enterprise expectations.'
                  : 'Great effort. Focus on quantifying system constraints, scalability bottlenecks, and testing frameworks.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadSession();
                  },
                  child: const Text('Start New Mock Session'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = _sessionData?.questions ?? [];
    final currentQuestion = questions.isNotEmpty ? questions[_currentIndex] : null;
    final currentEval = _evaluations[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Mock Interview Prep'),
        actions: [
          if (_evaluations.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.assessment_outlined, color: AppColors.accent),
              tooltip: 'View Summary',
              onPressed: _showSessionSummary,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role & Difficulty Header Selectors
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Target Domain & Role', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _roles.map((role) {
                              final isSelected = role == _selectedRole;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(role),
                                  selected: isSelected,
                                  selectedColor: AppColors.accent.withValues(alpha: 0.25),
                                  backgroundColor: AppColors.background,
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.accentLight : AppColors.textSecondary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.accent : AppColors.border,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedRole = role);
                                      _loadSession();
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('Difficulty: ', style: AppTextStyles.bodySmall),
                            const SizedBox(width: 8),
                            ..._difficulties.map((diff) {
                              final isSelected = diff == _selectedDifficulty;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => _selectedDifficulty = diff);
                                    _loadSession();
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.indigo.withValues(alpha: 0.3)
                                          : AppColors.background,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected ? AppColors.indigo : AppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      diff,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.indigo : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (currentQuestion != null) ...[
                    // Progress Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentIndex + 1} of ${questions.length}',
                          style: AppTextStyles.h2,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentQuestion.category,
                            style: const TextStyle(
                              color: AppColors.accentLight,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Question Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.surface, AppColors.surfaceLight.withValues(alpha: 0.4)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.question,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: AppColors.border, height: 1),
                          const SizedBox(height: 10),
                          const Text('Key Expected Concepts:', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: currentQuestion.expectedKeyPoints.map((point) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Text(
                                  '• $point',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Answer Input Section
                    const Text('Your Technical Response', style: AppTextStyles.h2),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _answerController,
                      maxLines: 5,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Explain your architecture, tradeoffs, algorithms, and production considerations...',
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Action Buttons: Evaluate & Navigation
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isEvaluating ? null : _evaluateCurrentAnswer,
                            icon: _isEvaluating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome, size: 18),
                            label: Text(_isEvaluating ? 'Evaluating with AI...' : 'Evaluate Answer'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // AI Evaluation Results
                    if (currentEval != null) ...[
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: currentEval.score >= 80 ? AppColors.accent : AppColors.warning,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_outlined,
                                      color: currentEval.score >= 80 ? AppColors.accent : AppColors.warning,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('AI Assessment', style: AppTextStyles.h2),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (currentEval.score >= 80 ? AppColors.accent : AppColors.warning)
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${currentEval.score}/100',
                                    style: TextStyle(
                                      color: currentEval.score >= 80 ? AppColors.accent : AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(currentEval.feedback, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 14),

                            const Text('Strengths:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 12)),
                            const SizedBox(height: 4),
                            ...currentEval.strengths.map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle, color: AppColors.success, size: 14),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(s, style: AppTextStyles.bodySmall)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            const Text('Areas for Improvement:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning, fontSize: 12)),
                            const SizedBox(height: 4),
                            ...currentEval.areasForImprovement.map(
                              (a) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.info_outline, color: AppColors.warning, size: 14),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(a, style: AppTextStyles.bodySmall)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Tip: ${currentEval.modelAnswerTip}',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Previous / Next Navigators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _currentIndex > 0 ? _prevQuestion : null,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.border),
                          ),
                        ),
                        if (_currentIndex < questions.length - 1)
                          ElevatedButton.icon(
                            onPressed: _nextQuestion,
                            icon: const Icon(Icons.chevron_right),
                            label: const Text('Next'),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: _showSessionSummary,
                            icon: const Icon(Icons.check),
                            label: const Text('Complete Session'),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
