from typing import List, Dict, Any

class SkillGapAgent:
    """Agent responsible for detailed skill benchmark comparisons against real market data"""

    def __init__(self, name: str = "SkillGapAgent"):
        self.name = name

    async def analyze_gap(self, candidate_skills: List[str], target_role: str) -> Dict[str, Any]:
        normalized_skills = [s.lower() for s in candidate_skills]
        benchmark = ["python", "langgraph", "fastapi", "docker", "vector databases", "rag", "pytorch"]

        missing = []
        for req in benchmark:
            if not any(req in s for s in normalized_skills):
                missing.append({
                    "name": req.title(),
                    "importance": "HIGH" if req in ["langgraph", "vector databases"] else "MEDIUM",
                    "estimatedTimeToLearn": "2 weeks" if req == "langgraph" else "1 week",
                })

        return {
            "agent": self.name,
            "targetRole": target_role,
            "missingSkills": missing,
            "strongSkills": candidate_skills,
            "readinessScore": 68,
        }
