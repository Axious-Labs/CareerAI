import { LearningRepository, LearningCourse, UserLearningProgress } from '../repositories/learning.repository';
import { CreateCourseInput, LearningQueryInput, UpdateModuleProgressInput } from '../schemas/learning.schema';
import { NotFoundError } from '../utils/errors';

export interface EnrolledCourseSummary {
  course: LearningCourse;
  progress: UserLearningProgress;
}

export class LearningService {
  constructor(private learningRepo: LearningRepository) {}

  async getAllCourses(query?: LearningQueryInput): Promise<LearningCourse[]> {
    return this.learningRepo.findAll({
      category: query?.category,
      difficulty: query?.difficulty,
      skill: query?.skill,
    });
  }

  async getCourseById(id: string): Promise<LearningCourse> {
    const course = await this.learningRepo.findById(id);
    if (!course) {
      throw new NotFoundError('Learning course not found');
    }
    return course;
  }

  async createCourse(input: CreateCourseInput): Promise<LearningCourse> {
    const id = `course_${Date.now()}_${Math.random().toString(36).substring(2, 6)}`;
    const modules = input.modules.map((m, idx) => ({
      id: `mod_${Date.now()}_${idx}`,
      title: m.title,
      durationMinutes: m.durationMinutes,
      externalUrl: m.externalUrl,
    }));

    const newCourse: LearningCourse = {
      id,
      title: input.title,
      description: input.description,
      category: input.category,
      difficulty: input.difficulty,
      estimatedHours: input.estimatedHours,
      skillsCovered: input.skillsCovered,
      modules,
      enrollmentCount: 0,
      rating: 5.0,
      createdAt: new Date(),
    };

    return this.learningRepo.create(newCourse);
  }

  async toggleBookmark(userId: string, courseId: string): Promise<UserLearningProgress> {
    await this.getCourseById(courseId); // Throws 404 if not found
    return this.learningRepo.toggleBookmark(userId, courseId);
  }

  async updateModuleProgress(
    userId: string,
    courseId: string,
    input: UpdateModuleProgressInput
  ): Promise<UserLearningProgress> {
    const course = await this.getCourseById(courseId);
    const hasModule = course.modules.some((m) => m.id === input.moduleId);
    if (!hasModule) {
      throw new NotFoundError(`Module ${input.moduleId} not found in this course`);
    }

    return this.learningRepo.updateModuleStatus(userId, courseId, input.moduleId, input.completed);
  }

  async getUserEnrolledCourses(userId: string): Promise<EnrolledCourseSummary[]> {
    return this.learningRepo.getUserEnrolledCourses(userId);
  }

  async getRecommendedCourses(skills: string[]): Promise<LearningCourse[]> {
    const allCourses = await this.learningRepo.findAll();
    const normalizedSkills = skills.map((s) => s.toLowerCase());

    const scoredCourses = allCourses.map((c) => {
      const matchCount = c.skillsCovered.filter((skill) =>
        normalizedSkills.some((ns) => skill.toLowerCase().includes(ns))
      ).length;
      return { course: c, matchCount };
    });

    scoredCourses.sort((a, b) => b.matchCount - a.matchCount);
    return scoredCourses.map((item) => item.course);
  }
}

