import { CareerService } from '../src/services/career.service';
import { GenAIClient } from '../src/integrations/genai/genai.client';
import { AgentClient } from '../src/integrations/agents/agent.client';
import { UserRepository } from '../src/repositories/user.repository';
import { SkillRepository } from '../src/repositories/skill.repository';

describe('Career Intelligence Service Tests', () => {
  it('should analyze profile and return readiness score and gaps', async () => {
    const mockUserRepo = {
      findById: jest.fn().mockResolvedValue({
        id: 'usr_test',
        name: 'Alex Chen',
        targetRole: 'AI/ML Engineer',
      }),
    } as unknown as UserRepository;

    const mockSkillRepo = {
      getUserSkills: jest.fn().mockResolvedValue([
        { skillId: 'sk_1', skill: { name: 'Python' } },
        { skillId: 'sk_2', skill: { name: 'Flutter' } },
      ]),
    } as unknown as SkillRepository;

    const mockGenAIClient = new GenAIClient();
    const mockAgentClient = new AgentClient();

    const careerService = new CareerService(
      mockGenAIClient,
      mockAgentClient,
      mockUserRepo,
      mockSkillRepo
    );

    const result = await careerService.analyzeProfile('usr_test', 'AI/ML Engineer');

    expect(result.userId).toBe('usr_test');
    expect(result.targetRole).toBe('AI/ML Engineer');
    expect(result.careerReadiness).toBeGreaterThanOrEqual(0);
    expect(result.topSkills).toContain('Python');
    expect(result.missingSkills.length).toBeGreaterThan(0);
  });
});
