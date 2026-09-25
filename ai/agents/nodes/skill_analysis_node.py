from state.career_state import CareerState

async def skill_analysis_node(state: CareerState) -> CareerState:
    """Skill Analysis Node: Compares current candidate skills against target role benchmarks"""
    target_role = state.get("target_role", "AI/ML Engineer")
    skills = [s.lower() for s in state.get("skills", [])]

    # Benchmark requirements for AI/ML Engineer
    role_benchmarks = {
        "ai/ml engineer": ["python", "langgraph", "fastapi", "docker", "vector databases", "rag", "pytorch"],
        "full stack developer": ["typescript", "flutter", "node.js", "postgresql", "docker", "react"],
    }

    benchmark = role_benchmarks.get(target_role.lower(), ["python", "docker", "langgraph"])

    gaps = []
    for req in benchmark:
        if not any(req in s for s in skills):
            gaps.append({
                "skill": req.title(),
                "priority": "HIGH" if req in ["langgraph", "vector databases"] else "MEDIUM",
                "estimatedWeeks": 2 if req == "langgraph" else 1,
            })

    state["skill_gaps"] = gaps
    return state
