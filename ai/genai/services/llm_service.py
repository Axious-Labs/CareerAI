from .mock_services import MockLLMService

# Future: Replace with Google Gemini API Client:
# import google.generativeai as genai
# class GeminiLLMService(LLMService): ...

default_llm_service = MockLLMService()
