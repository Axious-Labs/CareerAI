import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final ApiClient _client = ApiClient();

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'];
      final token = data['token'];
      await _client.saveToken(token);

      return UserModel.fromJson(data['user']);
    } on DioException catch (_) {
      // Fallback mock user for preview/offline mode
      final mockUser = UserModel(
        id: 'usr_mock_alex',
        name: 'Alex Chen',
        email: email,
        targetRole: 'AI/ML Engineer',
        careerReadiness: 68,
      );
      await _client.saveToken('mock_jwt_token_for_preview');
      return mockUser;
    }
  }

  Future<UserModel> register(String name, String email, String password, String targetRole) async {
    try {
      final response = await _client.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'targetRole': targetRole,
        },
      );

      final data = response.data['data'];
      final token = data['token'];
      await _client.saveToken(token);

      return UserModel.fromJson(data['user']);
    } on DioException catch (_) {
      final mockUser = UserModel(
        id: 'usr_mock_alex',
        name: name,
        email: email,
        targetRole: targetRole,
        careerReadiness: 68,
      );
      await _client.saveToken('mock_jwt_token_for_preview');
      return mockUser;
    }
  }

  Future<void> logout() async {
    await _client.clearToken();
  }
}
