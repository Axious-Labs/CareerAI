import { prisma } from '../config/database';
import { Skill, UserSkill, Proficiency } from '@prisma/client';

export class SkillRepository {
  async findAll(): Promise<Skill[]> {
    return prisma.skill.findMany({
      orderBy: { category: 'asc' },
    });
  }

  async findById(id: string): Promise<Skill | null> {
    return prisma.skill.findUnique({
      where: { id },
    });
  }

  async findByName(name: string): Promise<Skill | null> {
    return prisma.skill.findUnique({
      where: { name },
    });
  }

  async create(name: string, category: string): Promise<Skill> {
    return prisma.skill.create({
      data: { name, category },
    });
  }

  async getUserSkills(userId: string): Promise<(UserSkill & { skill: Skill })[]> {
    return prisma.userSkill.findMany({
      where: { userId },
      include: { skill: true },
    });
  }

  async upsertUserSkill(userId: string, skillId: string, proficiency: Proficiency): Promise<UserSkill> {
    return prisma.userSkill.upsert({
      where: {
        userId_skillId: {
          userId,
          skillId,
        },
      },
      update: { proficiency },
      create: {
        userId,
        skillId,
        proficiency,
      },
    });
  }
}
