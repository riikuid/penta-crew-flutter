import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the API token lives. Abstract so tests can swap in an in-memory fake.
abstract interface class SessionStorage {
  Future<String?> readToken();
  Future<void> saveToken(String token);
  Future<void> clear();
}

/// Keychain (iOS) / Keystore-backed (Android) storage with an in-memory cache,
/// so the interceptor does not hit the platform channel on every request.
class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'session.token';

  final FlutterSecureStorage _storage;
  String? _cached;
  bool _loaded = false;

  @override
  Future<String?> readToken() async {
    if (!_loaded) {
      _cached = await _storage.read(key: _tokenKey);
      _loaded = true;
    }
    return _cached;
  }

  @override
  Future<void> saveToken(String token) async {
    _cached = token;
    _loaded = true;
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clear() async {
    _cached = null;
    _loaded = true;
    await _storage.delete(key: _tokenKey);
  }
}

/// For tests and the demo/offline mode.
class InMemorySessionStorage implements SessionStorage {
  String? _token;

  @override
  Future<String?> readToken() async => _token;

  @override
  Future<void> saveToken(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}
