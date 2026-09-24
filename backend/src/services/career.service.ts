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
}
