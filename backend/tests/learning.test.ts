import { LearningService } from '../src/services/learning.service';
import { LearningRepository } from '../src/repositories/learning.repository';
import { NotFoundError } from '../src/utils/errors';

describe('Learning & Mentorship Directory Service Tests', () => {
  let learningRepo: LearningRepository;
  let learningService: LearningService;

  beforeEach(() => {
    learningRepo = new LearningRepository();
    learningService = new LearningService(learningRepo);
  });

  it('should fetch all available learning courses', async () => {
    const courses = await learningService.getAllCourses();
    expect(courses.length).toBeGreaterThanOrEqual(4);
    expect(courses[0].title).toBeDefined();
    expect(courses[0].modules.length).toBeGreaterThan(0);
  });

  it('should filter courses by category and difficulty', async () => {
    const genAiCourses = await learningService.getAllCourses({
      category: 'GEN_AI',
      difficulty: 'ADVANCED',
    });

    expect(genAiCourses.length).toBeGreaterThan(0);
    expect(genAiCourses.every((c) => c.category === 'GEN_AI')).toBe(true);
    expect(genAiCourses.every((c) => c.difficulty === 'ADVANCED')).toBe(true);
  });

  it('should filter courses by covered skill', async () => {
    const courses = await learningService.getAllCourses({ skill: 'Docker' });
    expect(courses.length).toBeGreaterThan(0);
    expect(courses.some((c) => c.skillsCovered.includes('Docker'))).toBe(true);
  });

  it('should create a new course with structured modules', async () => {
    const input = {
      title: 'Distributed Systems & Event-Driven Microservices',
      description: 'Master Kafka, RabbitMQ, and idempotency patterns in enterprise TypeScript apps.',
      category: 'BACKEND' as const,
      difficulty: 'ADVANCED' as const,
      estimatedHours: 20,
      skillsCovered: ['Kafka', 'TypeScript', 'Event Sourcing'],
      modules: [
        { title: 'Designing idempotent consumer pipelines', durationMinutes: 60 },
        { title: 'Outbox Pattern and Change Data Capture', durationMinutes: 75 },
      ],
    };

    const course = await learningService.createCourse(input);
    expect(course.id).toBeDefined();
    expect(course.title).toBe(input.title);
    expect(course.modules.length).toBe(2);
    expect(course.rating).toBe(5.0);
  });

  it('should toggle course bookmarking for a user', async () => {
    const courses = await learningService.getAllCourses();
    const courseId = courses[0].id;

    const progress1 = await learningService.toggleBookmark('usr_learner', courseId);
    expect(progress1.bookmarked).toBe(true);

    const progress2 = await learningService.toggleBookmark('usr_learner', courseId);
    expect(progress2.bookmarked).toBe(false);
  });

  it('should update module completion and calculate course progress', async () => {
    const courses = await learningService.getAllCourses();
    const targetCourse = courses[0];
    const targetModule = targetCourse.modules[0];

    const progress = await learningService.updateModuleProgress('usr_learner_2', targetCourse.id, {
      moduleId: targetModule.id,
      completed: true,
    });

    expect(progress.completedModuleIds).toContain(targetModule.id);
    expect(progress.progressPercentage).toBeGreaterThan(0);
  });

  it('should throw NotFoundError when accessing non-existent course', async () => {
    await expect(learningService.getCourseById('course_invalid_123')).rejects.toThrow(
      NotFoundError
    );
  });

  it('should recommend courses based on a user skills array', async () => {
    const recommended = await learningService.getRecommendedCourses(['LangGraph', 'RAG']);
    expect(recommended.length).toBeGreaterThan(0);
    expect(recommended[0].skillsCovered.some((s) => ['LangGraph', 'RAG'].includes(s))).toBe(true);
  });
});

