import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'alex.chen@university.edu');
  final _passwordController = TextEditingController(text: 'Password123!');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref.read(authStateProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (success && mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: AppColors.accent),
                  const SizedBox(height: 16),
                  const Text('Welcome to CareerAI', style: AppTextStyles.h1, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Axious Labs Career Intelligence', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 36),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, color: AppColors.accent)),
                    validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline, color: AppColors.accent)),
                    validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 chars' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    child: authState.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                        : const Text('Sign In'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('New to CareerAI? Create Account', style: TextStyle(color: AppColors.accentLight)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
