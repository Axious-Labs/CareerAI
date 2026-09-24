from ..state.career_state import CareerState

async def recommendation_node(state: CareerState) -> CareerState:
    """Recommendation Node: Generates prioritized action items and career roadmaps based on gaps"""
    gaps = state.get("skill_gaps", [])
    target_role = state.get("target_role", "AI/ML Engineer")

    recommendations = []
    if gaps:
        top_gap = gaps[0]["skill"]
        recommendations.append(
            f"Prioritize building a project with {top_gap} to bridge your primary qualification gap for {target_role}."
        )

    recommendations.extend([
        "Complete the 'Transformers & LangGraph' hands-on tutorial in CareerAI curriculum.",
        "Update your resume with demonstrated open-source contributions.",
        "Apply to at least 3 early-career AI engineer roles this week.",
    ])

    state["recommendations"] = recommendations
    return state
