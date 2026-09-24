import { ResumeRepository } from '../repositories/resume.repository';
import { GenAIClient } from '../integrations/genai/genai.client';
import { UploadResumeInput } from '../schemas/resume.schema';
import { ResumeStatus } from '@prisma/client';
import { NotFoundError } from '../utils/errors';

export class ResumeService {
  constructor(
    private resumeRepo: ResumeRepository,
    private genaiClient: GenAIClient
  ) {}

  async uploadResume(userId: string, input: UploadResumeInput) {
    const resume = await this.resumeRepo.create(userId, input.fileName, input.fileUrl);

    // Call GenAI client to parse resume and extract skills
    const analysis = await this.genaiClient.analyzeResume(input.fileName, input.fileUrl);

    // Mark as parsed
    const updated = await this.resumeRepo.updateStatus(resume.id, ResumeStatus.PARSED);

    return {
      ...updated,
      extractedSkills: analysis.extractedSkills,
      summary: analysis.summary,
      experienceYears: analysis.experienceYears,
    };
  }

  async getUserResumes(userId: string) {
    return this.resumeRepo.findByUserId(userId);
  }

  async getResumeById(id: string) {
    const resume = await this.resumeRepo.findById(id);
    if (!resume) {
      throw new NotFoundError('Resume not found');
    }
    return resume;
  }
}
