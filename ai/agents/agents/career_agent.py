from typing import List
from state.career_state import CareerState
from graph.career_graph import career_graph_workflow

class CareerAgent:
    """Orchestrates comprehensive career planning workflows for students"""

    def __init__(self, name: str = "CareerAgent"):
        self.name = name

    async def plan_career(self, user_id: str, target_role: str, skills: List[str]) -> CareerState:
        initial_state: CareerState = {
            "user_id": user_id,
            "target_role": target_role,
            "skills": skills,
            "resume_data": {},
            "job_data": [],
            "skill_gaps": [],
            "recommendations": [],
        }

        # Run through LangGraph workflow
        final_state = await career_graph_workflow.execute(initial_state)
        return final_state
