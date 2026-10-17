import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/profile/models/profile_model.dart';
import 'package:careerai_mobile/features/profile/services/profile_service.dart';

void main() {
  group('Profile Models Tests', () {
    test('CertificationItem serializes and deserializes accurately', () {
      final cert = CertificationItem(
        id: 'c1',
        name: 'Google Flutter Certified',
        issuer: 'Google',
        issueDate: DateTime(2026, 5, 20),
        credentialUrl: 'https://credentials.google.com/cert/123',
      );

      final json = cert.toJson();
      expect(json['name'], 'Google Flutter Certified');
      expect(json['issuer'], 'Google');

      final parsed = CertificationItem.fromJson(json);
      expect(parsed.id, cert.id);
      expect(parsed.name, cert.name);
      expect(parsed.credentialUrl, cert.credentialUrl);
    });

    test('PortfolioProject handles tech stack lists and stars count', () {
      const proj = PortfolioProject(
        id: 'p1',
        title: 'CareerAI Mobile',
        description: 'AI Career platform app',
        techStack: ['Flutter', 'Riverpod', 'Dart'],
        starsCount: 350,
      );

      final json = proj.toJson();
      expect(json['starsCount'], 350);
      expect((json['techStack'] as List).length, 3);

      final parsed = PortfolioProject.fromJson(json);
      expect(parsed.id, proj.id);
      expect(parsed.title, proj.title);
      expect(parsed.starsCount, 350);
      expect(parsed.techStack, contains('Riverpod'));
    });

    test('CareerPreferences serializes and deserializes correctly', () {
      const prefs = CareerPreferences(
        targetRole: 'Staff Mobile Engineer',
        location: 'Remote',
        remoteOnly: true,
        expectedMinSalary: 180000,
        currency: 'USD',
      );

      final json = prefs.toJson();
      expect(json['expectedMinSalary'], 180000);

      final parsed = CareerPreferences.fromJson(json);
      expect(parsed.targetRole, prefs.targetRole);
      expect(parsed.expectedMinSalary, 180000);
      expect(parsed.remoteOnly, true);
    });

    test('UserProfileDetail copyWith updates specific fields properly', () {
      final user = UserProfileDetail(
        id: 'u1',
        name: 'Alex Chen',
        email: 'alex@test.com',
        headline: 'Mobile Engineer',
        targetRole: 'Senior Flutter Engineer',
        careerReadiness: 85,
        education: 'BS CS',
        preferences: const CareerPreferences(
          targetRole: 'Senior Flutter Engineer',
          location: 'Remote',
          expectedMinSalary: 150000,
        ),
      );

      final updated = user.copyWith(careerReadiness: 92, headline: 'Staff Engineer');
      expect(updated.careerReadiness, 92);
      expect(updated.headline, 'Staff Engineer');
      expect(updated.name, user.name);
      expect(updated.email, user.email);
    });
  });

  group('ProfileService & Notifier Tests', () {
    test('ProfileService returns valid default profile', () async {
      final service = ProfileService();
      final profile = await service.fetchProfile();

      expect(profile.name.isNotEmpty, true);
      expect(profile.certifications.isNotEmpty, true);
      expect(profile.projects.isNotEmpty, true);
    });

    test('ProfileNotifier loads profile data into state and updates smoothly', () async {
      final service = ProfileService();
      final notifier = ProfileNotifier(service);

      await notifier.loadProfile();
      expect(notifier.state.hasValue, true);

      final current = notifier.state.value!;
      final modified = current.copyWith(headline: 'Updated Test Headline');

      await notifier.updateProfile(modified);
      expect(notifier.state.value!.headline, 'Updated Test Headline');
    });
  });
}
