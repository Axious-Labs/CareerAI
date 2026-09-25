from typing import Dict, Any, List
from agents.career_agent import CareerAgent
from agents.skill_gap_agent import SkillGapAgent
from agents.learning_planner_agent import LearningPlannerAgent

class AgentService:
    def __init__(self):
        self.career_agent = CareerAgent()
        self.skill_gap_agent = SkillGapAgent()
        self.learning_planner_agent = LearningPlannerAgent()

    async def generate_career_plan(self, user_id: str, target_role: str, skills: List[str]) -> Dict[str, Any]:
        state = await self.career_agent.plan_career(user_id, target_role, skills)
        return {
            "user_id": state["user_id"],
            "target_role": state["target_role"],
            "career_readiness": 68,
            "skills": state["skills"],
            "skill_gaps": state["skill_gaps"],
            "recommendations": state["recommendations"],
            "today_plan": [
                {"id": "p1", "title": "Complete Transformers lesson", "completed": True},
                {"id": "p2", "title": "Solve 2 DSA problems", "completed": True},
                {"id": "p3", "title": "Apply to 3 relevant jobs", "completed": False},
            ],
        }

    async def analyze_skill_gap(self, skills: List[str], target_role: str) -> Dict[str, Any]:
        return await self.skill_gap_agent.analyze_gap(skills, target_role)

    async def create_learning_roadmap(self, target_role: str, timeline_weeks: int = 8) -> Dict[str, Any]:
        return await self.learning_planner_agent.create_roadmap(target_role, timeline_weeks)

agent_service = AgentService()
