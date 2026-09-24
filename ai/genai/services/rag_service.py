from .mock_services import MockRAGService, MockVectorStore, MockLLMService

default_vector_store = MockVectorStore()
default_llm_service = MockLLMService()
default_rag_service = MockRAGService(default_vector_store, default_llm_service)
