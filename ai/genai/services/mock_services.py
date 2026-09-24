import math
from typing import List, Dict, Any
from .interfaces import (
    LLMService,
    ResumeParser,
    EmbeddingService,
    VectorStore,
    RAGService,
    SkillExtractionService,
    JobMatchingService,
)

class MockLLMService(LLMService):
    async def generate_response(self, prompt: str, system_prompt: str = "") -> str:
        return (
            "CareerAI Intelligence: Focus on mastering core data structures, "
            "modern ML pipelines, and agentic workflows using LangGraph to accelerate your career readiness."
        )

class MockResumeParser(ResumeParser):
    async def parse_resume(self, file_name: str, file_url: str) -> Dict[str, Any]:
        return {
            "fileName": file_name,
            "extractedSkills": [
                "Python",
                "Flutter",
                "FastAPI",
                "Docker",
                "PostgreSQL",
                "Git",
                "Machine Learning",
                "Problem Solving",
            ],
            "experienceYears": 1.5,
            "education": ["B.S. in Computer Science, Axious University (Expected 2026)"],
            "summary": (
                "Passionate student developer with demonstrated projects in mobile app development "
                "and backend REST APIs. Actively learning generative AI and agentic systems."
            ),
            "strengths": [
                "Strong foundation in cross-platform UI with Flutter",
                "Proficient in Python scripting and REST API design",
            ],
            "areasForGrowth": [
                "Hands-on experience with vector databases and RAG",
                "Production deployment and MLOps tooling",
            ],
        }

class MockEmbeddingService(EmbeddingService):
    async def get_embedding(self, text: str) -> List[float]:
        # Generate a deterministic 8-dimensional mock vector based on text hash
        seed = sum(ord(c) for c in text)
        return [math.sin(seed + i) for i in range(8)]

    async def get_embeddings(self, texts: List[str]) -> List[List[float]]:
        return [await self.get_embedding(t) for t in texts]

class MockVectorStore(VectorStore):
    def __init__(self):
        self.vectors: List[Dict[str, Any]] = []

    async def store(self, vector: List[float], metadata: Dict[str, Any]) -> str:
        doc_id = f"doc_{len(self.vectors) + 1}"
        self.vectors.append({"id": doc_id, "vector": vector, "metadata": metadata})
        return doc_id

    async def search(self, query_vector: List[float], top_k: int = 5) -> List[Dict[str, Any]]:
        # Return mock matching documents
        return [
            {
                "id": "doc_01",
                "score": 0.92,
                "metadata": {
                    "title": "Machine Learning Engineer Career Path Guide",
                    "content": "Core competencies include Python, PyTorch, LangGraph, and Vector DBs.",
                },
            },
            {
                "id": "doc_02",
                "score": 0.85,
                "metadata": {
                    "title": "Axious Labs AI Apprenticeship Expectations",
                    "content": "Focus on high-quality code, unit testing, and modular architecture.",
                },
            },
        ][:top_k]

class MockRAGService(RAGService):
    def __init__(self, vector_store: VectorStore, llm_service: LLMService):
        self.vector_store = vector_store
        self.llm_service = llm_service

    async def query(self, question: str, context: Dict[str, Any]) -> Dict[str, Any]:
        target_role = context.get("targetRole", "AI/ML Engineer")
        user_name = context.get("userName", "Developer")

        answer = (
            f"Hello {user_name}! To excel as an {target_role}, we recommend: "
            f"1) Strengthen your Python foundation with asynchronous concurrency. "
            f"2) Master Retrieval-Augmented Generation (RAG) by integrating FAISS or pgvector. "
            f"3) Build hands-on projects utilizing LangGraph for autonomous task planning."
        )
        return {
            "query": question,
            "answer": answer,
            "sources": [
                "Axious Labs Career Curriculum 2026",
                "Industry Skill Benchmark Database",
            ],
            "confidenceScore": 0.94,
        }

class MockSkillExtractionService(SkillExtractionService):
    async def extract_skills(self, text: str) -> Dict[str, Any]:
        return {
            "skills": ["Python", "FastAPI", "Docker", "PostgreSQL", "Flutter"],
            "categories": {
                "Programming Languages": ["Python", "Dart"],
                "Frameworks": ["FastAPI", "Flutter"],
                "DevOps & Databases": ["Docker", "PostgreSQL"],
            },
        }

    async def analyze_gap(self, current_skills: List[str], target_role: str) -> Dict[str, Any]:
        missing = [
            {"name": "LangGraph", "importance": "HIGH", "estimatedTimeToLearn": "2 weeks"},
            {"name": "Vector Databases", "importance": "HIGH", "estimatedTimeToLearn": "1 week"},
            {"name": "Kubernetes / MLOps", "importance": "MEDIUM", "estimatedTimeToLearn": "3 weeks"},
        ]
        return {
            "targetRole": target_role,
            "missingSkills": missing,
            "strongSkills": current_skills if current_skills else ["Python", "Git"],
            "readinessScore": 68,
        }

class MockJobMatchingService(JobMatchingService):
    async def match_job(self, candidate_skills: List[str], job_description: str) -> Dict[str, Any]:
        return {
            "matchScore": 84,
            "matchedSkills": ["Python", "FastAPI", "Docker"],
            "missingSkills": ["LangGraph", "Kubernetes"],
            "recommendation": (
                "Strong candidate alignment! High proficiency in core Python backend skills. "
                "Highlight your recent GenAI projects to boost match confidence."
            ),
        }
