from typing import Dict, Any, List

class MCPToolDefinition:
    """Model Context Protocol Tool Schema"""
    def __init__(self, name: str, description: str, input_schema: Dict[str, Any]):
        self.name = name
        self.description = description
        self.input_schema = input_schema

    def to_dict(self) -> Dict[str, Any]:
        return {
            "name": self.name,
            "description": self.description,
            "inputSchema": self.input_schema,
        }

class MCPAdapter:
    """
    Model Context Protocol (MCP) Adapter for CareerAI.
    Allows LangGraph agents to discover and invoke tools adhering to MCP standards.
    """

    def __init__(self):
        self.registered_tools: List[MCPToolDefinition] = [
            MCPToolDefinition(
                name="career_search",
                description="Search career knowledge base and job openings",
                input_schema={
                    "type": "object",
                    "properties": {
                        "query": {"type": "string"},
                        "role": {"type": "string"},
                    },
                    "required": ["query"],
                },
            ),
            MCPToolDefinition(
                name="skill_gap_evaluator",
                description="Evaluate candidate skill gap against live industry datasets",
                input_schema={
                    "type": "object",
                    "properties": {
                        "skills": {"type": "array", "items": {"type": "string"}},
                        "target_role": {"type": "string"},
                    },
                    "required": ["skills", "target_role"],
                },
            ),
        ]

    def list_tools(self) -> List[Dict[str, Any]]:
        return [tool.to_dict() for tool in self.registered_tools]

mcp_adapter = MCPAdapter()
