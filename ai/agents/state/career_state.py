from typing import TypedDict

class CareerState(TypedDict):
    user_id: str
    target_role: str
    skills: list
    resume_data: dict
    job_data: list
    skill_gaps: list
    recommendations: list
