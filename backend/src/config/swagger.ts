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
      post: {
        summary: 'Create a new job posting',
        tags: ['Jobs'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Job created' },
        },
      },
    },
    '/jobs/recommendations': {
      get: {
        summary: 'Get personalized job recommendations ranked by match score',
        tags: ['Jobs'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Ranked job recommendations returned' },
        },
      },
    },
    '/jobs/search': {
      get: {
        summary: 'Search jobs by title, company, description, and location',
        tags: ['Jobs'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Filtered jobs returned' },
        },
      },
    },
    '/jobs/{id}/match': {
      get: {
        summary: 'Analyze candidate skill overlap and match score for a specific job',
        tags: ['Jobs'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Match breakdown and interview prep tips returned' },
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
    '/applications/analytics': {
      get: {
        summary: 'Get job application funnel analytics, offer rates, and actionable insights',
        tags: ['Applications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Application pipeline metrics returned' },
        },
      },
    },
    '/applications/{id}/status': {
      patch: {
        summary: 'Update application recruitment stage status and notes',
        tags: ['Applications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Application status updated' },
        },
      },
    },
    '/applications/{id}/notes': {
      patch: {
        summary: 'Update notes on an existing application',
        tags: ['Applications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Notes updated' },
        },
      },
    },
    '/goals': {
      get: {
        summary: 'Get user career goals and milestone progress',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Goals list returned' },
        },
      },
      post: {
        summary: 'Create a new career goal with milestone checkpoints',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Goal created' },
        },
      },
    },
    '/goals/summary': {
      get: {
        summary: 'Get career goals metrics, overall completion rate, and next milestones',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Goals summary metrics returned' },
        },
      },
    },
    '/goals/{id}/progress': {
      patch: {
        summary: 'Update goal progress percentage and status',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Goal progress updated' },
        },
      },
    },
    '/goals/{id}/milestones': {
      post: {
        summary: 'Add milestone to an existing career goal',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Milestone added' },
        },
      },
    },
    '/goals/{id}/milestones/{milestoneId}/toggle': {
      patch: {
        summary: 'Toggle milestone completion status and recalculate goal progress',
        tags: ['Career Goals'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Milestone toggled' },
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
    '/career/resources': {
      get: {
        summary: 'Get curated learning guides, architecture patterns, and technical resources',
        tags: ['Career Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Curated technical resources returned' },
        },
      },
    },
    '/notifications': {
      get: {
        summary: 'List user notifications with optional unread/type filters',
        tags: ['Notifications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'List of user notifications' },
        },
      },
      post: {
        summary: 'Create and dispatch a new user notification',
        tags: ['Notifications'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Notification created' },
        },
      },
    },
    '/notifications/summary': {
      get: {
        summary: 'Get breakdown of unread and prioritized notifications',
        tags: ['Notifications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Notification summary returned' },
        },
      },
    },
    '/notifications/mark-all-read': {
      patch: {
        summary: 'Mark all unread notifications as read',
        tags: ['Notifications'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'All notifications marked as read' },
        },
      },
    },
    '/analytics/overview': {
      get: {
        summary: 'Get platform overview readiness and hiring metrics',
        tags: ['Analytics & Market Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Analytics overview returned' },
        },
      },
    },
    '/analytics/market-trends': {
      get: {
        summary: 'Get real-time market demand and tech hiring trends',
        tags: ['Analytics & Market Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Market insights returned' },
        },
      },
    },
    '/analytics/salary-benchmark': {
      post: {
        summary: 'Calculate salary bands and skill premiums by role & level',
        tags: ['Analytics & Market Intelligence'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'Salary benchmark report returned' },
        },
      },
    },
    '/learning/courses': {
      get: {
        summary: 'List curated engineering courses and learning tracks',
        tags: ['Learning & Mentorship'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'List of courses returned' },
        },
      },
      post: {
        summary: 'Publish a new structured engineering course',
        tags: ['Learning & Mentorship'],
        security: [{ BearerAuth: [] }],
        responses: {
          201: { description: 'Course published successfully' },
        },
      },
    },
    '/learning/enrolled': {
      get: {
        summary: 'Get user enrolled courses and progress tracking',
        tags: ['Learning & Mentorship'],
        security: [{ BearerAuth: [] }],
        responses: {
          200: { description: 'User learning dashboard returned' },
        },
      },
    },
  },
};
