import axios from 'axios';
import { env } from '../../config/env';
import { logger } from '../../utils/logger';

export interface ResumeAnalysisResult {
  extractedSkills: string[];
  experienceYears: number;
  education: string[];
  summary: string;
}

export interface SkillGapResult {
  targetRole: string;
  missingSkills: Array<{ name: string; importance: string; estimatedTimeToLearn: string }>;
  strongSkills: string[];
  readinessScore: number;
}

export interface JobMatchResult {
  matchScore: number;
  matchedSkills: string[];
  missingSkills: string[];
  recommendation: string;
}

export class GenAIClient {
  private baseUrl: string;

  constructor() {
    this.baseUrl = env.AI_SERVICE_URL;
  }

  async analyzeResume(fileName: string, fileUrl: string): Promise<ResumeAnalysisResult> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/ai/resume/analyze`,
        { fileName, fileUrl },
        { timeout: 5000 }
      );
      return response.data;
    } catch (error: any) {
      logger.warn(`GenAI Service unavailable at ${this.baseUrl}. Using fallback mock analysis.`);
      return {
        extractedSkills: ['Python', 'Flutter', 'FastAPI', 'Docker', 'Machine Learning', 'Git'],
        experienceYears: 2,
        education: ['B.S. in Computer Science (In Progress)'],
        summary: 'Early-career developer passionate about AI systems and cross-platform mobile engineering.',
      };
    }
  }

  async extractSkills(text: string): Promise<string[]> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/ai/skills/extract`,
        { text },
        { timeout: 5000 }
      );
      return response.data.skills;
    } catch (error) {
      logger.warn('GenAI Service skills extraction fallback.');
      return ['Python', 'SQL', 'Data Structures', 'REST APIs'];
    }
  }

  async analyzeSkillGap(currentSkills: string[], targetRole: string): Promise<SkillGapResult> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/ai/skills/gap`,
        { currentSkills, targetRole },
        { timeout: 5000 }
      );
      return response.data;
    } catch (error) {
      logger.warn('GenAI Service skill gap fallback.');
      return {
        targetRole,
        missingSkills: [
          { name: 'LangGraph', importance: 'HIGH', estimatedTimeToLearn: '2 weeks' },
          { name: 'Vector Databases', importance: 'HIGH', estimatedTimeToLearn: '1 week' },
          { name: 'Kubernetes / MLOps', importance: 'MEDIUM', estimatedTimeToLearn: '3 weeks' },
        ],
        strongSkills: currentSkills.length > 0 ? currentSkills : ['Python', 'Git', 'Problem Solving'],
        readinessScore: 68,
      };
    }
  }

  async matchJob(candidateSkills: string[], jobDescription: string): Promise<JobMatchResult> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/ai/jobs/match`,
        { candidateSkills, jobDescription },
        { timeout: 5000 }
      );
      return response.data;
    } catch (error) {
      logger.warn('GenAI Service job match fallback.');
      return {
        matchScore: 84,
        matchedSkills: ['Python', 'FastAPI', 'Docker'],
        missingSkills: ['Kubernetes', 'PyTorch'],
        recommendation: 'Strong candidate profile. Review vector store fundamentals prior to interview.',
      };
    }
  }

  async generateCareerAdvice(query: string, userContext: any): Promise<string> {
    try {
      const response = await axios.post(
        `${this.baseUrl}/ai/rag/query`,
        { query, context: userContext },
        { timeout: 5000 }
      );
      return response.data.answer;
    } catch (error) {
      logger.warn('GenAI Service RAG query fallback.');
      return `Based on your target role (${userContext?.targetRole || 'AI/ML Engineer'}) and current progress, focus on completing real-world projects that demonstrate LangGraph multi-agent workflows and vector retrieval pipelines.`;
    }
  }
}
