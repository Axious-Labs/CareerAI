# CareerAI — Local Development Guide

> **Axious Labs** | Student-Led Technology Venture

---

## 1. System Requirements

Ensure you have the following installed on your development machine:
- **Node.js**: v18.x or v20.x LTS
- **npm**: v9.x or v10.x
- **Python**: v3.11 or v3.12
- **Flutter SDK**: v3.19.x or later
- **Docker & Docker Compose**: v2.20+

---

## 2. Setting Up the Environment

1. Clone the repository and navigate to the project directory:
   ```bash
   cd careerai
   ```

2. Copy the environment variables template:
   ```bash
   cp .env.example .env
   ```

3. Update `.env` with your preferred local configurations if needed.

---

## 3. Running with Docker Compose (Recommended)

To launch all backend dependencies (PostgreSQL, Redis, Node.js API Gateway, GenAI Service, and Agentic AI Service) with a single command:

```bash
cd infrastructure
docker-compose up --build
```

### Verified Endpoints
- **Node.js API Gateway:** `http://localhost:5000`
- **Swagger Documentation:** `http://localhost:5000/docs`
- **GenAI Service:** `http://localhost:8001/docs`
- **Agentic AI Service:** `http://localhost:8002/docs`
- **PostgreSQL:** `localhost:5432`
- **Redis:** `localhost:6379`

---

## 4. Running Standalone Services

### 4.1 Node.js Backend Gateway
```bash
cd backend
npm install
npx prisma generate
npx prisma db push
npm run seed
npm run dev
```

### 4.2 Python GenAI Service
```bash
cd ai/genai
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8001
```

### 4.3 Python Agentic AI Service
```bash
cd ai/agents
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8002
```

### 4.4 Flutter Mobile Application
```bash
cd mobile
flutter pub get
flutter run
```

---

## 5. Running Tests

### Backend Tests
```bash
cd backend
npm test
```

### GenAI Tests
```bash
cd ai/genai
pytest
```

### Agentic AI Tests
```bash
cd ai/agents
pytest
```

### Flutter Tests
```bash
cd mobile
flutter test
```
