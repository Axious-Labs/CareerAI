from pydantic import BaseModel, Field
from typing import Optional, Dict, Any, List

class RAGQueryRequest(BaseModel):
    query: str = Field(..., description="User question or career query")
    context: Optional[Dict[str, Any]] = Field(default_factory=dict, description="User context (profile, target role)")

class RAGQueryResponse(BaseModel):
    query: str
    answer: str
    sources: List[str]
    confidenceScore: float
