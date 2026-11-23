import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/resume/models/resume_model.dart';
import 'package:careerai_mobile/features/resume/services/resume_service.dart';
import 'package:careerai_mobile/features/resume/presentation/resume_screen.dart';

class MockResumeService extends ResumeService {
  MockResumeService() : super(ApiClient());

  @override
  Future<ResumeData> fetchCurrentResume() async {
    return ResumeService.defaultSampleResume;
  }
}

void main() {
  group('ResumeScreen Widget Tests', () {
    testWidgets('ResumeScreen renders AppBar title, upload banner, and re-analyze action', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            resumeServiceProvider.overrideWithValue(MockResumeService()),
          ],
          child: const MaterialApp(
            home: ResumeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Resume Intelligence'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Upload Updated Resume'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
      expect(find.text('ATS Resume Compatibility'), findsOneWidget);
    });

    testWidgets('ResumeScreen displays extracted skills and scores from default profile', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            resumeServiceProvider.overrideWithValue(MockResumeService()),
          ],
          child: const MaterialApp(
            home: ResumeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('ATS Resume Compatibility'), findsOneWidget);
      expect(find.text('Extracted Technical Skills'), findsOneWidget);
      expect(find.text('Python'), findsWidgets);
    });
  });
}
