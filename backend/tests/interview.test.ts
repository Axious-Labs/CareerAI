import { InterviewService } from '../src/services/interview.service';
import { GenAIClient } from '../src/integrations/genai/genai.client';
import { UserRepository } from '../src/repositories/user.repository';
import { SkillRepository } from '../src/repositories/skill.repository';

describe('Interview Assessment Service Tests', () => {
  const mockUserRepo = {
    findById: jest.fn().mockResolvedValue({
      id: 'usr_interview_test',
      name: 'Alex Chen',
      targetRole: 'AI/ML Engineer',
    }),
  } as unknown as UserRepository;

  const mockSkillRepo = {
    getUserSkills: jest.fn().mockResolvedValue([
      { skillId: 'sk_1', skill: { name: 'Python' } },
      { skillId: 'sk_2', skill: { name: 'LangChain' } },
    ]),
  } as unknown as SkillRepository;

  const genAIClient = new GenAIClient();
  const interviewService = new InterviewService(genAIClient, mockUserRepo, mockSkillRepo);

  it('should start mock interview session and return structured technical questions', async () => {
    const session = await interviewService.startInterview(
      'usr_interview_test',
      'AI/ML Engineer',
      'MID',
      'LangGraph',
      3
    );

    expect(session.sessionId).toBeDefined();
    expect(session.targetRole).toBe('AI/ML Engineer');
    expect(session.difficulty).toBe('MID');
    expect(session.questions.length).toBe(3);
    expect(session.questions[0].question).toBeDefined();
    expect(session.questions[0].expectedKeyPoints.length).toBeGreaterThan(0);
  });

  it('should evaluate candidate answer with AI scoring and feedback tips', async () => {
    const session = await interviewService.startInterview(
      'usr_interview_test',
      'AI/ML Engineer',
      'MID',
      'RAG',
      2
    );

    const question = session.questions[0];
    const evaluation = await interviewService.evaluateAnswer(
      'usr_interview_test',
      session.sessionId,
      question.id,
      question.question,
      'I implement semantic chunking with overlap and use vector embeddings with FAISS and cross-encoder reranking to prevent hallucination.',
      'AI/ML Engineer'
    );

    expect(evaluation.score).toBeGreaterThanOrEqual(70);
    expect(evaluation.feedback).toBeDefined();
    expect(evaluation.strengths.length).toBeGreaterThan(0);
    expect(evaluation.areasForImprovement.length).toBeGreaterThan(0);
    expect(evaluation.modelAnswerTip).toBeDefined();
  });

  it('should return session history summaries for user', async () => {
    const history = await interviewService.getInterviewHistory('usr_interview_test');
    expect(history.length).toBeGreaterThan(0);
    expect(history[0].targetRole).toBe('AI/ML Engineer');
    expect(history[0].readinessFeedback).toBeDefined();
  });
});
