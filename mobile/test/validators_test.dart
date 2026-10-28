import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/utils/validators.dart';

void main() {
  group('AppValidators - Form Validation Unit Tests', () {
    test('email validator verifies standard and invalid email addresses', () {
      expect(AppValidators.email(null), 'Email address is required');
      expect(AppValidators.email(''), 'Email address is required');
      expect(AppValidators.email('   '), 'Email address is required');
      expect(AppValidators.email('plainaddress'), 'Please enter a valid email address');
      expect(AppValidators.email('user@'), 'Please enter a valid email address');
      expect(AppValidators.email('@domain.com'), 'Please enter a valid email address');
      expect(AppValidators.email('user@domain'), 'Please enter a valid email address');

      expect(AppValidators.email('alex.chen@axiouslabs.ai'), isNull);
      expect(AppValidators.email('test_dev123@sub.domain.org'), isNull);
    });

    test('password validator verifies length constraint', () {
      expect(AppValidators.password(null), 'Password is required');
      expect(AppValidators.password(''), 'Password is required');
      expect(AppValidators.password('12345'), 'Password must be at least 6 characters');
      expect(AppValidators.password('123456'), isNull);
      expect(AppValidators.password('SuperSecurePass123!'), isNull);
      expect(AppValidators.password('short', minLength: 8), 'Password must be at least 8 characters');
    });

    test('requiredField validates null and empty whitespace values', () {
      expect(AppValidators.requiredField(null), 'This field is required');
      expect(AppValidators.requiredField(''), 'This field is required');
      expect(AppValidators.requiredField('   '), 'This field is required');
      expect(AppValidators.requiredField(null, 'Target Role'), 'Target Role is required');
      expect(AppValidators.requiredField('Flutter Engineer', 'Target Role'), isNull);
    });

    test('url validator verifies protocol and domain shapes', () {
      expect(AppValidators.url(null), isNull);
      expect(AppValidators.url(''), isNull);
      expect(AppValidators.url(null, isRequired: true), 'URL is required');

      expect(AppValidators.url('invalid-url'), 'Please enter a valid URL');
      expect(AppValidators.url('http://'), 'Please enter a valid URL');

      expect(AppValidators.url('https://github.com/Axious-Labs/CareerAI'), isNull);
      expect(AppValidators.url('http://localhost:3000'), isNull);
      expect(AppValidators.url('flutter.dev'), isNull);
    });

    test('number validator parses integers, doubles, and checks bounds', () {
      expect(AppValidators.number(null), 'Value is required');
      expect(AppValidators.number('abc'), 'Value must be a valid number');
      expect(AppValidators.number('150000'), isNull);
      expect(AppValidators.number('45.5'), isNull);

      expect(AppValidators.number('50', min: 100), 'Value must be at least 100');
      expect(AppValidators.number('250', max: 200), 'Value cannot exceed 200');
      expect(AppValidators.number('150', min: 100, max: 200), isNull);
      expect(
        AppValidators.number('20', min: 50, fieldName: 'Expected Salary'),
        'Expected Salary must be at least 50',
      );
    });

    test('minLength and maxLength validate character count constraints', () {
      expect(AppValidators.minLength('ab', 3, 'Bio'), 'Bio must be at least 3 characters');
      expect(AppValidators.minLength('abc', 3, 'Bio'), isNull);
      expect(AppValidators.minLength('abcd', 3, 'Bio'), isNull);

      expect(AppValidators.maxLength('toolongstring', 5, 'Tag'), 'Tag cannot exceed 5 characters');
      expect(AppValidators.maxLength('short', 5, 'Tag'), isNull);
      expect(AppValidators.maxLength(null, 5, 'Tag'), isNull);
    });

    test('phone validator verifies international phone digits format', () {
      expect(AppValidators.phone(null), isNull);
      expect(AppValidators.phone(null, isRequired: true), 'Phone number is required');
      expect(AppValidators.phone('123'), 'Please enter a valid phone number');
      expect(AppValidators.phone('abc-def-ghij'), 'Please enter a valid phone number');

      expect(AppValidators.phone('+1 (555) 123-4567'), isNull);
      expect(AppValidators.phone('9876543210'), isNull);
    });
  });
}

