import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/product.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/add_product_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('AddProductViewModel', () {
    test('returns validation errors for an incomplete form', () {
      final owner = _user('owner_1');
      final viewModel = AddProductViewModel(
        business: _business(owner: owner),
        businessRepository: _FakeBusinessRepository(),
        userRepository: _FakeUserRepository(user: owner),
      );

      final errors = viewModel.validateForm();

      expect(errors, contains('Ingresa el nombre del producto.'));
      expect(errors, contains('Ingresa un precio valido.'));
    });

    test('blocks users that are not the business owner', () async {
      final owner = _user('owner_1');
      final repository = _FakeBusinessRepository();
      final viewModel =
          AddProductViewModel(
              business: _business(owner: owner),
              businessRepository: repository,
              userRepository: _FakeUserRepository(user: _user('user_2')),
            )
            ..updateName('Latte')
            ..updatePrice('65');

      final result = await viewModel.addProduct();

      expect(result, isFalse);
      expect(repository.addCalls, 0);
      expect(viewModel.errors, [
        'Solo el dueno del negocio puede agregar productos.',
      ]);
    });

    test('adds a product for the business owner', () async {
      final owner = _user('owner_1');
      final repository = _FakeBusinessRepository();
      final business = _business(owner: owner);
      final viewModel =
          AddProductViewModel(
              business: business,
              businessRepository: repository,
              userRepository: _FakeUserRepository(user: owner),
            )
            ..updateName('Latte')
            ..updatePrice('65.50')
            ..updateDescription('Cafe con leche');

      final result = await viewModel.addProduct();

      expect(result, isTrue);
      expect(repository.addCalls, 1);
      expect(repository.addedProduct?.name, 'Latte');
      expect(repository.addedProduct?.price, 65.5);
      expect(repository.addedProduct?.description, 'Cafe con leche');
      expect(viewModel.errors, isEmpty);
    });
  });
}

class _FakeBusinessRepository extends BusinessRepository {
  int addCalls = 0;
  Product? addedProduct;

  @override
  Future<Business> addProduct(String businessId, Product product) async {
    addCalls++;
    addedProduct = product;
    return _business(owner: _user('owner_1'), products: [product]);
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

Business _business({required User owner, List<Product>? products}) {
  return Business(
    id: 'biz_1',
    name: 'Cafe Cima',
    owner: owner,
    location: const LatLng(32.52, -116.98),
    avgRating: 0,
    products: products ?? [],
    reviews: [],
    categories: [Category.cafeteria],
  );
}

User _user(String id) {
  return User(
    id: id,
    name: 'Usuario $id',
    email: '$id@example.com',
    role: Seller(),
  );
}
