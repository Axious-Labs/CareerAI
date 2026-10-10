import { SkillService } from '../src/services/skill.service';
import { SkillRepository } from '../src/repositories/skill.repository';
import { Proficiency } from '@prisma/client';
import { NotFoundError } from '../src/utils/errors';

describe('Skill Service & Proficiency Mapping Tests', () => {
  let mockSkillRepo: jest.Mocked<Partial<SkillRepository>>;
  let skillService: SkillService;

  beforeEach(() => {
    mockSkillRepo = {
      findAll: jest.fn().mockResolvedValue([
        { id: 'sk_1', name: 'Python', category: 'Backend', createdAt: new Date() },
        { id: 'sk_2', name: 'LangGraph', category: 'AI', createdAt: new Date() },
        { id: 'sk_3', name: 'Flutter', category: 'Mobile', createdAt: new Date() },
      ]),
      findById: jest.fn().mockImplementation((id: string) => {
        if (id === 'sk_1') {
          return Promise.resolve({
            id: 'sk_1',
            name: 'Python',
            category: 'Backend',
            createdAt: new Date(),
          });
        }
        return Promise.resolve(null);
      }),
      create: jest.fn().mockImplementation((name: string, category: string) =>
        Promise.resolve({
          id: 'sk_new',
          name,
          category,
          createdAt: new Date(),
        })
      ),
      upsertUserSkill: jest.fn().mockImplementation((userId, skillId, proficiency) =>
        Promise.resolve({
          userId,
          skillId,
          proficiency,
          createdAt: new Date(),
        })
      ),
      getUserSkills: jest.fn().mockResolvedValue([
        {
          userId: 'usr_test',
          skillId: 'sk_1',
          proficiency: Proficiency.ADVANCED,
          createdAt: new Date(),
          skill: { id: 'sk_1', name: 'Python', category: 'Backend', createdAt: new Date() },
        },
      ]),
    };

    skillService = new SkillService(mockSkillRepo as unknown as SkillRepository);
  });

  it('should list all available skills', async () => {
    const skills = await skillService.getAllSkills();
    expect(skills.length).toBe(3);
    expect(skills[0].name).toBe('Python');
    expect(mockSkillRepo.findAll).toHaveBeenCalled();
  });

  it('should create a new taxonomy skill', async () => {
    const created = await skillService.createSkill({
      name: 'RAG Architecture',
      category: 'Generative AI',
    });
    expect(created.name).toBe('RAG Architecture');
    expect(mockSkillRepo.create).toHaveBeenCalledWith('RAG Architecture', 'Generative AI');
  });

  it('should add skill to user profile with proficiency level', async () => {
    const result = await skillService.addUserSkill('usr_test', {
      skillId: 'sk_1',
      proficiency: 'EXPERT',
    });

    expect(result.proficiency).toBe('EXPERT');
    expect(mockSkillRepo.upsertUserSkill).toHaveBeenCalledWith(
      'usr_test',
      'sk_1',
      Proficiency.EXPERT
    );
  });

  it('should throw NotFoundError when assigning non-existent skillId', async () => {
    await expect(
      skillService.addUserSkill('usr_test', {
        skillId: 'sk_nonexistent',
        proficiency: 'INTERMEDIATE',
      })
    ).rejects.toThrow(NotFoundError);
  });

  it('should return user associated skills', async () => {
    const userSkills = await skillService.getUserSkills('usr_test');
    expect(userSkills.length).toBe(1);
    expect(userSkills[0].skill.name).toBe('Python');
    expect(userSkills[0].proficiency).toBe(Proficiency.ADVANCED);
  });
});
