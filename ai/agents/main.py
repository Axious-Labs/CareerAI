from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from .services.agent_service import agent_service
from .mcp.mcp_adapter import mcp_adapter

app = FastAPI(
    title="CareerAI Agentic AI Service",
    description="LangGraph, Multi-Agent Workflows & MCP Service developed by Axious Labs.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class CareerPlanRequest(BaseModel):
    user_id: str
    target_role: str = "AI/ML Engineer"
    skills: List[str] = Field(default_factory=list)

class SkillGapRequest(BaseModel):
    skills: List[str]
    target_role: str

class LearningRoadmapRequest(BaseModel):
    user_id: Optional[str] = None
    target_role: str
    timeline_weeks: int = 8

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "CareerAI Agentic AI Service",
        "version": "1.0.0",
        "organization": "Axious Labs",
    }

@app.get("/agents/mcp/tools")
async def list_mcp_tools():
    return {"tools": mcp_adapter.list_tools()}

@app.post("/agents/career-plan")
async def generate_career_plan(request: CareerPlanRequest):
    try:
        return await agent_service.generate_career_plan(
            request.user_id, request.target_role, request.skills
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/agents/skill-gap")
async def analyze_skill_gap(request: SkillGapRequest):
    try:
        return await agent_service.analyze_skill_gap(request.skills, request.target_role)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/agents/learning-roadmap")
async def create_learning_roadmap(request: LearningRoadmapRequest):
    try:
        return await agent_service.create_learning_roadmap(
            request.target_role, request.timeline_weeks
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8002, reload=True)
