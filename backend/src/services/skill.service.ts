import { SkillRepository } from '../repositories/skill.repository';
import { AddSkillInput, CreateSkillInput } from '../schemas/skill.schema';
import { NotFoundError } from '../utils/errors';
import { Proficiency } from '@prisma/client';

export class SkillService {
  constructor(private skillRepo: SkillRepository) {}

  async getAllSkills() {
    return this.skillRepo.findAll();
  }

  async createSkill(input: CreateSkillInput) {
    return this.skillRepo.create(input.name, input.category);
  }

  async addUserSkill(userId: string, input: AddSkillInput) {
    const skill = await this.skillRepo.findById(input.skillId);
    if (!skill) {
      throw new NotFoundError('Skill not found');
    }

    return this.skillRepo.upsertUserSkill(
      userId,
      input.skillId,
      input.proficiency as Proficiency
    );
  }

  async getUserSkills(userId: string) {
    return this.skillRepo.getUserSkills(userId);
  }
}
