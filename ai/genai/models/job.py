from pydantic import BaseModel, Field
from typing import List

class JobMatchRequest(BaseModel):
    candidateSkills: List[str] = Field(..., description="List of skills from candidate profile/resume")
    jobDescription: str = Field(..., description="Job description text")

class JobMatchResponse(BaseModel):
    matchScore: int
    matchedSkills: List[str]
    missingSkills: List[str]
    recommendation: str
