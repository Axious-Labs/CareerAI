from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .models.resume import ResumeAnalyzeRequest, ResumeAnalyzeResponse
from .models.skills import (
    SkillExtractRequest,
    SkillExtractResponse,
    SkillGapRequest,
    SkillGapResponse,
)
from .models.rag import RAGQueryRequest, RAGQueryResponse
from .models.job import JobMatchRequest, JobMatchResponse
from .services.resume_parser import default_resume_parser
from .services.skill_extraction import default_skill_extraction_service
from .services.rag_service import default_rag_service
from .services.job_matching import default_job_matching_service

app = FastAPI(
    title="CareerAI GenAI Service",
    description="Generative AI, Resume Intelligence & RAG Service developed by Axious Labs.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "CareerAI GenAI Service",
        "version": "1.0.0",
        "organization": "Axious Labs",
    }

@app.post("/ai/resume/analyze", response_model=ResumeAnalyzeResponse)
async def analyze_resume(request: ResumeAnalyzeRequest):
    try:
        data = await default_resume_parser.parse_resume(request.fileName, request.fileUrl)
        return ResumeAnalyzeResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/skills/extract", response_model=SkillExtractResponse)
async def extract_skills(request: SkillExtractRequest):
    try:
        data = await default_skill_extraction_service.extract_skills(request.text)
        return SkillExtractResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/skills/gap", response_model=SkillGapResponse)
async def analyze_skill_gap(request: SkillGapRequest):
    try:
        data = await default_skill_extraction_service.analyze_gap(
            request.currentSkills, request.targetRole
        )
        return SkillGapResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/rag/query", response_model=RAGQueryResponse)
async def rag_query(request: RAGQueryRequest):
    try:
        data = await default_rag_service.query(request.query, request.context or {})
        return RAGQueryResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/ai/jobs/match", response_model=JobMatchResponse)
async def match_job(request: JobMatchRequest):
    try:
        data = await default_job_matching_service.match_job(
            request.candidateSkills, request.jobDescription
        )
        return JobMatchResponse(**data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8001, reload=True)
