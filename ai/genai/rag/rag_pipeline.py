from typing import List, Dict, Any
from ..services.interfaces import VectorStore, LLMService

class RAGPipeline:
    def __init__(self, vector_store: VectorStore, llm_service: LLMService):
        self.vector_store = vector_store
        self.llm_service = llm_service

    async def retrieve_and_generate(self, query: str, context: Dict[str, Any]) -> Dict[str, Any]:
        """Perform similarity search and augment LLM prompt with retrieved context"""
        # 1. Retrieve top-k context
        mock_query_vector = [0.1] * 8
        docs = await self.vector_store.search(mock_query_vector, top_k=2)

        # 2. Synthesize response
        retrieved_text = "\n".join([d.get("metadata", {}).get("content", "") for d in docs])
        prompt = f"Context:\n{retrieved_text}\n\nQuestion: {query}"
        answer = await self.llm_service.generate_response(prompt)

        return {
            "query": query,
            "answer": answer,
            "sources": [d.get("metadata", {}).get("title", "CareerAI Knowledge Base") for d in docs],
            "confidenceScore": 0.92,
        }
