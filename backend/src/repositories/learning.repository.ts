import { LearningCategory, LearningDifficulty } from '../schemas/learning.schema';

export interface LearningModule {
  id: string;
  title: string;
  durationMinutes: number;
  externalUrl?: string;
}

export interface LearningCourse {
  id: string;
  title: string;
  description: string;
  category: LearningCategory;
  difficulty: LearningDifficulty;
  estimatedHours: number;
  skillsCovered: string[];
  modules: LearningModule[];
  enrollmentCount: number;
  rating: number; // 0.0 - 5.0
  createdAt: Date;
}

export interface UserLearningProgress {
  userId: string;
  courseId: string;
  bookmarked: boolean;
  completedModuleIds: string[];
  progressPercentage: number;
  lastAccessedAt: Date;
}

export class LearningRepository {
  private static coursesStore: Map<string, LearningCourse> = new Map();
  private static userProgressStore: Map<string, UserLearningProgress> = new Map();

  constructor() {
    this.seedDefaultCourses();
  }

  private seedDefaultCourses(): void {
    if (LearningRepository.coursesStore.size > 0) return;

    const initialCourses: LearningCourse[] = [
      {
        id: 'course_rag_01',
        title: 'Production RAG & Vector Search Architectures',
        description: 'Deep dive into hybrid dense-sparse search, cross-encoder reranking, and chunking trade-offs.',
        category: 'GEN_AI',
        difficulty: 'ADVANCED',
        estimatedHours: 12,
        skillsCovered: ['RAG', 'Vector DB', 'Cross-Encoders', 'Embeddings', 'LangChain'],
        modules: [
          { id: 'mod_101', title: 'Dense vs. Sparse Indexing: BM25 meets HNSW', durationMinutes: 45 },
          { id: 'mod_102', title: 'Context Window Optimization & Dynamic Chunking', durationMinutes: 60 },
          { id: 'mod_103', title: 'Two-Stage Re-ranking with Cohere & BGE', durationMinutes: 50 },
          { id: 'mod_104', title: 'Evaluating Retrieval Accuracy with RAGAS', durationMinutes: 75 },
        ],
        enrollmentCount: 1420,
        rating: 4.9,
        createdAt: new Date(Date.now() - 30 * 86400000),
      },
      {
        id: 'course_langgraph_02',
        title: 'Building Stateful Agentic Workflows with LangGraph',
        description: 'Orchestrate multi-agent systems, human-in-the-loop approvals, and graph state checkpoints.',
        category: 'GEN_AI',
        difficulty: 'ADVANCED',
        estimatedHours: 10,
        skillsCovered: ['LangGraph', 'Agentic AI', 'Multi-Agent', 'State Management'],
        modules: [
          { id: 'mod_201', title: 'Graph Node Definition & State Transition Rules', durationMinutes: 50 },
          { id: 'mod_202', title: 'Cyclic Reflection & Autonomous Self-Correction', durationMinutes: 65 },
          { id: 'mod_203', title: 'Persistent State Checkpointing with PostgreSQL', durationMinutes: 55 },
        ],
        enrollmentCount: 980,
        rating: 4.85,
        createdAt: new Date(Date.now() - 20 * 86400000),
      },
      {
        id: 'course_backend_03',
        title: 'Scalable Microservices with Node.js, Express & TypeScript',
        description: 'Build enterprise-grade distributed systems with rate limiting, JWT RBAC, and caching.',
        category: 'BACKEND',
        difficulty: 'INTERMEDIATE',
        estimatedHours: 16,
        skillsCovered: ['Node.js', 'Express', 'TypeScript', 'Clean Architecture', 'Redis'],
        modules: [
          { id: 'mod_301', title: 'Express Middleware Pipelines & Error Interception', durationMinutes: 40 },
          { id: 'mod_302', title: 'Prisma ORM Modeling & Connection Pooling', durationMinutes: 70 },
          { id: 'mod_303', title: 'Distributed Rate Limiting with Redis Token Bucket', durationMinutes: 55 },
          { id: 'mod_304', title: 'Graceful Shutdown & Kubernetes Health Probes', durationMinutes: 45 },
        ],
        enrollmentCount: 2310,
        rating: 4.92,
        createdAt: new Date(Date.now() - 45 * 86400000),
      },
      {
        id: 'course_k8s_04',
        title: 'Cloud-Native Container Orchestration & CI/CD Pipelines',
        description: 'Automate deployments using Docker, GitHub Actions, Helm charts, and Kubernetes clusters.',
        category: 'DEVOPS',
        difficulty: 'INTERMEDIATE',
        estimatedHours: 14,
        skillsCovered: ['Docker', 'Kubernetes', 'GitHub Actions', 'Helm', 'CI/CD'],
        modules: [
          { id: 'mod_401', title: 'Multi-stage Docker Builds for Lean Images', durationMinutes: 35 },
          { id: 'mod_402', title: 'GitHub Actions Matrix CI Workflows & Caching', durationMinutes: 60 },
          { id: 'mod_403', title: 'Deployments, Services & Ingress Networking', durationMinutes: 80 },
        ],
        enrollmentCount: 1650,
        rating: 4.78,
        createdAt: new Date(Date.now() - 60 * 86400000),
      },
    ];

    for (const course of initialCourses) {
      LearningRepository.coursesStore.set(course.id, course);
    }
  }

