import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/features/resume/models/resume_model.dart';
import 'package:careerai_mobile/features/resume/services/resume_service.dart';

void main() {
  group('Resume Models & Data Serialization Tests', () {
    test('WorkExperience serialization and deserialization', () {
      final json = {
        'company': 'Axious Labs',
        'role': 'AI Engineering Intern',
        'startDate': '2025-06-01',
        'endDate': 'Present',
        'achievements': ['Built vector search pipeline', 'Enhanced token streaming'],
        'technologiesUsed': ['Python', 'FastAPI', 'LangGraph'],
      };

      final exp = WorkExperience.fromJson(json);
      expect(exp.company, 'Axious Labs');
      expect(exp.role, 'AI Engineering Intern');
      expect(exp.achievements.length, 2);
      expect(exp.technologiesUsed.contains('LangGraph'), isTrue);

      final outJson = exp.toJson();
      expect(outJson['company'], 'Axious Labs');
      expect(outJson['achievements'], contains('Built vector search pipeline'));
    });

    test('EducationItem serialization and formatting', () {
      final json = {
        'institution': 'Stanford University',
        'degree': 'Master of Science',
        'fieldOfStudy': 'Computer Science',
        'graduationYear': 2026,
        'gpa': 3.95,
      };

      final edu = EducationItem.fromJson(json);
      expect(edu.institution, 'Stanford University');
      expect(edu.degree, 'Master of Science');
      expect(edu.graduationYear, 2026);
      expect(edu.gpa, 3.95);

      final outJson = edu.toJson();
      expect(outJson['graduationYear'], 2026);
    });

    test('ProjectItem serialization with nullable URLs', () {
      final json = {
        'title': 'Autonomous Code Review Bot',
        'description': 'Scans PRs and validates test coverage',
        'techStack': ['Flutter', 'Python', 'Docker'],
        'repositoryUrl': 'https://github.com/Axious-Labs/CareerAI',
      };

      final project = ProjectItem.fromJson(json);
      expect(project.title, 'Autonomous Code Review Bot');
      expect(project.repositoryUrl, isNotNull);
      expect(project.liveDemoUrl, isNull);
    });

    test('ResumeData complete parsing and helper calculations', () {
      final json = {
        'id': 'res_test_99',
        'fileName': 'Senior_Candidate.pdf',
        'fileSizeBytes': 512000,
        'uploadedAt': '2026-05-10T12:00:00Z',
        'status': 'PARSED',
        'atsScore': 94,
        'keywordMatchPercentage': 91,
        'readabilityScore': 96,
        'summary': 'Senior Mobile and AI Engineer',
        'extractedSkills': ['Dart', 'Flutter', 'PyTorch'],
        'experiences': [
          {
            'company': 'Tech Corp',
            'role': 'Lead Engineer',
            'startDate': '2023',
            'endDate': '2026',
            'achievements': ['Led mobile release cycle'],
            'technologiesUsed': ['Flutter'],
          }
        ],
        'education': [
          {
            'institution': 'Tech Institute',
            'degree': 'B.Tech',
            'fieldOfStudy': 'CSE',
            'graduationYear': 2023,
          }
        ],
        'projects': [
          {
            'title': 'App Project',
            'description': 'Demo',
            'techStack': ['Flutter'],
          }
        ],
        'recommendedImprovements': ['Include unit test metrics'],
      };

      final resume = ResumeData.fromJson(json);
      expect(resume.id, 'res_test_99');
      expect(resume.atsScore, 94);
      expect(resume.formattedFileSize, '500.0 KB');
      expect(resume.extractedSkills.length, 3);
      expect(resume.experiences.length, 1);
      expect(resume.projects.length, 1);
    });
  });

  group('ResumeService Unit Tests', () {
    test('Default sample resume fallback contains expected attributes', () async {
      final service = ResumeService(ApiClient());
      final sample = await service.fetchCurrentResume();

      expect(sample.status, 'PARSED');
      expect(sample.atsScore, greaterThan(75));
      expect(sample.extractedSkills.isNotEmpty, isTrue);
      expect(sample.experiences.isNotEmpty, isTrue);
    });

    test('uploadAndParseResume returns enriched resume with calculated scores', () async {
      final service = ResumeService(ApiClient());
      final updated = await service.uploadAndParseResume(
        fileName: 'New_Candidate.pdf',
        fileBytes: [1, 2, 3, 4, 5],
      );

      expect(updated.fileName, 'New_Candidate.pdf');
      expect(updated.atsScore, 89);
      expect(updated.status, 'PARSED');
      expect(updated.recommendedImprovements.isNotEmpty, isTrue);
    });
  });
}
