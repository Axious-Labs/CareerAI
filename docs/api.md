# CareerAI — API Specification & Contracts

> **Version:** 1.0.0  
> **Base URL (Gateway):** `http://localhost:5000/api/v1`  
> **Internal AI Service:** `http://localhost:8001`  
> **Internal Agent Service:** `http://localhost:8002`

---

## 1. Authentication & Security

All protected endpoints require a valid JSON Web Token passed in the `Authorization` header:
```http
Authorization: Bearer <jwt_token>
```

### Standard Error Response Format
All error responses return a standardized JSON structure:
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR | UNAUTHORIZED | NOT_FOUND | INTERNAL_ERROR",
    "message": "Human readable explanation of the error",
    "details": []
  }
}
```

---

## 2. Authentication Endpoints

### 2.1 Register User
- **Method:** `POST`
- **Path:** `/auth/register`
- **Auth Required:** No

#### Request Body
```json
{
  "name": "Alex Chen",
  "email": "alex.chen@university.edu",
  "password": "SecurePassword123!",
  "targetRole": "AI/ML Engineer"
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "usr_94a7e812",
      "name": "Alex Chen",
      "email": "alex.chen@university.edu",
      "targetRole": "AI/ML Engineer",
      "createdAt": "2026-09-20T00:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### 2.2 Login User
- **Method:** `POST`
- **Path:** `/auth/login`
- **Auth Required:** No

#### Request Body
```json
{
  "email": "alex.chen@university.edu",
  "password": "SecurePassword123!"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "usr_94a7e812",
      "name": "Alex Chen",
      "email": "alex.chen@university.edu",
      "targetRole": "AI/ML Engineer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

## 3. User Profile Endpoints

### 3.1 Get Current User Profile
- **Method:** `GET`
- **Path:** `/users/me`
- **Auth Required:** Yes

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "id": "usr_94a7e812",
    "name": "Alex Chen",
    "email": "alex.chen@university.edu",
    "targetRole": "AI/ML Engineer",
    "careerReadiness": 68,
    "skills": [
      { "name": "Python", "proficiency": "ADVANCED", "score": 80 },
      { "name": "Flutter", "proficiency": "INTERMEDIATE", "score": 70 },
      { "name": "GenAI", "proficiency": "INTERMEDIATE", "score": 60 },
      { "name": "ML", "proficiency": "BEGINNER", "score": 40 }
    ],
    "todayPlan": [
      { "id": "p1", "title": "Complete Transformers lesson", "completed": true },
      { "id": "p2", "title": "Solve 2 DSA problems", "completed": true },
      { "id": "p3", "title": "Apply to 3 relevant jobs", "completed": false }
    ]
  }
}
```

---

### 3.2 Update User Profile
- **Method:** `PUT`
- **Path:** `/users/me`
- **Auth Required:** Yes

#### Request Body
```json
{
  "name": "Alex Chen",
  "targetRole": "Senior ML Engineer"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "id": "usr_94a7e812",
    "name": "Alex Chen",
    "targetRole": "Senior ML Engineer",
    "updatedAt": "2026-09-20T01:15:00.000Z"
  }
}
```

---

## 4. Skills Endpoints

### 4.1 List All Skills
- **Method:** `GET`
- **Path:** `/skills`
- **Auth Required:** Yes

#### Response `200 OK`
```json
{
  "success": true,
  "data": [
    { "id": "sk_1", "name": "Python", "category": "Programming Languages" },
    { "id": "sk_2", "name": "PyTorch", "category": "Machine Learning" },
    { "id": "sk_3", "name": "Flutter", "category": "Mobile Development" }
  ]
}
```

---

### 4.2 Add User Skill
- **Method:** `POST`
- **Path:** `/skills`
- **Auth Required:** Yes

#### Request Body
```json
{
  "skillId": "sk_2",
  "proficiency": "INTERMEDIATE"
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "userId": "usr_94a7e812",
    "skillId": "sk_2",
    "proficiency": "INTERMEDIATE"
  }
}
```

---

## 5. Resume Endpoints

### 5.1 Upload Resume
- **Method:** `POST`
- **Path:** `/resumes/upload`
- **Auth Required:** Yes
- **Content-Type:** `multipart/form-data` or JSON with base64/file URL

#### Request Body (JSON format)
```json
{
  "fileName": "Alex_Chen_Resume_2026.pdf",
  "fileUrl": "https://storage.careerai.io/resumes/alex_chen.pdf"
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "id": "res_a8f9021b",
    "fileName": "Alex_Chen_Resume_2026.pdf",
    "status": "PARSED",
    "extractedSkills": ["Python", "TensorFlow", "FastAPI", "Docker"],
    "createdAt": "2026-09-20T01:20:00.000Z"
  }
}
```

---

### 5.2 Get User Resumes
- **Method:** `GET`
- **Path:** `/resumes`
- **Auth Required:** Yes

#### Response `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "res_a8f9021b",
      "fileName": "Alex_Chen_Resume_2026.pdf",
      "fileUrl": "https://storage.careerai.io/resumes/alex_chen.pdf",
      "status": "PARSED",
      "createdAt": "2026-09-20T01:20:00.000Z"
    }
  ]
}
```

---

## 6. Jobs & Applications Endpoints

### 6.1 Discover Jobs
- **Method:** `GET`
- **Path:** `/jobs`
- **Auth Required:** Yes
- **Query Params:** `role`, `location`

#### Response `200 OK`
```json
{
  "success": true,
  "data": [
    {
      "id": "job_01",
      "title": "Junior AI Engineer",
      "company": "Axious Labs",
      "location": "Remote",
      "description": "Building next-gen career intelligence agents.",
      "matchScore": 84,
      "sourceUrl": "https://careers.axiouslabs.org/jobs/1"
    }
  ]
}
```

---

### 6.2 Submit/Track Application
- **Method:** `POST`
- **Path:** `/applications`
- **Auth Required:** Yes

#### Request Body
```json
{
  "jobId": "job_01",
  "status": "APPLIED",
  "notes": "Applied with revised resume emphasizing LangGraph skills."
}
```

#### Response `201 Created`
```json
{
  "success": true,
  "data": {
    "id": "app_99182",
    "jobId": "job_01",
    "status": "APPLIED",
    "appliedAt": "2026-09-20T01:30:00.000Z",
    "notes": "Applied with revised resume emphasizing LangGraph skills."
  }
}
```

---

## 7. AI Career Assistant & Intelligence Endpoints

### 7.1 Chat with AI Career Assistant
- **Method:** `POST`
- **Path:** `/chat`
- **Auth Required:** Yes

#### Request Body
```json
{
  "message": "What should I learn to become an AI Engineer?"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "response": "Based on your current profile (strong Python at 80% and Flutter at 70%), prioritize mastering LLM architectures, fine-tuning with LoRA, and agentic workflows using LangGraph.",
    "source": "career_assistant",
    "suggestedActions": [
      "View AI/ML Roadmap",
      "Analyze Skill Gaps",
      "Review Recommended Projects"
    ]
  }
}
```

---

### 7.2 Analyze Career Profile
- **Method:** `POST`
- **Path:** `/career/analyze`
- **Auth Required:** Yes

#### Request Body
```json
{
  "targetRole": "AI/ML Engineer"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "careerReadiness": 68,
    "topSkills": ["Python", "Flutter", "GenAI", "ML"],
    "summary": "Your profile demonstrates a solid engineering foundation. Bridging the gap in distributed model training will elevate your readiness."
  }
}
```

---

### 7.3 Skill Gap Analysis
- **Method:** `POST`
- **Path:** `/career/skill-gap`
- **Auth Required:** Yes

#### Request Body
```json
{
  "targetRole": "AI/ML Engineer"
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "targetRole": "AI/ML Engineer",
    "missingSkills": [
      { "name": "LangGraph", "importance": "HIGH", "estimatedTimeToLearn": "2 weeks" },
      { "name": "Vector Databases", "importance": "HIGH", "estimatedTimeToLearn": "1 week" },
      { "name": "Kubernetes / MLOps", "importance": "MEDIUM", "estimatedTimeToLearn": "3 weeks" }
    ],
    "strongSkills": ["Python", "FastAPI", "Git"]
  }
}
```

---

### 7.4 Personalized Learning Roadmap
- **Method:** `POST`
- **Path:** `/career/roadmap`
- **Auth Required:** Yes

#### Request Body
```json
{
  "targetRole": "AI/ML Engineer",
  "timelineWeeks": 8
}
```

#### Response `200 OK`
```json
{
  "success": true,
  "data": {
    "roadmapTitle": "AI/ML Engineer 8-Week Accelerated Path",
    "milestones": [
      {
        "week": 1,
        "title": "LLM Fundamentals & Prompt Engineering",
        "tasks": ["Complete Transformers lesson", "Build few-shot prompt evaluator"]
      },
      {
        "week": 2,
        "title": "RAG Architectures & Vector Stores",
        "tasks": ["Implement FAISS retrieval", "Index PDF knowledge base"]
      },
      {
        "week": 3,
        "title": "Agentic Workflows with LangGraph",
        "tasks": ["Implement StateGraph", "Build multi-tool career advisor agent"]
      }
    ]
  }
}
```

---

## 8. Internal Python AI Service Contracts

### 8.1 GenAI Service (`http://localhost:8001`)
- `POST /ai/resume/analyze`: Extracts text, work history, and skills from resume documents.
- `POST /ai/skills/extract`: Extracts technical and soft skills from free-form text.
- `POST /ai/rag/query`: RAG query endpoint retrieving relevant career curriculum context.
- `POST /ai/jobs/match`: Calculates similarity score between candidate profile and job description.

### 8.2 Agentic AI Service (`http://localhost:8002`)
- `POST /agents/career-plan`: Executes the multi-node LangGraph workflow to generate milestone career plans.
- `POST /agents/skill-gap`: Runs `SkillGapAgent` to benchmark candidate skills against real job requirements.
- `POST /agents/learning-roadmap`: Runs `LearningPlannerAgent` to build tailored learning schedules.
