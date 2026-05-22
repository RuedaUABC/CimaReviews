import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/user_profile_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileViewModel', () {
    test('shows current user name and role from active session', () {
      final viewModel = UserProfileViewModel(
        userRepository: _FakeUserRepository(
          session: Session(
            token: 'token',
            user: User(
              id: 'user_1',
              name: 'Ana Garcia',
              email: 'ana@example.com',
              role: Seller(),
            ),
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          ),
        ),
      );

      viewModel.loadCurrentUser();

      expect(viewModel.error, isNull);
      expect(viewModel.displayName, 'Ana Garcia');
      expect(viewModel.displayRole, 'Vendedor');
    });

    test('reports missing active session', () {
      final viewModel = UserProfileViewModel(
        userRepository: _FakeUserRepository(session: null),
      );

      viewModel.loadCurrentUser();

      expect(viewModel.user, isNull);
      expect(viewModel.error, 'No hay una sesion activa.');
      expect(viewModel.displayName, 'Usuario');
      expect(viewModel.displayRole, 'Cliente');
    });
  });
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository({required this.session});

  final Session? session;

  @override
  Session? getCurrentSession() => session;
}
