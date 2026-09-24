from .mock_services import MockJobMatchingService

# Future: Integrate semantic similarity scoring using HuggingFace sentence-transformers
default_job_matching_service = MockJobMatchingService()
