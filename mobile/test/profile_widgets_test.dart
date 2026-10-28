import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/profile/models/profile_model.dart';
import 'package:careerai_mobile/features/profile/services/profile_service.dart';
import 'package:careerai_mobile/features/profile/presentation/widgets/certification_card.dart';
import 'package:careerai_mobile/features/profile/presentation/widgets/portfolio_project_card.dart';
import 'package:careerai_mobile/features/profile/presentation/profile_screen.dart';

class MockProfileService extends ProfileService {
  @override
  Future<UserProfileDetail> fetchProfile() async {
    return UserProfileDetail(
      id: 'mock_u1',
      name: 'Alex Chen',
      email: 'alex@axiouslabs.ai',
      headline: 'Senior Flutter Engineer',
      targetRole: 'Senior Flutter Engineer',
      careerReadiness: 84,
      education: 'B.S. in Computer Science',
      preferences: const CareerPreferences(
        targetRole: 'Senior Flutter Engineer',
        location: 'Remote',
        expectedMinSalary: 150000,
      ),
      certifications: [
        CertificationItem(
          id: 'mock_c1',
          name: 'Google Cloud Certified',
          issuer: 'Google Cloud',
          issueDate: DateTime(2026, 4, 15),
          credentialUrl: 'https://cloud.google.com',
        ),
      ],
      projects: const [
        PortfolioProject(
          id: 'mock_p1',
          title: 'CareerAI Mobile Platform',
          description: 'AI Career platform app',
          techStack: ['Flutter', 'Riverpod'],
          starsCount: 200,
        ),
      ],
    );
  }
}
//1. Mock Profile Service - Created for dependency injection
//2. CertificationCard widget tests - Verify correct display of certification details
//3. PortfolioProjectCard widget tests - Verify correct display of project details
//4. ProfileScreen widget tests - Verify screen renders with correct tabs and data loading
//5. Riverpod ProviderScope - Used for testing state management in the profile screen


void main() {
  group('Profile Widgets Unit Tests', () {
    testWidgets('CertificationCard renders cert details and issuer accurately', (tester) async {
      final testCert = CertificationItem(
        id: 'cert_tile_1',
        name: 'Google Professional Cloud Architect',
        issuer: 'Google Cloud',
        issueDate: DateTime(2026, 4, 15),
        credentialUrl: 'https://cloud.google.com/certification',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CertificationCard(item: testCert),
          ),
        ),
      );

      expect(find.text('Google Professional Cloud Architect'), findsOneWidget);
      expect(find.text('Google Cloud'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });

    testWidgets('PortfolioProjectCard renders title, description, tech stack and star count', (tester) async {
      const testProject = PortfolioProject(
        id: 'proj_tile_1',
        title: 'CareerAI Mobile Flutter App',
        description: 'Complete cross platform AI career assistant',
        techStack: ['Flutter', 'Riverpod', 'Dart'],
        starsCount: 142,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PortfolioProjectCard(project: testProject),
          ),
        ),
      );

      expect(find.text('CareerAI Mobile Flutter App'), findsOneWidget);
      expect(find.text('Complete cross platform AI career assistant'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Riverpod'), findsOneWidget);
      expect(find.text('142'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders inside ProviderScope with tabs and career readiness', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileServiceProvider.overrideWithValue(MockProfileService()),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Career Profile'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Certificates'), findsOneWidget);
      expect(find.text('Career Readiness'), findsOneWidget);
    });
  });
}
