import 'package:flutter_test/flutter_test.dart';
import 'package:penta_crew/core/network/mock/mock_server.dart';

void main() {
  late MockServer server;

  MockResponse call(String method, String path, String? bearer) =>
      server.handle(method: method, path: path, bearer: bearer);

  String signIn() {
    final response = server.handle(
      method: 'POST',
      path: '/login',
      body: {'email': 'nadia@example.com', 'password': 'password1'},
    );
    return (response.body['data'] as Map)['token'] as String;
  }

  setUp(() => server = MockServer());

  test('token from a previous process resumes the persona', () {
    final token = signIn();
    final restarted = MockServer();
    final response = restarted.handle(
      method: 'GET',
      path: '/me',
      bearer: token.replaceAll(RegExp(r'-\d+$'), '-1'),
    );
    expect(response.status, 200);
  });

  test('signed-out token stays 401 in the same process', () {
    final token = signIn();
    expect(call('POST', '/logout', token).status, 200);
    expect(call('GET', '/me', token).status, 401);
  });

  test('unknown token shape is 401', () {
    expect(call('GET', '/me', 'garbage').status, 401);
    expect(call('GET', '/me', 'mock-token-abc-1').status, 401);
  });
}
