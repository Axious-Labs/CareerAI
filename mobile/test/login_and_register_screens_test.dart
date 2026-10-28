import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/features/auth/presentation/login_screen.dart';
import 'package:careerai_mobile/features/auth/presentation/register_screen.dart';

void main() {
  group('Auth Presentation Screens Widget Tests', () {
    testWidgets('LoginScreen renders inputs, branding, and sign-in trigger', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Welcome to CareerAI'), findsOneWidget);
      expect(find.text('Axious Labs Career Intelligence'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('New to CareerAI? Create Account'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('LoginScreen displays validation error when email is invalid', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pump();

      final emailFinder = find.widgetWithText(TextFormField, 'Email Address');
      await tester.enterText(emailFinder, 'invalid-email');

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('RegisterScreen renders form inputs and registration CTA', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Create Profile'), findsOneWidget);
      expect(find.text('Start Your Career Journey'), findsOneWidget);
      expect(find.text('Join CareerAI by Axious Labs'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Target Career Role'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('RegisterScreen validates required fields on submission', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      await tester.pump();

      final createAccountBtn = find.text('Create Account');
      await tester.tap(createAccountBtn);
      await tester.pump();

      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Enter a valid email'), findsOneWidget);
    });
  });
}

