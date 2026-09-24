import { prisma } from '../config/database';
import { Resume, ResumeStatus } from '@prisma/client';

export class ResumeRepository {
  async findByUserId(userId: string): Promise<Resume[]> {
    return prisma.resume.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findById(id: string): Promise<Resume | null> {
    return prisma.resume.findUnique({
      where: { id },
    });
  }

  async create(userId: string, fileName: string, fileUrl: string): Promise<Resume> {
    return prisma.resume.create({
      data: {
        userId,
        fileName,
        fileUrl,
        status: ResumeStatus.PENDING,
      },
    });
  }

  async updateStatus(id: string, status: ResumeStatus): Promise<Resume> {
    return prisma.resume.update({
      where: { id },
      data: { status },
    });
  }
}
