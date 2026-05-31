import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/product.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/data/services/business_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('BusinessRepository', () {
    test('adds a product to the local business after updating API', () async {
      final business = _business();
      final service = _FakeBusinessService();
      final repository = BusinessRepository(
        service: service,
        seedBusinesses: [business],
      );
      final product = Product(
        name: 'Latte',
        price: 65.5,
        description: 'Cafe con leche',
      );

      final updatedBusiness = await repository.addProduct(business.id, product);

      expect(service.updatedBusinessId, business.id);
      expect(service.sentProducts.single.name, 'Latte');
      expect(updatedBusiness.products, hasLength(1));
      expect(updatedBusiness.products.single.price, 65.5);
      expect(business.products.single.description, 'Cafe con leche');
    });
  });
}

class _FakeBusinessService extends BusinessService {
  String? updatedBusinessId;
  List<Product> sentProducts = [];

  @override
  Future<Business> updateBusinessProducts(
    Business business,
    List<Product> products,
  ) async {
    updatedBusinessId = business.id;
    sentProducts = products;
    return _business(products: products);
  }
}

Business _business({List<Product>? products}) {
  return Business(
    id: 'biz_1',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 0,
    products: products ?? [],
    reviews: [],
    categories: [Category.cafeteria],
  );
}
