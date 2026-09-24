from typing import List, Dict, Any

class LearningPlannerAgent:
    """Agent responsible for crafting personalized, week-by-week learning roadmaps"""

    def __init__(self, name: str = "LearningPlannerAgent"):
        self.name = name

    async def create_roadmap(self, target_role: str, timeline_weeks: int = 8) -> Dict[str, Any]:
        return {
            "agent": self.name,
            "roadmapTitle": f"{target_role} {timeline_weeks}-Week Career Roadmap",
            "milestones": [
                {
                    "week": 1,
                    "title": "LLM Fundamentals & Prompt Engineering",
                    "tasks": [
                        "Complete Transformers lesson",
                        "Build few-shot prompt evaluator",
                    ],
                },
                {
                    "week": 2,
                    "title": "RAG Architectures & Vector Databases",
                    "tasks": [
                        "Implement FAISS vector retrieval",
                        "Index PDF knowledge base",
                    ],
                },
                {
                    "week": 3,
                    "title": "Agentic Workflows with LangGraph",
                    "tasks": [
                        "Implement StateGraph",
                        "Build multi-tool career advisor agent",
                    ],
                },
                {
                    "week": 4,
                    "title": "Production Deployment & Monitoring",
                    "tasks": [
                        "Containerize with Docker",
                        "Deploy FastAPI service with health checks",
                    ],
                },
            ],
        }
