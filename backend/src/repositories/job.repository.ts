import { prisma } from '../config/database';
import { Job, Prisma } from '@prisma/client';

export class JobRepository {
  async findAll(roleFilter?: string): Promise<Job[]> {
    const where: Prisma.JobWhereInput = {};
    if (roleFilter) {
      where.title = {
        contains: roleFilter,
        mode: 'insensitive',
      };
    }
    return prisma.job.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }

  async findById(id: string): Promise<Job | null> {
    return prisma.job.findUnique({
      where: { id },
    });
  }

  async create(data: Prisma.JobCreateInput): Promise<Job> {
    return prisma.job.create({
      data,
    });
  }

  async search(query?: string, location?: string): Promise<Job[]> {
    const where: Prisma.JobWhereInput = {};
    const conditions: Prisma.JobWhereInput[] = [];

    if (query) {
      conditions.push({
        OR: [
          { title: { contains: query, mode: 'insensitive' } },
          { description: { contains: query, mode: 'insensitive' } },
          { company: { contains: query, mode: 'insensitive' } },
        ],
      });
    }

    if (location) {
      conditions.push({
        location: { contains: location, mode: 'insensitive' },
      });
    }

    if (conditions.length > 0) {
      where.AND = conditions;
    }

    return prisma.job.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });
  }
}
