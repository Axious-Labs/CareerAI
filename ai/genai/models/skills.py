from pydantic import BaseModel, Field
from typing import List, Dict

class SkillExtractRequest(BaseModel):
    text: str = Field(..., description="Raw text snippet or resume section")

class SkillExtractResponse(BaseModel):
    skills: List[str]
    categories: Dict[str, List[str]]

class SkillGapItem(BaseModel):
    name: str
    importance: str
    estimatedTimeToLearn: str

class SkillGapRequest(BaseModel):
    currentSkills: List[str]
    targetRole: str

class SkillGapResponse(BaseModel):
    targetRole: str
    missingSkills: List[SkillGapItem]
    strongSkills: List[str]
    readinessScore: int
