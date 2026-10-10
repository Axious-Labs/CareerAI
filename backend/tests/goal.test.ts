import { GoalService } from '../src/services/goal.service';
import { GoalRepository } from '../src/repositories/goal.repository';
import { NotFoundError, UnauthorizedError } from '../src/utils/errors';

describe('Career Goals & Milestone Tracking Service Tests', () => {
  let goalRepo: GoalRepository;
  let goalService: GoalService;

  beforeEach(() => {
    goalRepo = new GoalRepository();
    goalService = new GoalService(goalRepo);
  });

  it('should retrieve default career goals for a user', async () => {
    const goals = await goalService.getUserGoals('usr_test_goals');
    expect(goals.length).toBeGreaterThanOrEqual(4);
    expect(goals[0].title).toBeDefined();
    expect(goals[0].milestones.length).toBeGreaterThan(0);
  });

  it('should filter goals by category', async () => {
    const skillGoals = await goalService.getUserGoals('usr_test_goals', 'SKILL_ACQUISITION');
    expect(skillGoals.length).toBeGreaterThan(0);
    expect(skillGoals.every((g) => g.category === 'SKILL_ACQUISITION')).toBe(true);
  });

  it('should create a new career goal with structured milestone items', async () => {
    const input = {
      title: 'Achieve AWS Solutions Architect Certification',
      description: 'Study cloud architecture, IAM policies, and VPC peering design.',
      category: 'SKILL_ACQUISITION' as const,
      targetDate: '2026-12-01',
      milestones: [
        { title: 'Read Official Study Guide Chapters 1-5' },
        { title: 'Build multi-region high availability VPC lab' },
        { title: 'Score 85%+ on timed practice exam' },
      ],
    };

    const goal = await goalService.createGoal('usr_test_goals', input);
    expect(goal.id).toBeDefined();
    expect(goal.title).toBe(input.title);
    expect(goal.progressPercentage).toBe(0);
    expect(goal.milestones.length).toBe(3);
    expect(goal.milestones[0].completed).toBe(false);
  });

  it('should update progress percentage and mark status as COMPLETED when 100%', async () => {
    const goals = await goalService.getUserGoals('usr_test_goals');
    const targetGoal = goals[0];

    const updated = await goalService.updateProgress(targetGoal.userId, targetGoal.id, 100);
    expect(updated.progressPercentage).toBe(100);
    expect(updated.status).toBe('COMPLETED');
  });

  it('should toggle milestone completion and auto-recalculate progress percentage', async () => {
    const goals = await goalService.getUserGoals('usr_test_goals');
    const targetGoal = goals[0];
    const targetMilestone = targetGoal.milestones[targetGoal.milestones.length - 1];
    const initialCompleted = targetMilestone.completed;

    const updated = await goalService.toggleMilestone(
      targetGoal.userId,
      targetGoal.id,
      targetMilestone.id
    );

    const toggled = updated.milestones.find((m) => m.id === targetMilestone.id);
    expect(toggled?.completed).toBe(!initialCompleted);
    expect(updated.progressPercentage).toBeGreaterThanOrEqual(0);
  });

  it('should add a new milestone to an existing goal', async () => {
    const goals = await goalService.getUserGoals('usr_test_goals');
    const targetGoal = goals[0];
    const previousCount = targetGoal.milestones.length;

    const updated = await goalService.addMilestone(
      targetGoal.userId,
      targetGoal.id,
      'Conduct final code review with Axious Labs team'
    );

    expect(updated.milestones.length).toBe(previousCount + 1);
    expect(updated.milestones[updated.milestones.length - 1].title).toBe(
      'Conduct final code review with Axious Labs team'
    );
  });

  it('should compute comprehensive goals summary analytics', async () => {
    const summary = await goalService.getGoalsSummary('usr_test_goals');

    expect(summary.totalGoals).toBeGreaterThan(0);
    expect(summary.activeGoals).toBeGreaterThanOrEqual(0);
    expect(summary.averageProgressPercentage).toBeGreaterThanOrEqual(0);
    expect(summary.categoryBreakdown).toHaveProperty('SKILL_ACQUISITION');
    expect(summary.nextMilestones.length).toBeGreaterThan(0);
  });

  it('should delete a career goal', async () => {
    const input = {
      title: 'Temporary Goal to be Deleted',
      description: 'Will be removed in test',
      category: 'PORTFOLIO_PROJECT' as const,
    };
    const created = await goalService.createGoal('usr_temp_delete', input);

    const deleteResult = await goalService.deleteGoal('usr_temp_delete', created.id);
    expect(deleteResult.id).toBe(created.id);

    await expect(goalService.getGoalById('usr_temp_delete', created.id)).rejects.toThrow(
      NotFoundError
    );
  });
});