  async findAll(filter?: {
    category?: LearningCategory;
    difficulty?: LearningDifficulty;
    skill?: string;
  }): Promise<LearningCourse[]> {
    const list: LearningCourse[] = [];
    for (const course of LearningRepository.coursesStore.values()) {
      if (filter?.category && course.category !== filter.category) continue;
      if (filter?.difficulty && course.difficulty !== filter.difficulty) continue;
      if (filter?.skill) {
        const query = filter.skill.toLowerCase();
        const hasSkill = course.skillsCovered.some((s) => s.toLowerCase().includes(query));
        if (!hasSkill) continue;
      }
      list.push(course);
    }
    return list;
  }

  async findById(id: string): Promise<LearningCourse | null> {
    return LearningRepository.coursesStore.get(id) || null;
  }

  async create(course: LearningCourse): Promise<LearningCourse> {
    LearningRepository.coursesStore.set(course.id, course);
    return course;
  }

  async getUserProgress(userId: string, courseId: string): Promise<UserLearningProgress> {
    const key = `${userId}_${courseId}`;
    let progress = LearningRepository.userProgressStore.get(key);

    if (!progress) {
      progress = {
        userId,
        courseId,
        bookmarked: false,
        completedModuleIds: [],
        progressPercentage: 0,
        lastAccessedAt: new Date(),
      };
      LearningRepository.userProgressStore.set(key, progress);
    }

    return progress;
  }

  async toggleBookmark(userId: string, courseId: string): Promise<UserLearningProgress> {
    const progress = await this.getUserProgress(userId, courseId);
    progress.bookmarked = !progress.bookmarked;
    progress.lastAccessedAt = new Date();
    return progress;
  }

  async updateModuleStatus(
    userId: string,
    courseId: string,
    moduleId: string,
    completed: boolean
  ): Promise<UserLearningProgress> {
    const course = await this.findById(courseId);
    const progress = await this.getUserProgress(userId, courseId);

    if (completed && !progress.completedModuleIds.includes(moduleId)) {
      progress.completedModuleIds.push(moduleId);
    } else if (!completed) {
      progress.completedModuleIds = progress.completedModuleIds.filter((id) => id !== moduleId);
    }

    const totalModules = course?.modules.length || 1;
    progress.progressPercentage = Math.round((progress.completedModuleIds.length / totalModules) * 100);
    progress.lastAccessedAt = new Date();

    return progress;
  }

  async getUserEnrolledCourses(userId: string): Promise<Array<{ course: LearningCourse; progress: UserLearningProgress }>> {
    const results: Array<{ course: LearningCourse; progress: UserLearningProgress }> = [];

    for (const [key, progress] of LearningRepository.userProgressStore.entries()) {
      if (key.startsWith(`${userId}_`)) {
        const course = await this.findById(progress.courseId);
        if (course) {
          results.push({ course, progress });
        }
      }
    }

    return results;
  }
}

