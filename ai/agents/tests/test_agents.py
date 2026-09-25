import pytest
from state.career_state import CareerState
from graph.career_graph import career_graph_workflow
from agents.career_agent import CareerAgent
from agents.skill_gap_agent import SkillGapAgent
from agents.learning_planner_agent import LearningPlannerAgent
from mcp.mcp_adapter import mcp_adapter

@pytest.mark.asyncio
async def test_career_graph_workflow():
    initial_state: CareerState = {
        "user_id": "usr_test_student",
        "target_role": "AI/ML Engineer",
        "skills": ["Python", "Flutter"],
        "resume_data": {},
        "job_data": [],
        "skill_gaps": [],
        "recommendations": [],
    }

    final_state = await career_graph_workflow.execute(initial_state)

    assert final_state["user_id"] == "usr_test_student"
    assert final_state["target_role"] == "AI/ML Engineer"
    assert len(final_state["skill_gaps"]) > 0
    assert len(final_state["recommendations"]) > 0

@pytest.mark.asyncio
async def test_career_agent():
    agent = CareerAgent()
    state = await agent.plan_career("usr_123", "AI/ML Engineer", ["Python", "FastAPI"])
    assert state["target_role"] == "AI/ML Engineer"
    assert any("LangGraph" in gap["skill"] for gap in state["skill_gaps"])

@pytest.mark.asyncio
async def test_skill_gap_and_roadmap_agents():
    gap_agent = SkillGapAgent()
    gap_result = await gap_agent.analyze_gap(["Python"], "AI/ML Engineer")
    assert gap_result["readinessScore"] == 68
    assert len(gap_result["missingSkills"]) > 0

    planner_agent = LearningPlannerAgent()
    roadmap_result = await planner_agent.create_roadmap("AI/ML Engineer", 8)
    assert len(roadmap_result["milestones"]) >= 4

def test_mcp_tools():
    tools = mcp_adapter.list_tools()
    assert len(tools) >= 2
    tool_names = [t["name"] for t in tools]
    assert "career_search" in tool_names
    assert "skill_gap_evaluator" in tool_names
