from .mock_services import MockSkillExtractionService

# Future: Integrate spaCy / fine-tuned NER models + Gemini extraction
default_skill_extraction_service = MockSkillExtractionService()
