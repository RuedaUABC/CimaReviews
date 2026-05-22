import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/services/business_service.dart';
import 'package:cimareviews/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('HomeViewModel', () {
    test('loads businesses and exposes categories', () async {
      final viewModel = HomeViewModel(
        businessService: _FakeBusinessService(
          businesses: [
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
        businessService: _FakeBusinessService(
          businesses: [
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
        final service = _FakeBusinessService(
          businesses: [
            _business('1', 'Cafe Central', [Category.cafeteria]),
          ],
          searchResults: [
            _business('2', 'Tacos Baja', [Category.tacos]),
          ],
        );
        final viewModel = HomeViewModel(businessService: service);

        await viewModel.loadBusinesses();
        viewModel.updateSearchQuery('ta');
        await Future<void>.delayed(const Duration(milliseconds: 400));

        expect(service.lastSearchQuery, 'ta');
        expect(viewModel.isSearching, isFalse);
        expect(viewModel.businesses.single.name, 'Tacos Baja');
      },
    );
  });
}

class _FakeBusinessService extends BusinessService {
  _FakeBusinessService({
    required this.businesses,
    List<Business>? searchResults,
  }) : searchResults = searchResults ?? businesses;

  final List<Business> businesses;
  final List<Business> searchResults;
  String? lastSearchQuery;

  @override
  Future<List<Business>> getBusinesses({int skip = 0, int limit = 20}) async {
    return businesses;
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
