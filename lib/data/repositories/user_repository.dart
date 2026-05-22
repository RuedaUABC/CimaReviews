import '../models/session.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserRepository {
  UserRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<Session> login(String email, String password) {
    return _authService.login(email, password);
  }

  Future<User> register(String name, String email, String password) {
    return _authService.register(name, email, password);
  }

  Future<void> logout() {
    return _authService.logout();
  }

  bool isAuthenticated() => _authService.isAuthenticated();

  Session? getCurrentSession() => _authService.getCurrentSession();
}
