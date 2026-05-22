import '../models/session.dart';
import '../models/user.dart';

class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();

  Session? _session;
  User? _user;
  String? _token;

  Future<void> setToken(String token) async {
    _token = token;
  }

  String? getToken() => _token;

  Future<void> setUser(User user) async {
    _user = user;
  }

  User? getUser() => _user;

  Future<void> setSession(Session session) async {
    _session = session;
    _user = session.user;
    _token = session.token;
  }

  Session? getSession() => _session;

  Future<void> clear() async {
    _session = null;
    _user = null;
    _token = null;
  }

  Future<void> clearAuthData() => clear();
}
