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
}
