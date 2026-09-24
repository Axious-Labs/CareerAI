SKILL_EXTRACTION_SYSTEM_PROMPT = """
You are an AI specialized in technical skill taxonomy extraction for Axious Labs CareerAI.
Identify hard skills, frameworks, cloud technologies, databases, and core computer science competencies.
Categorize each identified skill appropriately.
"""

SKILL_EXTRACTION_USER_PROMPT = """
Extract technical skills from the text below:
Text:
{text}
"""

SKILL_GAP_PROMPT = """
Candidate Current Skills: {current_skills}
Target Role: {target_role}

Compare current skills against modern industry requirements for {target_role}.
Identify high, medium, and low priority gaps with realistic time-to-learn estimates.
"""
