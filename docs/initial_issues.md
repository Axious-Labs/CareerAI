# CareerAI — Initial Sprint Issues & Task Backlog

> **Axious Labs** | Student-Led Technology Venture  
> **Sprint Lead:** Ravi Prakash

---

## 1. Track 1: Flutter Engineer

- **ISSUE-MOB-01: Flutter Architecture & Design System**
  - Establish Material 3 dark theme with Axious Labs slate and cyan branding (`AppColors`, `AppTheme`).
  - Configure Riverpod `ProviderScope` and GoRouter routing hierarchy.
- **ISSUE-MOB-02: Authentication UI & Storage**
  - Build Login and Register screens with form validation.
  - Implement `FlutterSecureStorage` caching for JWT tokens and Dio auth interceptor.
- **ISSUE-MOB-03: Modern Dashboard Implementation**
  - Implement target role header, career readiness gauge (68%), visual skills breakdown bars (Python 80%, Flutter 70%, GenAI 60%, ML 40%).
  - Add daily career plan checklist and quick action cards.
- **ISSUE-MOB-04: Profile, Resume & Skills Modules**
  - Create Profile screen with editable target role.
  - Build Resume intelligence upload screen with parsing status and extracted skills chips.
  - Develop Skills screen with category grouping and interactive Skill Gap analysis view.
- **ISSUE-MOB-05: Jobs & Applications Tracker**
  - Build Job discovery cards with match scores and tag chips.
  - Create Application tracking pipeline with status badges (Applied, Interviewing, Offer, Rejected).
- **ISSUE-MOB-06: AI Career Assistant Chat Interface**
  - Build real-time chat interface with suggested prompt pills and typing indicator.
  - Integrate with Node.js `/chat` endpoint.

---

## 2. Track 2: Node.js Backend Engineer

- **ISSUE-BE-01: Express & TypeScript Foundation**
  - Set up strict TypeScript configuration, centralized error handling middleware, request logger, and environment loader.
- **ISSUE-BE-02: PostgreSQL & Prisma Database Schema**
  - Define `User`, `Skill`, `UserSkill`, `Resume`, `Job`, and `Application` models with foreign keys, enums, and indexes.
  - Create database seed script (`src/database/seed.ts`).
- **ISSUE-BE-03: Authentication & User API**
  - Implement `POST /auth/register` and `POST /auth/login` with bcrypt hashing and signed JWTs.
  - Implement `GET /users/me` and `PUT /users/me` protected by JWT middleware.
- **ISSUE-BE-04: Skills, Resumes, Jobs & Applications APIs**
  - Implement CRUD routes, controllers, services, and repositories for skills, resumes, jobs, and applications.
  - Enforce Zod validation across all endpoints.
- **ISSUE-BE-05: AI & Agent Integration Client Layers**
  - Build `GenAIClient` and `AgentClient` with timeout protection and fallback mock engines.
  - Expose `/chat`, `/career/analyze`, `/career/skill-gap`, and `/career/roadmap`.
- **ISSUE-BE-06: OpenAPI / Swagger Documentation**
  - Expose interactive Swagger UI at `/docs` with complete schemas.

---

## 3. Track 3: GenAI Engineer

- **ISSUE-AI-01: Service Architecture & FastAPI Setup**
  - Scaffold FastAPI application on port 8001 with CORS and healthcheck.
  - Define Pydantic models for resume analysis, skill extraction, RAG queries, and job matching.
- **ISSUE-AI-02: Service Interfaces & Abstract Classes**
  - Define ABC interfaces: `LLMService`, `ResumeParser`, `EmbeddingService`, `VectorStore`, `RAGService`, `SkillExtractionService`, `JobMatchingService`.
- **ISSUE-AI-03: Resume Parser & Skill Extraction**
  - Create mock parser returning extracted skills, education, experience, and development areas.
  - Standardize prompt templates in `prompts/resume_prompt.py` and `prompts/skill_prompt.py`.
- **ISSUE-AI-04: Embedding & Vector Search Abstraction**
  - Implement `MockEmbeddingService` and in-memory `MockVectorStore` for top-k document retrieval.
- **ISSUE-AI-05: RAG Pipeline & Evaluation Harness**
  - Implement `RAGPipeline` context retrieval and prompt synthesis.
  - Create `AIResponseEvaluator` to measure groundedness and actionability scores.

---

## 4. Track 4: Agentic AI Engineer

- **ISSUE-AGT-01: Service Architecture & CareerState Definition**
  - Scaffold FastAPI application on port 8002.
  - Implement typed shared state `CareerState(TypedDict)` with user_id, target_role, skills, resume_data, job_data, skill_gaps, recommendations.
- **ISSUE-AGT-02: LangGraph StateGraph Skeleton**
  - Build linear workflow: START → Profile Node → Skill Analysis Node → Recommendation Node → END.
  - Implement node functions to validate profile, benchmark skills, and emit actionable milestones.
- **ISSUE-AGT-03: Specialized Career Agents**
  - Implement `CareerAgent`, `ResumeAgent`, `SkillGapAgent`, `JobAgent`, and `LearningPlannerAgent`.
- **ISSUE-AGT-04: Tool Calling & MCP Architecture**
  - Implement `CareerTool` base class with `JobSearchTool` and `SkillBenchmarkTool`.
  - Create `MCPAdapter` exposing standard Model Context Protocol tool definitions.
- **ISSUE-AGT-05: API Endpoints & Testing**
  - Expose `POST /agents/career-plan`, `POST /agents/skill-gap`, and `POST /agents/learning-roadmap`.
  - Write pytest test suite for graph execution and state transitions.
