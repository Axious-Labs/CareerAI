from typing import Callable, Dict, Any, List
from ..state.career_state import CareerState
from ..nodes.profile_node import profile_node
from ..nodes.skill_analysis_node import skill_analysis_node
from ..nodes.recommendation_node import recommendation_node

class CareerGraph:
    """
    LangGraph Workflow Skeleton for CareerAI.
    Executes: START -> Profile Node -> Skill Analysis Node -> Recommendation Node -> END
    """

    def __init__(self):
        self.nodes: Dict[str, Callable[[CareerState], Any]] = {
            "profile": profile_node,
            "skill_analysis": skill_analysis_node,
            "recommendation": recommendation_node,
        }
        self.execution_order: List[str] = ["profile", "skill_analysis", "recommendation"]

    async def execute(self, initial_state: CareerState) -> CareerState:
        """Executes the state transitions across all registered nodes"""
        current_state = initial_state

        for node_name in self.execution_order:
            node_func = self.nodes[node_name]
            current_state = await node_func(current_state)

        return current_state

# Singleton instance for graph execution
career_graph_workflow = CareerGraph()
