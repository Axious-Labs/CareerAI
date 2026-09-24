import axios from 'axios';
import { env } from '../../config/env';
import { logger } from '../../utils/logger';

export interface Milestone {
  week: number;
  title: string;
  tasks: string[];
}

export interface RoadmapResult {
  roadmapTitle: string;
  milestones: Milestone[];
}

export interface AgentWorkflowResult {
  workflowId: string;
  state: any;
  recommendations: string[];
}

export class AgentClient {
  private baseUrl: string;

  constructor() {
    this.baseUrl = env.AGENT_SERVICE_URL;
  }

  async generateCareerPlan(userId: string, targetRole: string, skills: string[]): Promise<any> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/agents/career-plan`,
        { user_id: userId, target_role: targetRole, skills },
        { timeout: 6000 }
      );
      return response.data;
    } catch (error) {
      logger.warn(`Agent Service unavailable at ${this.baseUrl}. Using fallback mock career plan.`);
      return {
        user_id: userId,
        target_role: targetRole,
        career_readiness: 68,
        today_plan: [
          { id: 'p1', title: 'Complete Transformers lesson', completed: true },
          { id: 'p2', title: 'Solve 2 DSA problems', completed: true },
          { id: 'p3', title: 'Apply to 3 relevant jobs', completed: false },
        ],
        next_milestone: 'Master LangGraph StateGraph Architecture',
      };
    }
  }

  async createLearningRoadmap(
    userId: string,
    targetRole: string,
    timelineWeeks = 8
  ): Promise<RoadmapResult> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/agents/learning-roadmap`,
        { user_id: userId, target_role: targetRole, timeline_weeks: timelineWeeks },
        { timeout: 6000 }
      );
      return response.data;
    } catch (error) {
      logger.warn('Agent Service roadmap fallback.');
      return {
        roadmapTitle: `${targetRole} ${timelineWeeks}-Week Accelerated Roadmap`,
        milestones: [
          {
            week: 1,
            title: 'LLM Architectures & Prompt Engineering',
            tasks: ['Complete Transformers lesson', 'Build few-shot prompt evaluator'],
          },
          {
            week: 2,
            title: 'RAG Architectures & Vector Stores',
            tasks: ['Implement FAISS retrieval', 'Index PDF knowledge base'],
          },
          {
            week: 3,
            title: 'Agentic Workflows with LangGraph',
            tasks: ['Implement StateGraph', 'Build multi-tool career advisor agent'],
          },
          {
            week: 4,
            title: 'Production Deployment & Evaluation',
            tasks: ['Containerize with Docker', 'Deploy FastAPI service with health checks'],
          },
        ],
      };
    }
  }

  async executeCareerWorkflow(initialState: any): Promise<AgentWorkflowResult> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/agents/workflow/execute`,
        { state: initialState },
        { timeout: 8000 }
      );
      return response.data;
    } catch (error) {
      logger.warn('Agent Service workflow execution fallback.');
      return {
        workflowId: `wf_${Date.now()}`,
        state: initialState,
        recommendations: [
          'Prioritize real-world open-source contributions.',
          'Schedule mock technical interviews focusing on system design.',
        ],
      };
    }
  }
}
