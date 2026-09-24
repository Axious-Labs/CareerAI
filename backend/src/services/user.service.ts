import { UserRepository } from '../repositories/user.repository';
import { SkillRepository } from '../repositories/skill.repository';
import { NotFoundError } from '../utils/errors';
import { UpdateUserInput } from '../schemas/user.schema';

export class UserService {
  constructor(
    private userRepo: UserRepository,
    private skillRepo: SkillRepository
  ) {}

  async getProfile(userId: string) {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new NotFoundError('User profile not found');
    }

    const userSkills = await this.skillRepo.getUserSkills(userId);

    const skillsData =
      userSkills.length > 0
        ? userSkills.map((us) => ({
            id: us.skillId,
            name: us.skill.name,
            proficiency: us.proficiency,
            score: us.proficiency === 'ADVANCED' ? 80 : us.proficiency === 'INTERMEDIATE' ? 65 : 40,
          }))
        : [
            { id: 'sk_1', name: 'Python', proficiency: 'ADVANCED', score: 80 },
            { id: 'sk_2', name: 'Flutter', proficiency: 'INTERMEDIATE', score: 70 },
            { id: 'sk_3', name: 'GenAI', proficiency: 'INTERMEDIATE', score: 60 },
            { id: 'sk_4', name: 'ML', proficiency: 'BEGINNER', score: 40 },
          ];

    return {
      id: user.id,
      name: user.name,
      email: user.email,
      targetRole: user.targetRole || 'AI/ML Engineer',
      careerReadiness: 68,
      skills: skillsData,
      todayPlan: [
        { id: 'p1', title: 'Complete Transformers lesson', completed: true },
        { id: 'p2', title: 'Solve 2 DSA problems', completed: true },
        { id: 'p3', title: 'Apply to 3 relevant jobs', completed: false },
      ],
      quickActions: [
        { title: 'Analyze Resume', route: '/resume' },
        { title: 'Skill Gap', route: '/skills' },
        { title: 'Find Jobs', route: '/jobs' },
        { title: 'AI Career Assistant', route: '/ai-chat' },
      ],
    };
  }

  async updateProfile(userId: string, input: UpdateUserInput) {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new NotFoundError('User not found');
    }

    return this.userRepo.update(userId, {
      ...(input.name ? { name: input.name } : {}),
      ...(input.targetRole ? { targetRole: input.targetRole } : {}),
    });
  }
}
