# CareerAI — Contribution & Team Workflow

> **Axious Labs** | Student-Led Technology Venture  
> **Project Lead:** Ravi Prakash

---

## 1. Team Organization & Roles

| Contributor | Track / Role | Key Responsibilities |
| :--- | :--- | :--- |
| **Ravi Prakash** | **Project Lead** | Architecture oversight, sprint planning, PR reviews, release management |
| **Developer 1** | **Flutter Engineer** | Mobile app UI/UX, Riverpod state, GoRouter, API integration |
| **Developer 2** | **Node.js Backend Engineer** | API gateway, PostgreSQL + Prisma, Auth/JWT, Zod, Swagger |
| **Developer 3** | **GenAI Engineer** | Resume parsing, skill extraction, RAG, embeddings, model evaluation |
| **Developer 4** | **Agentic AI Engineer** | LangGraph workflows, CareerState, agents, tools, MCP integrations |

---

## 2. GitHub Collaboration Workflow

We follow a structured Issue-to-PR workflow to ensure clean history and maintainable code:

```
GitHub Issue
     ↓
Assign Contributor
     ↓
Create Feature Branch
     ↓
Implementation & Local Testing
     ↓
Commit (Conventional Commits)
     ↓
Open Pull Request
     ↓
Automated CI Checks
     ↓
Code Review by Ravi Prakash
     ↓
Merge to `develop` / `main`
```

---

## 3. Branch Naming Conventions

All branches must follow the track-specific naming conventions:

### Flutter Track
- `feature/flutter-dashboard`
- `feature/flutter-auth`
- `feature/flutter-resume`
- `feature/flutter-chat`

### Node.js Backend Track
- `feature/auth-api`
- `feature/jobs-api`
- `feature/application-api`
- `feature/ai-integration-client`

### GenAI Track
- `feature/resume-rag`
- `feature/skill-extraction`
- `feature/job-matching`
- `feature/embedding-pipeline`

### Agentic AI Track
- `feature/langgraph-skeleton`
- `feature/skill-gap-agent`
- `feature/career-agent`
- `feature/mcp-tools`

---

## 4. Commit Message Standard

Use the Conventional Commits specification:
```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

Examples:
- `feat(mobile): implement interactive career readiness gauge on dashboard`
- `feat(backend): add Zod validation for user skill update endpoint`
- `feat(genai): implement mock resume parsing service with fallback`
- `feat(agents): create LangGraph StateGraph skeleton with CareerState`
- `fix(backend): resolve token expiration mismatch in auth middleware`

---

## 5. Code Review Checklist (Ravi Prakash)

Every Pull Request must be reviewed against these criteria:

- [ ] **Architecture Boundary**: Does the PR respect the architecture? (e.g. Flutter must never call AI services directly).
- [ ] **Type Safety**: TypeScript strict mode enabled with no `any` leaks; Pydantic models utilized in Python.
- [ ] **Layering**: Express controllers must remain slim; all business logic lives in services; database queries live in repositories.
- [ ] **Validation**: All incoming HTTP payloads are validated using Zod schemas.
- [ ] **Security**: No secrets committed; passwords hashed with bcrypt; JWT verification on protected routes.
- [ ] **Error Handling**: Uses centralized error middleware; returns standard JSON error structure.
- [ ] **Test Coverage**: Appropriate unit tests added or updated.
- [ ] **Documentation**: API changes reflected in `docs/api.md`.

---

## 6. Definition of Done (DoD)

A task or feature is considered **Done** only when:
1. Code compiles and runs cleanly with zero linting warnings.
2. Unit tests pass locally and in GitHub Actions CI.
3. API endpoints are documented in `docs/api.md` and Swagger.
4. Clean separation of concerns is maintained.
5. PR is approved by Ravi Prakash and merged without conflicts.
