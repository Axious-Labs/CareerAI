from pydantic import BaseModel, Field
from typing import List, Optional

class ResumeAnalyzeRequest(BaseModel):
    fileName: str = Field(..., description="Uploaded resume file name")
    fileUrl: str = Field(..., description="Access URL or path for resume document")
    targetRole: Optional[str] = Field(None, description="Optional target role for tailored extraction")

class ResumeAnalyzeResponse(BaseModel):
    fileName: str
    extractedSkills: List[str]
    experienceYears: float
    education: List[str]
    summary: str
    strengths: List[str]
    areasForGrowth: List[str]
