import { AuthService } from '../src/services/auth.service';
import { UserRepository } from '../src/repositories/user.repository';
import { generateToken, verifyToken } from '../src/utils/jwt';

describe('Auth & JWT Tests', () => {
  it('should generate and verify valid JWT token', () => {
    const payload = { userId: 'usr_test_123', email: 'test@axiouslabs.org' };
    const token = generateToken(payload);

    expect(typeof token).toBe('string');
    expect(token.length).toBeGreaterThan(20);

    const decoded = verifyToken(token);
    expect(decoded.userId).toBe(payload.userId);
    expect(decoded.email).toBe(payload.email);
  });

  it('should register a new user using mocked repository', async () => {
    const mockUser = {
      id: 'usr_mock_1',
      name: 'Ravi Prakash',
      email: 'ravi@axiouslabs.org',
      passwordHash: 'hashed_password',
      targetRole: 'AI/ML Engineer',
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const mockRepo = {
      findByEmail: jest.fn().mockResolvedValue(null),
      create: jest.fn().mockResolvedValue(mockUser),
    } as unknown as UserRepository;

    const authService = new AuthService(mockRepo);
    const result = await authService.register({
      name: 'Ravi Prakash',
      email: 'ravi@axiouslabs.org',
      password: 'StrongPassword123!',
      targetRole: 'AI/ML Engineer',
    });

    expect(result.user.email).toBe('ravi@axiouslabs.org');
    expect(result.token).toBeDefined();
    expect(mockRepo.create).toHaveBeenCalled();
  });
});
