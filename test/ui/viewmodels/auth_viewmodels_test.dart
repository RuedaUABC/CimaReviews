import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/login_viewmodel.dart';
import 'package:cimareviews/ui/viewmodels/register_user_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginViewModel', () {
    test('rejects empty credentials before calling UserRepository', () async {
      final repository = _FakeUserRepository();
      final viewModel = LoginViewModel(userRepository: repository);

      final result = await viewModel.login();

      expect(result, isFalse);
      expect(repository.loginCalls, 0);
      expect(viewModel.errorMessage, 'Ingresa correo y contrasena.');
    });

    test('logs in with valid credentials', () async {
      final repository = _FakeUserRepository();
      final viewModel = LoginViewModel(userRepository: repository)
        ..email = 'ana@example.com'
        ..password = 'SecurePass123';

      final result = await viewModel.login();

      expect(result, isTrue);
      expect(repository.loginCalls, 1);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });

  group('RegisterUserViewModel', () {
    test('returns validation errors for invalid form', () {
      final viewModel =
          RegisterUserViewModel(userRepository: _FakeUserRepository())
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

    test('registers valid user through UserRepository', () async {
      final repository = _FakeUserRepository();
      final viewModel = RegisterUserViewModel(userRepository: repository)
        ..name = 'Ana Garcia'
        ..email = 'ana@example.com'
        ..password = 'SecurePass123'
        ..confirmPassword = 'SecurePass123';

      final result = await viewModel.register();

      expect(result, isTrue);
      expect(repository.registerCalls, 1);
      expect(viewModel.errors, isEmpty);
    });
  });
}

class _FakeUserRepository extends UserRepository {
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
