from .mock_services import MockResumeParser

# Future: Integrate PyPDF2 / pdfplumber + Gemini Pro vision/text extraction
default_resume_parser = MockResumeParser()
