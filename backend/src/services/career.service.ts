import { GenAIClient } from '../integrations/genai/genai.client';
import { AgentClient } from '../integrations/agents/agent.client';
import { UserRepository } from '../repositories/user.repository';
import { SkillRepository } from '../repositories/skill.repository';

export class CareerService {
  constructor(
    private genaiClient: GenAIClient,
    private agentClient: AgentClient,
    private userRepo: UserRepository,
    private skillRepo: SkillRepository
  ) {}

  async analyzeProfile(userId: string, targetRoleInput?: string) {
    const user = await this.userRepo.findById(userId);
    const userSkills = await this.skillRepo.getUserSkills(userId);
    const targetRole = targetRoleInput || user?.targetRole || 'AI/ML Engineer';

    const skillNames =
      userSkills.length > 0
        ? userSkills.map((us) => us.skill.name)
        : ['Python', 'Flutter', 'GenAI', 'ML'];

    const gapResult = await this.genaiClient.analyzeSkillGap(skillNames, targetRole);

    return {
      userId,
      targetRole,
      careerReadiness: gapResult.readinessScore || 68,
      topSkills: skillNames,
      missingSkills: gapResult.missingSkills,
      summary: `Your profile demonstrates strong proficiency in ${skillNames.slice(0, 2).join(' and ')}. Focus on mastering missing skills to hit 90%+ readiness.`,
    };
  }

  async getSkillGap(userId: string, targetRoleInput?: string) {
    const user = await this.userRepo.findById(userId);
    const userSkills = await this.skillRepo.getUserSkills(userId);
    const targetRole = targetRoleInput || user?.targetRole || 'AI/ML Engineer';

    const skillNames =
      userSkills.length > 0
        ? userSkills.map((us) => us.skill.name)
        : ['Python', 'Flutter', 'GenAI', 'ML'];

    return this.genaiClient.analyzeSkillGap(skillNames, targetRole);
  }

  async getRoadmap(userId: string, targetRoleInput?: string, timelineWeeks = 8) {
    const user = await this.userRepo.findById(userId);
    const targetRole = targetRoleInput || user?.targetRole || 'AI/ML Engineer';

    return this.agentClient.createLearningRoadmap(userId, targetRole, timelineWeeks);
  }

  async getCuratedResources(targetRoleInput?: string) {
    const role = targetRoleInput || 'AI/ML Engineer';
    return [
      {
        id: 'res_01',
        title: 'LangGraph Multi-Agent Orchestration Blueprint',
        category: 'Agentic AI',
        difficulty: 'ADVANCED',
        url: 'https://langchain-ai.github.io/langgraph/',
        estimatedHours: 6,
        description: 'Design cyclic state machines with human-in-the-loop validation, persistence, and tool routing.',
      },
      {
        id: 'res_02',
        title: 'Production RAG: Chunking, Cross-Encoders & Reranking',
        category: 'Generative AI',
        difficulty: 'INTERMEDIATE',
        url: 'https://github.com/Axious-Labs/CareerAI',
        estimatedHours: 4,
        description: 'Optimize vector retrieval precision and mitigate hallucination in domain-specific QA models.',
      },
      {
        id: 'res_03',
        title: 'LLM Inference Optimization & Quantization (AWQ/GPTQ)',
        category: 'Machine Learning Systems',
        difficulty: 'ADVANCED',
        url: 'https://huggingface.co/docs/transformers/main_classes/quantization',
        estimatedHours: 5,
        description: 'Understand latency vs throughput tradeoffs and deployment with vLLM and TensorRT-LLM.',
      },
      {
        id: 'res_04',
        title: 'Cross-Platform State Management with Flutter & Riverpod 2.0',
        category: 'Client Engineering',
        difficulty: 'INTERMEDIATE',
        url: 'https://riverpod.dev',
        estimatedHours: 3,
        description: 'Clean reactive architecture with code generation, asynchronous state caching, and widget testing.',
      },
    ];
  }
}
