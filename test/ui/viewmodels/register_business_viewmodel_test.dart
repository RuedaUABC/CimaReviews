import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/register_business_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterBusinessViewModel', () {
    test('returns validation errors for an incomplete form', () {
      final viewModel = RegisterBusinessViewModel(
        businessRepository: _FakeBusinessRepository(),
        userRepository: _FakeUserRepository(user: _seller()),
      );

      final errors = viewModel.validateForm();

      expect(errors, contains('Ingresa el nombre del negocio.'));
      expect(errors, contains('Selecciona una categoria.'));
      expect(errors, contains('Ingresa una latitud valida.'));
      expect(errors, contains('Ingresa una longitud valida.'));
    });

    test('blocks users without create business permission', () async {
      final repository = _FakeBusinessRepository();
      final viewModel =
          RegisterBusinessViewModel(
              businessRepository: repository,
              userRepository: _FakeUserRepository(user: _customer()),
            )
            ..updateName('Cafe Cima')
            ..selectCategory(Category.cafeteria)
            ..updateLatitude('32.5308')
            ..updateLongitude('-116.9824');

      final result = await viewModel.registerBusiness();

      expect(result, isFalse);
      expect(repository.createCalls, 0);
      expect(viewModel.errors, ['No tienes permiso para registrar negocios.']);
    });

    test('creates a business with the current seller as owner', () async {
      final repository = _FakeBusinessRepository();
      final seller = _seller();
      final viewModel =
          RegisterBusinessViewModel(
              businessRepository: repository,
              userRepository: _FakeUserRepository(user: seller),
            )
            ..updateName('Cafe Cima')
            ..updateDescription('Cafe dentro del campus')
            ..selectCategory(Category.cafeteria)
            ..updateLatitude('32.5308')
            ..updateLongitude('-116.9824')
            ..updateImageUrl('https://example.com/cafe.jpg');

      final result = await viewModel.registerBusiness();

      expect(result, isTrue);
      expect(repository.createCalls, 1);
      expect(repository.createdBusiness?.name, 'Cafe Cima');
      expect(repository.createdBusiness?.owner.id, seller.id);
      expect(repository.createdBusiness?.categories, [Category.cafeteria]);
      expect(repository.createdBusiness?.location.latitude, 32.5308);
      expect(repository.createdBusiness?.location.longitude, -116.9824);
      expect(
        repository.createdBusiness?.imageUrl,
        'https://example.com/cafe.jpg',
      );
      expect(viewModel.errors, isEmpty);
    });
  });
}

class _FakeBusinessRepository extends BusinessRepository {
  int createCalls = 0;
  Business? createdBusiness;

  @override
  Future<Business> createBusiness(Business business) async {
    createCalls++;
    createdBusiness = business;
    return business;
  }
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository({required this.user});

  final User? user;

  @override
  Session? getCurrentSession() {
    if (user == null) {
      return null;
    }

    return Session(
      token: 'token',
      user: user!,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

User _seller() {
  return User(
    id: 'seller_1',
    name: 'Sofia Seller',
    email: 'seller@example.com',
    role: Seller(),
  );
}

User _customer() {
  return User(
    id: 'user_1',
    name: 'Ana Garcia',
    email: 'ana@example.com',
    role: UserRole(),
  );
}
