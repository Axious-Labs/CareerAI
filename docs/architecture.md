# CareerAI — System Architecture

> **Axious Labs** | Student-Led Technology Venture  
> **Project Lead:** Ravi Prakash  
> **Target:** Early-Career Developers & Students

---

## 1. Executive Architecture Overview

**CareerAI** is structured as a modern, decoupled microservices ecosystem. It isolates client interaction, transactional data processing, generative AI intelligence, and agentic workflows into dedicated layers with typed contracts and clean boundaries.

```
┌─────────────────────────────────────────────────────────────┐
│                 Flutter Mobile Application                  │
│                (iOS / Android / Web Target)                 │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTPS / REST / SSE
                               ▼
┌─────────────────────────────────────────────────────────────┐
│            Node.js API Gateway (Express + TypeScript)       │
│  - Authentication (JWT) & Authorization                     │
│  - Request Validation (Zod)                                 │
│  - Database Access (Prisma ORM)                             │
│  - AI Service Orchestration Clients                         │
└──────────────┬──────────────────────────────┬───────────────┘
               │                              │
       Internal HTTP (8001)           Internal HTTP (8002)
               │                              │
               ▼                              ▼
┌─────────────────────────────┐┌──────────────────────────────┐
│     GenAI Service (Python)  ││   Agentic AI Service (Python)│
│  - Resume Parsing           ││  - LangGraph State Machine   │
│  - Skill Extraction         ││  - CareerAgent & ResumeAgent │
│  - Vector Embeddings        ││  - SkillGap & Job Agents     │
│  - RAG Pipeline             ││  - Learning Planner Agent    │
│  - Gemini LLM Integration   ││  - MCP Tool Calling Layer    │
└──────────────┬──────────────┘└──────────────┬───────────────┘
               │                              │
               ▼                              ▼
    Vector Store / Embeddings           External Tools / MCP
```

---

## 2. Core Architectural Principles

1. **API Gateway Primacy**: The Flutter mobile application communicates **exclusively** with the Node.js API Gateway. Under no circumstances does the mobile client directly invoke Gemini, LangGraph, or Vector Databases.
2. **Layered Separation of Concerns (Backend)**:
   ```
   HTTP Request
        ↓
     Route (Mounting & Path definition)
        ↓
     Middleware (Authentication, Zod Validation, Rate Limiting, Logging)
        ↓
     Controller (HTTP response formatting, status codes, delegation)
        ↓
     Service (Core business logic, domain rules)
        ↓
     Repository (Prisma ORM queries, database operations)
        ↓
     Database (PostgreSQL 16)
   ```
3. **Stateless AI Execution**: AI services are designed as stateless computation engines. Stateful session tracking and profile persistence remain within the Node.js backend and PostgreSQL.
4. **Resilient Integration Interfaces**: Node.js communicates with GenAI and Agentic AI services via typed client abstractions (`GenAIClient`, `AgentClient`). During early phases or service outages, these clients fall back to deterministic mock implementations, ensuring uninterrupted frontend development.

---

## 3. Four Engineering Tracks

### Track 1: Flutter Engineer (Mobile UI/UX)
- **Tech Stack**: Flutter, Dart, Riverpod, GoRouter, Dio.
- **Responsibilities**: Mobile interface, reactive state management, offline token caching, dashboard data visualization, interactive AI career chat UI, job application kanban tracking.
- **Contract**: Relies on documented endpoints in `docs/api.md`.

### Track 2: Node.js Backend Engineer (Platform & API)
- **Tech Stack**: Node.js, TypeScript, Express.js, Prisma ORM, PostgreSQL, Zod, JWT.
- **Responsibilities**: REST API routing, user management, resume metadata, job and application databases, centralized error handling, and orchestrating downstream Python AI services.
- **Contract**: Exposes `/api/v1/*` and integrates with `ai/genai/` and `ai/agents/`.

### Track 3: GenAI Engineer (Model Intelligence & RAG)
- **Tech Stack**: Python 3.11, FastAPI, Pydantic, Gemini API, HuggingFace embeddings, FAISS / pgvector.
- **Responsibilities**: Resume text extraction, skill entity recognition, embedding generation, vector similarity search, and RAG document grounding.
- **Contract**: Exposes internal HTTP endpoints under `/ai/*`.

### Track 4: Agentic AI Engineer (Autonomous Workflows & LangGraph)
- **Tech Stack**: Python 3.11, FastAPI, LangGraph, Pydantic, MCP (Model Context Protocol).
- **Responsibilities**: Autonomous multi-step career planning, skill-gap analysis, learning milestone generation, and external tool execution.
- **Contract**: Exposes internal HTTP endpoints under `/agents/*`.

---

## 4. LangGraph Agent Architecture

The initial Agentic AI workflow uses a typed state graph:

```
                  ┌───────────────┐
                  │     START     │
                  └───────┬───────┘
                          │
                          ▼
                  ┌───────────────┐
                  │  Profile Node │
                  └───────┬───────┘
                          │
                          ▼
               ┌───────────────────────┐
               │  Skill Analysis Node  │
               └──────────┬────────────┘
                          │
                          ▼
               ┌───────────────────────┐
               │  Recommendation Node  │
               └──────────┬────────────┘
                          │
                          ▼
                  ┌───────────────┐
                  │      END      │
                  └───────────────┘
```

### Shared State Contract
```python
class CareerState(TypedDict):
    user_id: str
    target_role: str
    skills: list[str]
    resume_data: dict
    job_data: list[dict]
    skill_gaps: list[dict]
    recommendations: list[dict]
```

Each node consumes this shared state, enriches it via specialized agents or tools (such as `JobSearchTool` and `SkillBenchmarkTool`), and emits the updated state to downstream nodes.

---

## 5. Security & Authentication Flow

1. **User Authentication**: Client submits credentials via `POST /api/v1/auth/login`.
2. **Verification & Token Issuance**: Node.js hashes and verifies password against `passwordHash` (bcryptjs with salt rounds = 10). A signed JSON Web Token (JWT) is issued containing `userId` and `email`.
3. **Client Storage**: Flutter securely caches the JWT in `FlutterSecureStorage`.
4. **Authorized Requests**: Subsequent requests pass the token in the `Authorization: Bearer <token>` header.
5. **Gateway Verification**: The `auth.middleware.ts` decodes the token, attaches the user context to `req.user`, and verifies permissions before passing execution to the controller.

---

## 6. Database Schema (PostgreSQL via Prisma)

```
┌──────────────────┐       1:N       ┌──────────────────┐
│       User       ├────────────────►│      Resume      │
└────────┬─────────┘                 └──────────────────┘
         │
         │ 1:N
         ├──────────────────────────►┌──────────────────┐
         │                           │   Application    │
         │                           └────────▲─────────┘
         │ 1:N                                │ N:1
         ▼                                    │
┌──────────────────┐                 ┌────────┴─────────┐
│    UserSkill     │                 │       Job        │
└────────┬─────────┘                 └──────────────────┘
         │ N:1
         ▼
┌──────────────────┐
│      Skill       │
└──────────────────┘
```

Key indexes are applied on `User.email`, `UserSkill(userId, skillId)`, `Job.title`, and `Application(userId, jobId)`.
