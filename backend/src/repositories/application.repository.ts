import { prisma } from '../config/database';
import { Application, ApplicationStatus, Prisma } from '@prisma/client';

export class ApplicationRepository {
  async findByUserId(userId: string): Promise<(Application & { job: any })[]> {
    return prisma.application.findMany({
      where: { userId },
      include: { job: true },
      orderBy: { appliedAt: 'desc' },
    });
  }

  async findById(id: string): Promise<(Application & { job: any }) | null> {
    return prisma.application.findUnique({
      where: { id },
      include: { job: true },
    });
  }

  async create(data: Prisma.ApplicationUncheckedCreateInput): Promise<Application> {
    return prisma.application.create({
      data,
    });
  }

  async updateStatus(id: string, status: ApplicationStatus, notes?: string): Promise<Application> {
    return prisma.application.update({
      where: { id },
      data: {
        status,
        ...(notes !== undefined ? { notes } : {}),
      },
    });
  }
}
