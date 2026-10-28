import 'package:flutter_test/flutter_test.dart';
import 'package:careerai_mobile/core/network/api_client.dart';
import 'package:careerai_mobile/core/constants/api_endpoints.dart';

void main() {
  group('ApiClient Configuration Unit Tests', () {
    test('ApiClient singleton instance returns consistent configuration', () {
      final client1 = ApiClient();
      final client2 = ApiClient();
      expect(identical(client1, client2), isTrue);

      expect(client1.dio.options.baseUrl, ApiEndpoints.baseUrl);
      expect(client1.dio.options.headers['Content-Type'], 'application/json');
      expect(client1.dio.options.headers['Accept'], 'application/json');
    });

    test('ApiClient timeouts are set within 5 seconds threshold', () {
      final client = ApiClient();
      expect(client.dio.options.connectTimeout, const Duration(seconds: 5));
      expect(client.dio.options.receiveTimeout, const Duration(seconds: 5));
    });
  });
}

