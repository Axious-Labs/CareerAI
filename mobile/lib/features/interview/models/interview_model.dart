class InterviewQuestion {
  final String id;
  final String category;
  final String question;
  final List<String> expectedKeyPoints;
  final String sampleAnswerGuide;

  InterviewQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.expectedKeyPoints,
    required this.sampleAnswerGuide,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] as String? ?? 'q_1',
      category: json['category'] as String? ?? 'Technical Architecture',
      question: json['question'] as String? ?? '',
      expectedKeyPoints: (json['expectedKeyPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sampleAnswerGuide: json['sampleAnswerGuide'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'question': question,
      'expectedKeyPoints': expectedKeyPoints,
      'sampleAnswerGuide': sampleAnswerGuide,
    };
  }
}

class AnswerEvaluationResult {
  final String sessionId;
  final String questionId;
  final int score;
  final String feedback;
  final List<String> strengths;
  final List<String> areasForImprovement;
  final String modelAnswerTip;

  AnswerEvaluationResult({
    required this.sessionId,
    required this.questionId,
    required this.score,
    required this.feedback,
    required this.strengths,
    required this.areasForImprovement,
    required this.modelAnswerTip,
  });

  factory AnswerEvaluationResult.fromJson(Map<String, dynamic> json) {
    return AnswerEvaluationResult(
      sessionId: json['sessionId'] as String? ?? '',
      questionId: json['questionId'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 75,
      feedback: json['feedback'] as String? ?? '',
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      areasForImprovement: (json['areasForImprovement'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      modelAnswerTip: json['modelAnswerTip'] as String? ?? '',
    );
  }
}

class InterviewSessionData {
  final String sessionId;
  final String targetRole;
  final String difficulty;
  final int totalQuestions;
  final List<InterviewQuestion> questions;
  final String instructions;

  InterviewSessionData({
    required this.sessionId,
    required this.targetRole,
    required this.difficulty,
    required this.totalQuestions,
    required this.questions,
    required this.instructions,
  });

  factory InterviewSessionData.fromJson(Map<String, dynamic> json) {
    final questionsList = (json['questions'] as List<dynamic>?)
            ?.map((e) => InterviewQuestion.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return InterviewSessionData(
      sessionId: json['sessionId'] as String? ?? '',
      targetRole: json['targetRole'] as String? ?? 'AI/ML Engineer',
      difficulty: json['difficulty'] as String? ?? 'MID',
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? questionsList.length,
      questions: questionsList,
      instructions: json['instructions'] as String? ?? '',
    );
  }
}
