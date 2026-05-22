import '../models/session.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class AuthService {
  AuthService({ApiService? api, LocalStorageService? storage})
    : _api = api ?? ApiService.instance,
      _storage = storage ?? LocalStorageService.instance {
    final token = _storage.getToken();
    if (token != null) {
      _api.setToken(token);
    }
  }

  final ApiService _api;
  final LocalStorageService _storage;

  Future<Session> login(String email, String password) async {
    final data = await _api.post(
      '/api/v1/auth/login',
      body: {'email': email.trim(), 'password': password},
    );
    final session = Session.fromJson(Map<String, dynamic>.from(data as Map));
    await _saveSession(session);
    return session;
  }

  Future<User> register(String name, String email, String password) async {
    final data = await _api.post(
      '/api/v1/auth/register',
      body: {'name': name.trim(), 'email': email.trim(), 'password': password},
    );
    return User.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> logout() async {
    if (isAuthenticated()) {
      try {
        await _api.post('/api/v1/auth/logout');
      } on ApiException {
        // Local logout should still clear the stale token.
      }
    }

    _api.clearToken();
    await _storage.clearAuthData();
  }

  Future<Session> refreshToken(String refreshToken) async {
    final data = await _api.post(
      '/api/v1/auth/refresh',
      body: {'refresh_token': refreshToken},
    );
    final session = Session.fromJson(Map<String, dynamic>.from(data as Map));
    await _saveSession(session);
    return session;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _api.post(
      '/api/v1/auth/change-password',
      body: {'old_password': oldPassword, 'new_password': newPassword},
    );
  }

  Future<void> forgotPassword(String email) async {
    await _api.post(
      '/api/v1/auth/forgot-password',
      body: {'email': email.trim()},
    );
  }

  bool isAuthenticated() {
    return _storage.getSession()?.isValid() ?? false;
  }

  Session? getCurrentSession() => _storage.getSession();

  Future<void> _saveSession(Session session) async {
    _api.setToken(session.token);
    await _storage.setSession(session);
  }
}
