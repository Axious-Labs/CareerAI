from abc import ABC, abstractmethod
from typing import List, Dict, Any

class LLMService(ABC):
    @abstractmethod
    async def generate_response(self, prompt: str, system_prompt: str = "") -> str:
        """Generate text completion from LLM provider (e.g. Gemini, OpenAI)"""
        pass

class ResumeParser(ABC):
    @abstractmethod
    async def parse_resume(self, file_name: str, file_url: str) -> Dict[str, Any]:
        """Extract structured resume intelligence from PDF/DOCX document"""
        pass

class EmbeddingService(ABC):
    @abstractmethod
    async def get_embedding(self, text: str) -> List[float]:
        """Generate vector embedding for input text"""
        pass

    @abstractmethod
    async def get_embeddings(self, texts: List[str]) -> List[List[float]]:
        """Generate batch vector embeddings"""
        pass

class VectorStore(ABC):
    @abstractmethod
    async def store(self, vector: List[float], metadata: Dict[str, Any]) -> str:
        """Store embedding vector with associated metadata"""
        pass

    @abstractmethod
    async def search(self, query_vector: List[float], top_k: int = 5) -> List[Dict[str, Any]]:
        """Perform similarity search and return top matching documents"""
        pass

class RAGService(ABC):
    @abstractmethod
    async def query(self, question: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """Execute RAG retrieval and generate grounded response"""
        pass

class SkillExtractionService(ABC):
    @abstractmethod
    async def extract_skills(self, text: str) -> Dict[str, Any]:
        """Extract technical skills and categories from raw text"""
        pass

    @abstractmethod
    async def analyze_gap(self, current_skills: List[str], target_role: str) -> Dict[str, Any]:
        """Benchmark candidate skills against target role requirements"""
        pass

class JobMatchingService(ABC):
    @abstractmethod
    async def match_job(self, candidate_skills: List[str], job_description: str) -> Dict[str, Any]:
        """Compute match score and identify skill alignment for job opening"""
        pass
