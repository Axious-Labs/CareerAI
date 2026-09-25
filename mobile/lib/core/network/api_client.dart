import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _cachedToken;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_cachedToken == null) {
            _cachedToken = await _storage.read(key: 'jwt_token');
          }
          if (_cachedToken != null) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Log network error
          print('[ApiClient Error] ${e.requestOptions.path}: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: 'jwt_token');
  }

  bool get isAuthenticated => _cachedToken != null;
}
