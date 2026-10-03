import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/interview_model.dart';

final interviewServiceProvider = Provider<InterviewService>((ref) {
  return InterviewService(ApiClient());
});

class InterviewService {
  final ApiClient _apiClient;

  InterviewService(this._apiClient);

  Future<InterviewSessionData> startInterview({
    String targetRole = 'AI/ML Engineer',
    String difficulty = 'MID',
    String? skillFocus,
    int questionCount = 4,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.startInterview,
        data: {
          'targetRole': targetRole,
          'difficulty': difficulty,
          if (skillFocus != null) 'skillFocus': skillFocus,
          'questionCount': questionCount,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        return InterviewSessionData.fromJson(data);
      }
    } catch (_) {
      // Fallback for offline or demonstration mode
    }

    return InterviewSessionData(
      sessionId: 'session_demo_${DateTime.now().millisecondsSinceEpoch}',
      targetRole: targetRole,
      difficulty: difficulty,
      totalQuestions: 4,
      instructions:
        'Read each question carefully and provide detailed technical answers. Click evaluate to receive real-time AI scoring and guidance.',
      questions: [
        InterviewQuestion(
          id: 'q_1',
          category: 'System Architecture & LLMs',
          question: 'In designing a production RAG application for $targetRole, how do you mitigate hallucination and handle chunking strategies for diverse document formats?',
          expectedKeyPoints: [
            'Context-aware semantic chunking with overlap',
            'Embedding similarity thresholding & reranking',
            'Chain-of-thought grounding with citation validation',
          ],
          sampleAnswerGuide: 'Discuss semantic chunking, cross-encoder re-ranking, and strict prompt guardrails.',
        ),
        InterviewQuestion(
          id: 'q_2',
          category: 'Frameworks & State Management',
          question: 'How does state synchronization differ when implementing agentic cyclical graphs (e.g., LangGraph) versus linear chain workflows?',
          expectedKeyPoints: [
            'StateGraph checkpointing and time-travel debugging',
            'Reducer functions for accumulated state updates',
            'Conditional edge routing based on tool calling output',
          ],
          sampleAnswerGuide: 'Highlight cyclical persistence channels and iterative refinement loops.',
        ),
        InterviewQuestion(
          id: 'q_3',
          category: 'Database & Vector Search',
          question: 'What are the latency and indexing tradeoffs between HNSW and IVF-Flat indexing in vector databases?',
          expectedKeyPoints: [
            'HNSW graph traversal sub-linear query time',
            'IVF clusters vectors into Voronoi cells to save memory',
            'Hybrid search combining dense vectors and BM25 keywords',
          ],
          sampleAnswerGuide: 'Compare query latency, memory consumption, and hybrid search ergonomics.',
        ),
        InterviewQuestion(
          id: 'q_4',
          category: 'Concurrency & Scalability',
          question: 'How do you handle rate limits, asynchronous job queues, and SSE streaming for real-time generative responses?',
          expectedKeyPoints: [
            'Token bucket / Redis distributed rate limiting',
            'Streaming chunk response buffers using HTTP chunked transfer',
            'Background worker queues for heavy embeddings',
          ],
          sampleAnswerGuide: 'Describe token streaming and worker segregation for async tasks.',
        ),
      ],
    );
  }

  Future<AnswerEvaluationResult> evaluateAnswer({
    required String sessionId,
    required String questionId,
    required String questionText,
    required String candidateAnswer,
    String targetRole = 'AI/ML Engineer',
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.evaluateAnswer,
        data: {
          'sessionId': sessionId,
          'questionId': questionId,
          'questionText': questionText,
          'candidateAnswer': candidateAnswer,
          'targetRole': targetRole,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        return AnswerEvaluationResult.fromJson(data);
      }
    } catch (_) {
      // Fallback for offline or demonstration mode
    }

    final length = candidateAnswer.trim().length;
    final hasKeywords = RegExp(r'chunk|vector|rag|state|async|cache|test|metric|latency|token', caseSensitive: false)
        .hasMatch(candidateAnswer);

    int score = 70;
    if (length > 100 && hasKeywords) {
      score = 92;
    } else if (length > 40 || hasKeywords) {
      score = 84;
    } else if (length < 25) {
      score = 55;
    }

    return AnswerEvaluationResult(
      sessionId: sessionId,
      questionId: questionId,
      score: score,
      feedback: score >= 80
          ? 'Excellent answer! You demonstrated solid architectural understanding, clear terminology, and practical technical depth.'
          : 'Good foundational answer. Add more concrete architectural trade-offs, specific tools, and real-world latency metrics.',
      strengths: [
        'Clear technical communication and structured response',
        'Identified relevant domain concepts and challenges',
      ],
      areasForImprovement: [
        'Quantify system latency, throughput, and error boundaries',
        'Mention specific production monitoring & observability tools',
      ],
      modelAnswerTip:
        'Structure your response using the STAR or Problem-Tradeoff-Solution framework. Always mention resilience, edge cases, and testing strategy.',
    );
  }
}
