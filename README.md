# CareerAI by Axious Labs

> **AI-powered Career Intelligence Platform**  
> *Developed by Axious Labs — a student-led technology venture.*

---

## 🚀 Overview

**CareerAI** is an intelligent career acceleration platform designed specifically for students and early-career developers. Developed by **Axious Labs**, CareerAI bridges the gap between academic preparation and industry demands through real-time resume intelligence, dynamic skill-gap analysis, personalized learning roadmaps, and autonomous career planning agents.

### Core Workflow

```
Student 
  ↓
Career Profile
  ↓
Resume Intelligence
  ↓
Skill Analysis
  ↓
Job Matching
  ↓
Skill Gap Analysis
  ↓
Personalized Learning
  ↓
Agentic Career Planning
```

---

## 🏛️ System Architecture

CareerAI follows a clean, decoupled microservices architecture with a centralized API gateway:

```
Flutter Mobile App (iOS / Android)
        │
        │ REST / SSE
        ▼
Node.js API Gateway (Express + TypeScript + Prisma)
        ├──────────────────────────► PostgreSQL (Database)
        ├──────────────────────────► Redis (Cache / Queues)
        │
        ├──────────────────────────► GenAI Service (FastAPI + LLM + RAG + Embeddings)
        │
        └──────────────────────────► Agentic AI Service (FastAPI + LangGraph + MCP)
```

> **Security Note:** The Flutter mobile application communicates **exclusively** with the Node.js API Gateway. Internal GenAI models, LangGraph workflows, and vector stores are protected behind the gateway with strict JWT authentication and authorization.

---

## 👥 Engineering Tracks & Ownership

**Project Lead:** Ravi Prakash (Architecture, product direction, sprint planning, code reviews, and integration)

| Track | Lead Role | Primary Technologies | Directory |
| :--- | :--- | :--- | :--- |
| **Track 1** | **Flutter Engineer** | Flutter, Dart, Riverpod, GoRouter, Dio | `mobile/` |
| **Track 2** | **Node.js Backend Engineer** | Node.js, TypeScript, Express, Prisma, PostgreSQL, Zod, Swagger | `backend/` |
| **Track 3** | **GenAI Engineer** | Python, FastAPI, Gemini, RAG, Embeddings, Vector Stores | `ai/genai/` |
| **Track 4** | **Agentic AI Engineer** | Python, FastAPI, LangGraph, Tools, MCP, Multi-Agent Workflows | `ai/agents/` |

---

## 📁 Repository Structure

```
careerai/
├── mobile/                      # Flutter mobile application
│   ├── lib/
│   │   ├── core/                # Constants, network client, router, theme, utils
│   │   ├── features/            # auth, dashboard, profile, resume, skills, jobs, applications, ai_chat
│   │   └── main.dart            # Entry point
│   ├── pubspec.yaml
│   └── test/
│
├── backend/                     # Node.js + Express API Gateway
│   ├── src/
│   │   ├── config/              # Environment & Swagger configs
│   │   ├── controllers/         # HTTP controllers
│   │   ├── database/            # Prisma client & seed
│   │   ├── integrations/        # GenAIClient & AgentClient integration layers
│   │   ├── middleware/          # Auth, error handling, Zod validation, logger
│   │   ├── repositories/        # Database access layer
│   │   ├── routes/              # Express routes
│   │   ├── schemas/             # Zod validation schemas
│   │   ├── services/            # Business logic layer
│   │   ├── utils/               # JWT, response helpers, logger
│   │   └── server.ts            # Server entrypoint
│   ├── prisma/                  # Prisma schema & migrations
│   ├── tests/                   # Jest tests
│   ├── Dockerfile
│   ├── package.json
│   └── tsconfig.json
│
├── ai/
│   ├── genai/                   # Python GenAI service
│   │   ├── embeddings/          # Embedding interfaces
│   │   ├── evaluation/          # Evaluation harness
│   │   ├── models/              # Pydantic data models
│   │   ├── prompts/             # Prompt engineering templates
│   │   ├── rag/                 # RAG retrieval pipeline
│   │   ├── services/            # LLM & parser interfaces + mock services
│   │   ├── tests/               # Pytest suite
│   │   ├── Dockerfile
│   │   ├── main.py              # FastAPI server
│   │   └── requirements.txt
│   │
│   └── agents/                  # Python Agentic AI service
│       ├── agents/              # Career, Resume, SkillGap, Job, Learning agents
│       ├── graph/               # LangGraph StateGraph skeleton
│       ├── nodes/               # Profile, Skill Analysis, Recommendation nodes
│       ├── state/               # Shared CareerState
│       ├── tools/               # Tool registry & definitions
│       ├── mcp/                 # Model Context Protocol skeleton
│       ├── services/            # Agent orchestration service
│       ├── tests/               # Pytest suite
│       ├── Dockerfile
│       ├── main.py              # FastAPI server
│       └── requirements.txt
│
├── docs/                        # Project documentation
│   ├── architecture.md          # Architectural blueprints & design decisions
│   ├── api.md                   # OpenAPI & REST API contracts
│   ├── development.md           # Local setup & running instructions
│   └── contribution.md          # Git workflow, PR templates & review checklist
│
├── infrastructure/
│   └── docker-compose.yml       # Docker Compose setup for local development
│
├── .github/workflows/
│   └── ci.yml                   # Multi-track CI pipeline
│
├── .env.example
├── .gitignore
├── README.md
└── LICENSE
```

---

## ⚡ Quick Start

### 1. Prerequisites
- Docker & Docker Compose
- Node.js (v18+) & npm
- Python (3.11+)
- Flutter SDK (3.19+)

### 2. Configure Environment
```bash
cp .env.example .env
```

### 3. Run with Docker Compose
To start PostgreSQL, Redis, Node.js Backend, GenAI Service, and Agentic Service in one command:
```bash
cd infrastructure
docker-compose up --build
```

### 4. Running Services Standalone

#### Backend (Node.js)
```bash
cd backend
npm install
npx prisma generate
npm run dev
# Server running at http://localhost:5000
# Swagger API docs at http://localhost:5000/docs
```

#### GenAI Service (Python)
```bash
cd ai/genai
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
# Service running at http://localhost:8001
```

#### Agentic AI Service (Python)
```bash
cd ai/agents
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8002
# Service running at http://localhost:8002
```

#### Mobile App (Flutter)
```bash
cd mobile
flutter pub get
flutter run
```

---

## 📖 Documentation

- [System Architecture](docs/architecture.md)
- [API Contracts & Swagger](docs/api.md)
- [Local Development Guide](docs/development.md)
- [Contribution & Branching Guide](docs/contribution.md)

---

## 🛡️ License

Distributed under the MIT License. See [LICENSE](LICENSE) for more details.  
Built with passion by **Axious Labs**.
