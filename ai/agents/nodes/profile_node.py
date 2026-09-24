from ..state.career_state import CareerState

async def profile_node(state: CareerState) -> CareerState:
    """Profile Node: Validates user identity, target role, and normalizes candidate data"""
    target_role = state.get("target_role") or "AI/ML Engineer"
    skills = state.get("skills") or ["Python", "Git", "Problem Solving"]
    resume_data = state.get("resume_data") or {}

    # Normalize skills from resume if present
    if "extractedSkills" in resume_data:
        for skill in resume_data["extractedSkills"]:
            if skill not in skills:
                skills.append(skill)

    state["target_role"] = target_role
    state["skills"] = skills
    return state
