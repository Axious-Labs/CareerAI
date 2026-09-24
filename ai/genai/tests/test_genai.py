import pytest
from ..services.mock_services import (
    MockResumeParser,
    MockSkillExtractionService,
    MockJobMatchingService,
    MockRAGService,
    MockVectorStore,
    MockLLMService,
)
from ..evaluation.evaluator import AIResponseEvaluator

@pytest.mark.asyncio
async def test_resume_parser():
    parser = MockResumeParser()
    res = await parser.parse_resume("test_resume.pdf", "https://example.com/resume.pdf")

    assert res["fileName"] == "test_resume.pdf"
    assert "Python" in res["extractedSkills"]
    assert res["experienceYears"] > 0
    assert len(res["strengths"]) > 0

@pytest.mark.asyncio
async def test_skill_extraction_and_gap():
    service = MockSkillExtractionService()
    skills_data = await service.extract_skills("Experienced in Python, Docker, and Flutter.")
    assert "Python" in skills_data["skills"]

    gap_data = await service.analyze_gap(["Python"], "AI/ML Engineer")
    assert gap_data["targetRole"] == "AI/ML Engineer"
    assert len(gap_data["missingSkills"]) > 0
    assert gap_data["readinessScore"] > 0

@pytest.mark.asyncio
async def test_job_matching():
    matcher = MockJobMatchingService()
    match_data = await matcher.match_job(["Python", "FastAPI"], "Need Python engineer with FastAPI experience.")
    assert match_data["matchScore"] > 70
    assert "Python" in match_data["matchedSkills"]

@pytest.mark.asyncio
async def test_rag_and_evaluation():
    store = MockVectorStore()
    llm = MockLLMService()
    rag = MockRAGService(store, llm)

    rag_data = await rag.query("How to become an AI Engineer?", {"targetRole": "AI/ML Engineer"})
    assert "AI/ML Engineer" in rag_data["answer"]

    eval_result = AIResponseEvaluator.evaluate_response(
        "How to become an AI Engineer?",
        rag_data["answer"],
        "retrieved context"
    )
    assert eval_result["passed"] is True
