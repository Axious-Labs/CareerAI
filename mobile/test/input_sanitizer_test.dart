import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/input_sanitizer.dart';

void main() {
  group('InputSanitizer Unit Tests', () {
    test('stripHtmlTags removes formatting tags and scripts while keeping content', () {
      expect(InputSanitizer.stripHtmlTags('<p>Senior <b>Flutter</b> Developer</p>'), 'Senior Flutter Developer');
      expect(InputSanitizer.stripHtmlTags('<script>alert("hack")</script>'), 'alert("hack")');
      expect(InputSanitizer.stripHtmlTags(null), '');
      expect(InputSanitizer.stripHtmlTags(''), '');
    });

    test('normalizeWhitespace collapses multiple whitespace variations', () {
      expect(InputSanitizer.normalizeWhitespace('   Flutter    Engineering   Lead   '), 'Flutter Engineering Lead');
      expect(InputSanitizer.normalizeWhitespace("Dart\n\nIsolates\t\tArchitecture"), 'Dart Isolates Architecture');
      expect(InputSanitizer.normalizeWhitespace(null), '');
    });

    test('maskEmail obfuscates email addresses for secure display', () {
      expect(InputSanitizer.maskEmail('alex.chen@axiouslabs.ai'), 'a***n@axiouslabs.ai');
      expect(InputSanitizer.maskEmail('me@axiouslabs.ai'), 'm*e@axiouslabs.ai');
      expect(InputSanitizer.maskEmail('a@domain.com'), 'a@domain.com');
      expect(InputSanitizer.maskEmail(''), '');
      expect(InputSanitizer.maskEmail(null), '');
    });

    test('maskPhone keeps only last four digits', () {
      expect(InputSanitizer.maskPhone('+1 (555) 123-4567'), '***-***-4567');
      expect(InputSanitizer.maskPhone('9876543210'), '***-***-3210');
      expect(InputSanitizer.maskPhone('123'), '123');
      expect(InputSanitizer.maskPhone(null), '');
    });

    test('slugify converts titles into URL-friendly kebab-case strings', () {
      expect(InputSanitizer.slugify('Senior Flutter & AI Engineer!'), 'senior-flutter-ai-engineer');
      expect(InputSanitizer.slugify('   Cloud   Architecture   101  '), 'cloud-architecture-101');
      expect(InputSanitizer.slugify(null), '');
      expect(InputSanitizer.slugify(''), '');
    });

    test('normalizeSkills trims and removes duplicates case-insensitively', () {
      final input = ['Flutter', ' Dart ', 'flutter', 'RIVERPOD', 'Riverpod', '  '];
      final normalized = InputSanitizer.normalizeSkills(input);

      expect(normalized.length, 3);
      expect(normalized, ['Flutter', 'Dart', 'RIVERPOD']);
      expect(InputSanitizer.normalizeSkills(null), isEmpty);
    });

    test('extractHashtags pulls hashtags from message captions', () {
      final tags = InputSanitizer.extractHashtags('Excited to join #AxiousLabs and build with #Flutter and #AI!');
      expect(tags, ['AxiousLabs', 'Flutter', 'AI']);
      expect(InputSanitizer.extractHashtags('No hashtags here'), isEmpty);
      expect(InputSanitizer.extractHashtags(null), isEmpty);
    });
  });
}

