import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_model.dart';
import '../data/auth_repository.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo)
      : super(
          AuthState(
            user: UserModel(
              id: 'usr_mock_alex',
              name: 'Alex Chen',
              email: 'alex.chen@university.edu',
              targetRole: 'AI/ML Engineer',
              careerReadiness: 68,
            ),
          ),
        );

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repo.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String targetRole) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repo.register(name, email, password, targetRole);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthState();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
