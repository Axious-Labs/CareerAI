from typing import List, Dict, Any

class JobAgent:
    """Agent responsible for intelligent job discovery and candidate profile matching"""

    def __init__(self, name: str = "JobAgent"):
        self.name = name

    async def find_matching_jobs(self, skills: List[str], target_role: str) -> List[Dict[str, Any]]:
        return [
            {
                "id": "job_01",
                "title": "Junior AI Engineer",
                "company": "Axious Labs",
                "location": "Remote",
                "matchScore": 88,
                "fitSummary": "Matches your Python and mobile systems experience.",
            },
            {
                "id": "job_02",
                "title": "Associate Machine Learning Engineer",
                "company": "TechFlow Systems",
                "location": "San Francisco, CA",
                "matchScore": 82,
                "fitSummary": "Strong alignment with your data pipeline and API projects.",
            },
        ]
