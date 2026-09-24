from ..services.mock_services import MockEmbeddingService

# Future: Integrate SentenceTransformers / text-embedding-004 from Google
default_embedding_service = MockEmbeddingService()
