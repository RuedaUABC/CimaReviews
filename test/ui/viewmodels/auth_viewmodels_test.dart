import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/services/auth_service.dart';
import 'package:cimareviews/ui/viewmodels/login_viewmodel.dart';
import 'package:cimareviews/ui/viewmodels/register_user_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginViewModel', () {
    test('rejects empty credentials before calling AuthService', () async {
      final auth = _FakeAuthService();
      final viewModel = LoginViewModel(authService: auth);

      final result = await viewModel.login();

      expect(result, isFalse);
      expect(auth.loginCalls, 0);
      expect(viewModel.errorMessage, 'Ingresa correo y contrasena.');
    });

    test('logs in with valid credentials', () async {
      final auth = _FakeAuthService();
      final viewModel = LoginViewModel(authService: auth)
        ..email = 'ana@example.com'
        ..password = 'SecurePass123';

      final result = await viewModel.login();

      expect(result, isTrue);
      expect(auth.loginCalls, 1);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });

  group('RegisterUserViewModel', () {
    test('returns validation errors for invalid form', () {
      final viewModel = RegisterUserViewModel(authService: _FakeAuthService())
        ..email = 'bad-email'
        ..password = 'short'
        ..confirmPassword = 'different';

      final errors = viewModel.validateForm();

      expect(errors, contains('Ingresa tu nombre.'));
      expect(errors, contains('Ingresa un correo valido.'));
      expect(
        errors,
        contains('La contrasena debe tener al menos 8 caracteres.'),
      );
      expect(errors, contains('Las contrasenas no coinciden.'));
    });

    test('registers valid user through AuthService', () async {
      final auth = _FakeAuthService();
      final viewModel = RegisterUserViewModel(authService: auth)
        ..name = 'Ana Garcia'
        ..email = 'ana@example.com'
        ..password = 'SecurePass123'
        ..confirmPassword = 'SecurePass123';

      final result = await viewModel.register();

      expect(result, isTrue);
      expect(auth.registerCalls, 1);
      expect(viewModel.errors, isEmpty);
    });
  });
}

class _FakeAuthService extends AuthService {
  int loginCalls = 0;
  int registerCalls = 0;

  @override
  Future<Session> login(String email, String password) async {
    loginCalls++;
    return Session(
      token: 'token',
      user: _user(),
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  Future<User> register(String name, String email, String password) async {
    registerCalls++;
    return _user(name: name, email: email);
  }

  User _user({String name = 'Ana', String email = 'ana@example.com'}) {
    return User(id: 'user_1', name: name, email: email, role: UserRole());
  }
}
