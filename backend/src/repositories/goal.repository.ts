import { GoalCategory, GoalStatus } from '../schemas/goal.schema';

export interface Milestone {
  id: string;
  title: string;
  completed: boolean;
  completedAt?: Date;
}

export interface CareerGoal {
  id: string;
  userId: string;
  title: string;
  description: string;
  category: GoalCategory;
  progressPercentage: number;
  status: GoalStatus;
  targetDate?: string;
  milestones: Milestone[];
  createdAt: Date;
  updatedAt: Date;
}

export class GoalRepository {
  private static goalsStore: Map<string, CareerGoal> = new Map();

  constructor() {
    this.seedDefaultGoals();
  }

  private seedDefaultGoals() {
    if (GoalRepository.goalsStore.size > 0) return;

    const initialGoals: CareerGoal[] = [
      {
        id: 'goal_01',
        userId: 'usr_default',
        title: 'Master LangGraph Cyclic AI Workflows',
        description: 'Build stateful multi-agent systems and learn checkpointing for fault-tolerant orchestration.',
        category: 'SKILL_ACQUISITION',
        progressPercentage: 65,
        status: 'ACTIVE',
        targetDate: '2026-11-15',
        milestones: [
          { id: 'm_101', title: 'Complete LangGraph StateGraph tutorial', completed: true, completedAt: new Date() },
          { id: 'm_102', title: 'Implement tool calling and cyclic human-in-the-loop approvals', completed: true, completedAt: new Date() },
          { id: 'm_103', title: 'Deploy persistent SQLite/Postgres checkpointer in production', completed: false },
        ],
        createdAt: new Date(Date.now() - 10 * 86400000),
        updatedAt: new Date(),
      },
      {
        id: 'goal_02',
        userId: 'usr_default',
        title: 'Complete 5 Mock Technical System Architecture Interviews',
        description: 'Practice real-time LLM inference optimization, latency bottlenecks, and vector search trade-offs.',
        category: 'INTERVIEW_PRACTICE',
        progressPercentage: 40,
        status: 'ACTIVE',
        targetDate: '2026-11-01',
        milestones: [
          { id: 'm_201', title: 'Session 1: LLM Latency & Quantization', completed: true, completedAt: new Date() },
          { id: 'm_202', title: 'Session 2: RAG Pipeline Chunking & Cross-Encoders', completed: true, completedAt: new Date() },
          { id: 'm_203', title: 'Session 3: Agentic State Machines & Memory', completed: false },
          { id: 'm_204', title: 'Session 4: Large Scale Embeddings Search', completed: false },
          { id: 'm_205', title: 'Session 5: Mock Interview with Engineering Lead', completed: false },
        ],
        createdAt: new Date(Date.now() - 7 * 86400000),
        updatedAt: new Date(),
      },
      {
        id: 'goal_03',
        userId: 'usr_default',
        title: 'Submit 10 Targeted Applications to AI Companies',
        description: 'Track and follow up on applications at leading tech ventures including Axious Labs.',
        category: 'APPLICATION_TARGET',
        progressPercentage: 50,
        status: 'ACTIVE',
        targetDate: '2026-10-31',
        milestones: [
          { id: 'm_301', title: 'Apply to Axious Labs Junior AI Engineer role', completed: true, completedAt: new Date() },
          { id: 'm_302', title: 'Apply to TechFlow Systems ML Associate role', completed: true, completedAt: new Date() },
          { id: 'm_303', title: 'Apply to Nexus Innovations Full-Stack AI role', completed: true, completedAt: new Date() },
          { id: 'm_304', title: 'Apply to Cognitive Matrix AI Intern role', completed: false },
        ],
        createdAt: new Date(Date.now() - 5 * 86400000),
        updatedAt: new Date(),
      },
      {
        id: 'goal_04',
        userId: 'usr_default',
        title: 'Build & Open-Source Production RAG Portfolio Project',
        description: 'Develop full-stack project using Flutter mobile frontend, Express API Gateway, and FastAPI GenAI backend.',
        category: 'PORTFOLIO_PROJECT',
        progressPercentage: 85,
        status: 'ACTIVE',
        targetDate: '2026-10-25',
        milestones: [
          { id: 'm_401', title: 'Design REST API contract and OpenAPI documentation', completed: true, completedAt: new Date() },
          { id: 'm_402', title: 'Build Flutter cross-platform UI with Material 3', completed: true, completedAt: new Date() },
          { id: 'm_403', title: 'Implement automated CI/CD unit and widget test pipelines', completed: true, completedAt: new Date() },
          { id: 'm_404', title: 'Write comprehensive README and architectural diagram', completed: false },
        ],
        createdAt: new Date(Date.now() - 14 * 86400000),
        updatedAt: new Date(),
      },
    ];

    for (const goal of initialGoals) {
      GoalRepository.goalsStore.set(goal.id, goal);
    }
  }

  async findByUserId(userId: string, category?: string): Promise<CareerGoal[]> {
    const goals: CareerGoal[] = [];
    for (const goal of GoalRepository.goalsStore.values()) {
      if (goal.userId === userId || goal.userId === 'usr_default') {
        if (!category || goal.category === category) {
          goals.push({ ...goal });
        }
      }
    }
    return goals.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
  }

  async findById(id: string): Promise<CareerGoal | null> {
    const goal = GoalRepository.goalsStore.get(id);
    return goal ? { ...goal } : null;
  }

  async create(goal: CareerGoal): Promise<CareerGoal> {
    GoalRepository.goalsStore.set(goal.id, { ...goal });
    return { ...goal };
  }

  async update(id: string, partial: Partial<CareerGoal>): Promise<CareerGoal | null> {
    const existing = GoalRepository.goalsStore.get(id);
    if (!existing) return null;

    const updated: CareerGoal = {
      ...existing,
      ...partial,
      updatedAt: new Date(),
    };
    GoalRepository.goalsStore.set(id, updated);
    return { ...updated };
  }

  async delete(id: string): Promise<boolean> {
    return GoalRepository.goalsStore.delete(id);
  }
}
