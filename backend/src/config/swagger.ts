export const swaggerSpec = {
  openapi: '3.0.0',
  info: {
    title: 'CareerAI API Documentation',
    version: '1.0.0',
    description:
      'Production API Gateway for CareerAI by Axious Labs (Student-led Technology Venture). Project Lead: Ravi Prakash.',
    contact: {
      name: 'Axious Labs Engineering',
      email: 'engineering@axiouslabs.org',
    },
  },
  servers: [
    {
      url: '/api/v1',
      description: 'API Gateway v1',
    },
  ],
  components: {
    securitySchemes: {
      BearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
    schemas: {
      StandardResponse: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          data: { type: 'object' },
        },
      },
      ErrorResponse: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          error: {
            type: 'object',
            properties: {
              code: { type: 'string', example: 'VALIDATION_ERROR' },
              message: { type: 'string', example: 'Invalid request parameters' },
            },
          },
        },
      },
      User: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'usr_12345' },
          name: { type: 'string', example: 'Alex Chen' },
          email: { type: 'string', example: 'alex.chen@university.edu' },
          targetRole: { type: 'string', example: 'AI/ML Engineer' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
    },
  },
  paths: {
    '/auth/register': {
      post: {
        summary: 'Register new user account',
        tags: ['Authentication'],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name', 'email', 'password'],
                properties: {
                  name: { type: 'string', example: 'Alex Chen' },
                  email: { type: 'string', example: 'alex.chen@university.edu' },
                  password: { type: 'string', example: 'Password123!' },
                  targetRole: { type: 'string', example: 'AI/ML Engineer' },
                },
              },
            },
          },
        },
        responses: {
          201: { description: 'User registered successfully' },
          400: { description: 'Validation error or email already exists' },
        },
      },
    },
    '/auth/login': {
      post: {
        summary: 'Authenticate user and receive JWT',
        tags: ['Authentication'],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['email', 'password'],
                properties: {
                  email: { type: 'string', example: 'alex.chen@university.edu' },
                  password: { type: 'string', example: 'Password123!' },
                },
              },
            },
          },
        },
        responses: {
          200: { description: 'Authenticated successfully' },
          401: { description: 'Invalid credentials' },
        },
      },
    },
    '/users/me': {
      get: {
        summary: 'Get current user profile, career readiness, skills, and daily plan',
        tags: ['User Profile'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'User profile returned' },
          401: { description: 'Unauthorized' },
        },
      },
      put: {
        summary: 'Update current user target role or profile info',
        tags: ['User Profile'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'User profile updated' },
        },
      },
    },
    '/skills': {
      get: {
        summary: 'List all available career skills',
        tags: ['Skills'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Skills list returned' },
        },
      },
      post: {
        summary: 'Add or update user skill proficiency',
        tags: ['Skills'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Skill added' },
        },
      },
    },
    '/resumes/upload': {
      post: {
        summary: 'Upload and parse candidate resume',
        tags: ['Resumes'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Resume uploaded and queued for intelligence extraction' },
        },
      },
    },
    '/resumes': {
      get: {
        summary: 'List uploaded resumes',
        tags: ['Resumes'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Resumes returned' },
        },
      },
    },
    '/jobs': {
      get: {
        summary: 'Discover matching jobs for user profile',
        tags: ['Jobs'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Jobs list returned' },
        },
      },
    },
    '/applications': {
      get: {
        summary: 'List user job applications',
        tags: ['Applications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Applications returned' },
        },
      },
      post: {
        summary: 'Create or track new job application',
        tags: ['Applications'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Application tracked' },
        },
      },
    },
    '/chat': {
      post: {
        summary: 'Chat with AI Career Assistant',
        tags: ['AI Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Assistant response' },
        },
      },
    },
    '/career/analyze': {
      post: {
        summary: 'Analyze profile readiness for target role',
        tags: ['Career Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Analysis complete' },
        },
      },
    },
    '/career/skill-gap': {
      post: {
        summary: 'Run skill gap analysis against target role',
        tags: ['Career Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Skill gap report generated' },
        },
      },
    },
    '/career/roadmap': {
      post: {
        summary: 'Generate personalized learning roadmap',
        tags: ['Career Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Roadmap generated' },
        },
      },
    },
  },
};
