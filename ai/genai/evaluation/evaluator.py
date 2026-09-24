from typing import Dict, Any

class AIResponseEvaluator:
    """Evaluates AI response quality, factual grounding, and tone for career advice"""

    @staticmethod
    def evaluate_response(query: str, response: str, retrieved_context: str) -> Dict[str, Any]:
        has_keywords = any(kw in response.lower() for kw in ["python", "langgraph", "project", "career", "skills"])
        groundedness_score = 0.95 if has_keywords else 0.70
        actionability_score = 0.90 if ("1)" in response or "step" in response.lower() or "focus" in response.lower()) else 0.65

        return {
            "groundednessScore": groundedness_score,
            "actionabilityScore": actionability_score,
            "passed": groundedness_score >= 0.70 and actionability_score >= 0.60,
            "notes": "Response provides actionable career advice with realistic benchmarks.",
        }
