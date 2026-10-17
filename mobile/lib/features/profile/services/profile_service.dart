import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  final ApiClient _apiClient;

  ProfileService([ApiClient? apiClient]) : _apiClient = apiClient ?? ApiClient();

  UserProfileDetail get _defaultProfile => UserProfileDetail(
    id: 'user_1',
    name: 'Alex Chen',
    email: 'alex.chen@axiouslabs.ai',
    headline: 'Senior Flutter Engineer & Mobile AI Systems Architect',
    targetRole: 'Senior Flutter Engineer',
    careerReadiness: 84,
    education: 'B.S. in Computer Science & Artificial Intelligence',
    preferences: const CareerPreferences(
      targetRole: 'Senior Flutter Engineer',
      location: 'Remote (US/EU/Global)',
      remoteOnly: true,
      expectedMinSalary: 155000,
    ),
    certifications: [
      CertificationItem(
        id: 'cert_1',
        name: 'Google Certified Associate Android Developer',
        issuer: 'Google Developers',
        issueDate: DateTime.now().subtract(const Duration(days: 300)),
        credentialUrl: 'https://developers.google.com/certification',
      ),
      CertificationItem(
        id: 'cert_2',
        name: 'AWS Certified Solutions Architect - Associate',
        issuer: 'Amazon Web Services',
        issueDate: DateTime.now().subtract(const Duration(days: 180)),
        credentialUrl: 'https://aws.amazon.com/certification',
      ),
    ],
    projects: const [
      PortfolioProject(
        id: 'proj_1',
        title: 'CareerAI Mobile Platform',
        description: 'Next-generation AI career mentor with mock interviews, ATS resume intelligence, and adaptive roadmaps.',
        repoUrl: 'https://github.com/Axious-Labs/CareerAI',
        liveDemoUrl: 'https://careerai.axiouslabs.ai',
        techStack: ['Flutter', 'Riverpod', 'Dart', 'Dio', 'Material 3'],
        starsCount: 248,
      ),
      PortfolioProject(
        id: 'proj_2',
        title: 'OpenLLM Mobile Agent Runner',
        description: 'Lightweight on-device and remote LLM orchestrator for edge neural inference and tool dispatching.',
        repoUrl: 'https://github.com/alexchen/mobile-agent-runner',
        techStack: ['Dart', 'LangChain', 'Python', 'WebSockets'],
        starsCount: 512,
      ),
    ],
  );

  Future<UserProfileDetail> fetchProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.userMe);
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return UserProfileDetail.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (_) {
      // Offline fallback
    }
    return _defaultProfile;
  }

  Future<bool> updateProfile(UserProfileDetail profile) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.userMe,
        data: profile.toJson(),
      );
      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }
}

// -----------------------------------------------------------------------------
// Riverpod State Management
// -----------------------------------------------------------------------------

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfileDetail>> {
  final ProfileService _service;

  ProfileNotifier(this._service) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _service.fetchProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile(UserProfileDetail updated) async {
    state = AsyncValue.data(updated);
    await _service.updateProfile(updated);
  }
}

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfileDetail>>((ref) {
  final service = ref.watch(profileServiceProvider);
  return ProfileNotifier(service);
});
