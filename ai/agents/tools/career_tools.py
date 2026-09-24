from typing import List, Dict, Any

class CareerTool:
    """Base Tool definition for Agent Tool-Calling"""
    name: str
    description: str

    async def run(self, *args, **kwargs) -> Any:
        raise NotImplementedError

class JobSearchTool(CareerTool):
    name = "job_search_tool"
    description = "Searches for matching job postings based on skills and role"

    async def run(self, role: str, skills: List[str]) -> List[Dict[str, Any]]:
        return [
            {
                "title": f"Junior {role}",
                "company": "Axious Labs",
                "matched_skills": [s for s in skills if s.lower() in ["python", "flutter", "fastapi"]],
            }
        ]

class SkillBenchmarkTool(CareerTool):
    name = "skill_benchmark_tool"
    description = "Retrieves industry benchmarks for target tech roles"

    async def run(self, role: str) -> List[str]:
        if "ai" in role.lower() or "ml" in role.lower():
            return ["Python", "LangGraph", "FastAPI", "Docker", "Vector Databases"]
        return ["TypeScript", "Flutter", "Node.js", "PostgreSQL"]

class ToolRegistry:
    def __init__(self):
        self._tools: Dict[str, CareerTool] = {
            "job_search": JobSearchTool(),
            "skill_benchmark": SkillBenchmarkTool(),
        }

    def get_tool(self, name: str) -> CareerTool:
        return self._tools.get(name)

tool_registry = ToolRegistry()
