import '../models/business.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'api_service.dart';

class BusinessService {
  BusinessService({ApiService? api}) : _api = api ?? ApiService.instance;

  final ApiService _api;

  Future<List<Business>> getBusinesses({int skip = 0, int limit = 20}) async {
    final data = await _api.get(
      '/api/v1/businesses/',
      queryParameters: {'skip': skip, 'limit': limit},
    );

    return _parseBusinessList(data);
  }

  Future<List<Business>> searchBusinesses(String query) async {
    final data = await _api.get(
      '/api/v1/businesses/search',
      queryParameters: {'q': query.trim()},
    );

    return _parseBusinessList(data);
  }

  Future<Business> getBusiness(String id) async {
    final data = await _api.get('/api/v1/businesses/$id');

    return Business.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<Business> createBusiness(Business business) async {
    final data = await _api.post(
      '/api/v1/businesses/',
      body: {
        'name': business.name.trim(),
        'owner_id': business.owner.id,
        'location': {
          'lat': business.location.latitude,
          'lng': business.location.longitude,
        },
        'categories': business.categories.map(categoryToApiName).toList(),
        if (business.description != null &&
            business.description!.trim().isNotEmpty)
          'description': business.description!.trim(),
        'products': business.products
            .map(
              (product) => {
                'name': product.name,
                'price': product.price,
                if (product.description != null &&
                    product.description!.trim().isNotEmpty)
                  'description': product.description,
              },
            )
            .toList(),
      },
    );

    return Business.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<Business> updateBusinessProducts(
    Business business,
    List<Product> products,
  ) async {
    final data = await _api.put(
      '/api/v1/businesses/${business.id}',
      body: {
        'name': business.name.trim(),
        'location': {
          'lat': business.location.latitude,
          'lng': business.location.longitude,
        },
        'categories': business.categories.map(categoryToApiName).toList(),
        if (business.description != null &&
            business.description!.trim().isNotEmpty)
          'description': business.description!.trim(),
        'products': products.map((product) => product.toJson()).toList(),
      },
    );

    return Business.fromJson(Map<String, dynamic>.from(data as Map));
  }

  List<Business> _parseBusinessList(dynamic data) {
    if (data is! List) {
      return <Business>[];
    }

    return data
        .whereType<Map>()
        .map(
          (business) => Business.fromJson(Map<String, dynamic>.from(business)),
        )
        .toList();
  }
}
