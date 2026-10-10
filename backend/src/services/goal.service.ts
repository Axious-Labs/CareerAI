import { GoalRepository, CareerGoal, Milestone } from '../repositories/goal.repository';
import { CreateGoalInput, GoalStatus } from '../schemas/goal.schema';
import { NotFoundError, UnauthorizedError } from '../utils/errors';

export interface GoalsSummary {
  totalGoals: number;
  activeGoals: number;
  completedGoals: number;
  averageProgressPercentage: number;
  categoryBreakdown: Record<string, { count: number; averageProgress: number }>;
  nextMilestones: Array<{
    goalId: string;
    goalTitle: string;
    milestoneId: string;
    milestoneTitle: string;
  }>;
}

export class GoalService {
  constructor(private goalRepo: GoalRepository) {}

  async createGoal(userId: string, input: CreateGoalInput): Promise<CareerGoal> {
    const goalId = `goal_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
    const milestones: Milestone[] = (input.milestones || []).map((m, idx) => ({
      id: `m_${Date.now()}_${idx}`,
      title: m.title,
      completed: false,
    }));

    const newGoal: CareerGoal = {
      id: goalId,
      userId,
      title: input.title,
      description: input.description,
      category: input.category,
      progressPercentage: 0,
      status: 'ACTIVE',
      targetDate: input.targetDate,
      milestones,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    return this.goalRepo.create(newGoal);
  }

  async getUserGoals(userId: string, category?: string): Promise<CareerGoal[]> {
    return this.goalRepo.findByUserId(userId, category);
  }

  async getGoalById(userId: string, id: string): Promise<CareerGoal> {
    const goal = await this.goalRepo.findById(id);
    if (!goal) {
      throw new NotFoundError('Goal not found');
    }
    return goal;
  }

  async updateProgress(
    userId: string,
    id: string,
    progressPercentage: number,
    status?: GoalStatus
  ): Promise<CareerGoal> {
    const goal = await this.getGoalById(userId, id);
    if (goal.userId !== userId && goal.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to update this goal');
    }

    const calculatedStatus: GoalStatus =
      status || (progressPercentage >= 100 ? 'COMPLETED' : goal.status);

    const updated = await this.goalRepo.update(id, {
      progressPercentage,
      status: calculatedStatus,
    });

    if (!updated) {
      throw new NotFoundError('Goal not found');
    }
    return updated;
  }

  async toggleMilestone(
    userId: string,
    goalId: string,
    milestoneId: string
  ): Promise<CareerGoal> {
    const goal = await this.getGoalById(userId, goalId);
    if (goal.userId !== userId && goal.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to update this goal');
    }

    const milestoneIndex = goal.milestones.findIndex((m) => m.id === milestoneId);
    if (milestoneIndex === -1) {
      throw new NotFoundError('Milestone not found');
    }

    const milestone = goal.milestones[milestoneIndex];
    const newCompleted = !milestone.completed;
    goal.milestones[milestoneIndex] = {
      ...milestone,
      completed: newCompleted,
      completedAt: newCompleted ? new Date() : undefined,
    };

    // Auto-calculate progress based on completed milestones
    const completedCount = goal.milestones.filter((m) => m.completed).length;
    const progressPercentage = Math.round((completedCount / goal.milestones.length) * 100);
    const newStatus: GoalStatus = progressPercentage >= 100 ? 'COMPLETED' : 'ACTIVE';

    const updated = await this.goalRepo.update(goalId, {
      milestones: goal.milestones,
      progressPercentage,
      status: newStatus,
    });

    return updated!;
  }

  async addMilestone(
    userId: string,
    goalId: string,
    title: string
  ): Promise<CareerGoal> {
    const goal = await this.getGoalById(userId, goalId);
    if (goal.userId !== userId && goal.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to modify this goal');
    }

    const newMilestone: Milestone = {
      id: `m_${Date.now()}_${Math.random().toString(36).substring(2, 5)}`,
      title,
      completed: false,
    };

    goal.milestones.push(newMilestone);
    const completedCount = goal.milestones.filter((m) => m.completed).length;
    const progressPercentage = Math.round((completedCount / goal.milestones.length) * 100);

    const updated = await this.goalRepo.update(goalId, {
      milestones: goal.milestones,
      progressPercentage,
    });

    return updated!;
  }

  async deleteGoal(userId: string, id: string): Promise<{ id: string; message: string }> {
    const goal = await this.getGoalById(userId, id);
    if (goal.userId !== userId && goal.userId !== 'usr_default') {
      throw new UnauthorizedError('Unauthorized to delete this goal');
    }

    await this.goalRepo.delete(id);
    return { id, message: 'Career goal deleted successfully' };
  }

  async getGoalsSummary(userId: string): Promise<GoalsSummary> {
    const goals = await this.getUserGoals(userId);
    const totalGoals = goals.length;
    const completedGoals = goals.filter((g) => g.status === 'COMPLETED').length;
    const activeGoals = goals.filter((g) => g.status === 'ACTIVE').length;

    const totalProgress = goals.reduce((acc, g) => acc + g.progressPercentage, 0);
    const averageProgressPercentage = totalGoals > 0 ? Math.round(totalProgress / totalGoals) : 0;

    const categoryBreakdown: Record<string, { count: number; totalProgress: number; averageProgress: number }> = {};
    const nextMilestones: Array<{
      goalId: string;
      goalTitle: string;
      milestoneId: string;
      milestoneTitle: string;
    }> = [];

    for (const goal of goals) {
      if (!categoryBreakdown[goal.category]) {
        categoryBreakdown[goal.category] = { count: 0, totalProgress: 0, averageProgress: 0 };
      }
      categoryBreakdown[goal.category].count += 1;
      categoryBreakdown[goal.category].totalProgress += goal.progressPercentage;

      // Find first uncompleted milestone
      const pendingMilestone = goal.milestones.find((m) => !m.completed);
      if (pendingMilestone && nextMilestones.length < 5) {
        nextMilestones.push({
          goalId: goal.id,
          goalTitle: goal.title,
          milestoneId: pendingMilestone.id,
          milestoneTitle: pendingMilestone.title,
        });
      }
    }

    const formattedCategoryBreakdown: Record<string, { count: number; averageProgress: number }> = {};
    for (const [key, data] of Object.entries(categoryBreakdown)) {
      formattedCategoryBreakdown[key] = {
        count: data.count,
        averageProgress: Math.round(data.totalProgress / data.count),
      };
    }

    return {
      totalGoals,
      activeGoals,
      completedGoals,
      averageProgressPercentage,
      categoryBreakdown: formattedCategoryBreakdown,
      nextMilestones,
    };
  }
}
