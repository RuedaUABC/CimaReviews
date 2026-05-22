import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('HomeViewModel', () {
    test('loads businesses and exposes categories', () async {
      final viewModel = HomeViewModel(
        businessRepository: _FakeBusinessRepository(
          items: [
            _business('1', 'Cafe Central', [Category.cafeteria]),
            _business('2', 'Tacos Baja', [Category.tacos, Category.mexicana]),
          ],
        ),
      );

      await viewModel.loadBusinesses();

      expect(viewModel.error, isNull);
      expect(viewModel.businesses.map((business) => business.name), [
        'Cafe Central',
        'Tacos Baja',
      ]);
      expect(viewModel.categories, contains(Category.cafeteria));
      expect(viewModel.categories, contains(Category.tacos));
    });

    test('filters businesses by selected category', () async {
      final viewModel = HomeViewModel(
        businessRepository: _FakeBusinessRepository(
          items: [
            _business('1', 'Cafe Central', [Category.cafeteria]),
            _business('2', 'Tacos Baja', [Category.tacos]),
          ],
        ),
      );

      await viewModel.loadBusinesses();
      viewModel.selectCategory(Category.tacos);

      expect(viewModel.businesses, hasLength(1));
      expect(viewModel.businesses.single.name, 'Tacos Baja');
    });

    test(
      'searches businesses when query has at least two characters',
      () async {
        final repository = _FakeBusinessRepository(
          items: [
            _business('1', 'Cafe Central', [Category.cafeteria]),
          ],
          searchResults: [
            _business('2', 'Tacos Baja', [Category.tacos]),
          ],
        );
        final viewModel = HomeViewModel(businessRepository: repository);

        await viewModel.loadBusinesses();
        viewModel.updateSearchQuery('ta');
        await Future<void>.delayed(const Duration(milliseconds: 400));

        expect(repository.lastSearchQuery, 'ta');
        expect(viewModel.isSearching, isFalse);
        expect(viewModel.businesses.single.name, 'Tacos Baja');
      },
    );
  });
}

class _FakeBusinessRepository extends BusinessRepository {
  _FakeBusinessRepository({required this.items, List<Business>? searchResults})
    : searchResults = searchResults ?? items;

  final List<Business> items;
  final List<Business> searchResults;
  String? lastSearchQuery;

  @override
  Future<List<Business>> fetchBusinesses({int skip = 0, int limit = 20}) async {
    return items;
  }

  @override
  Future<List<Business>> searchBusinesses(String query) async {
    lastSearchQuery = query;
    return searchResults;
  }
}

Business _business(String id, String name, List<Category> categories) {
  return Business(
    id: id,
    name: name,
    owner: User(id: 'owner_$id', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 4.5,
    products: [],
    reviews: [],
    categories: categories,
    description: '$name description',
  );
}
