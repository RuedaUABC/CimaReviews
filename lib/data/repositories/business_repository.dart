import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/services/business_service.dart';
import 'package:latlong2/latlong.dart';

import '../models/business.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/user.dart';

class BusinessRepository {
  BusinessRepository({BusinessService? service, List<Business>? seedBusinesses})
    : _service = service ?? BusinessService(),
      businesses = seedBusinesses ?? _mockBusinesses();

  static final BusinessRepository instance = BusinessRepository();

  final BusinessService _service;
  final List<Business> businesses;

  Future<List<Business>> fetchBusinesses({int skip = 0, int limit = 20}) async {
    final remoteBusinesses = await _service.getBusinesses(
      skip: skip,
      limit: limit,
    );
    businesses
      ..clear()
      ..addAll(remoteBusinesses);
    return remoteBusinesses;
  }

  Future<List<Business>> searchBusinesses(String query) {
    return _service.searchBusinesses(query);
  }

  Future<Business> fetchBusiness(String id) async {
    final business = await _service.getBusiness(id);
    final index = businesses.indexWhere((item) => item.id == id);
    if (index == -1) {
      businesses.add(business);
    } else {
      businesses[index] = business;
    }
    return business;
  }

  List<Business> getLocalBusinesses() => businesses;

  Business getLocalBusiness(String id) =>
      businesses.firstWhere((business) => business.id == id);

  Future<Business> createBusiness(Business business) async {
    Business savedBusiness = business;

    try {
      savedBusiness = await _service.createBusiness(business);
      if (savedBusiness.imageUrl == null || savedBusiness.imageUrl!.isEmpty) {
        savedBusiness.imageUrl = business.imageUrl;
      }
    } catch (_) {
      savedBusiness = business;
    }

    final index = businesses.indexWhere((item) => item.id == savedBusiness.id);
    if (index == -1) {
      businesses.insert(0, savedBusiness);
    } else {
      businesses[index] = savedBusiness;
    }

    return savedBusiness;
  }

  Future<Business> addProduct(String businessId, Product product) async {
    final business = getLocalBusiness(businessId);
    final updatedProducts = [...business.products, product];

    try {
      final savedBusiness = await _service.updateBusinessProducts(
        business,
        updatedProducts,
      );
      _mergeBusiness(business, savedBusiness);
      if (business.products.isEmpty) {
        business.products = updatedProducts;
      }
    } catch (_) {
      business.products = updatedProducts;
    }

    return business;
  }

  void deleteBusiness(String id) {
    businesses.removeWhere((business) => business.id == id);
  }

  void _mergeBusiness(Business target, Business source) {
    target.id = source.id.isEmpty ? target.id : source.id;
    target.name = source.name.isEmpty ? target.name : source.name;
    target.location = source.location;
    target.avgRating = source.avgRating;
    target.products = source.products;
    target.reviews = source.reviews;
    target.categories = source.categories;
    target.description = source.description ?? target.description;
    target.imageUrl = source.imageUrl ?? target.imageUrl;
  }

  static List<Business> _mockBusinesses() {
    return [
      Business(
        owner: User(
          id: '1',
          name: 'Yamir Moreno L.',
          email: 'yamir@example.com',
          role: Seller(),
        ),
        id: '1',
        name: 'Dâ€™Volada',
        products: [
          Product(name: 'Espresso', price: 40.0),
          Product(name: 'Cappuccino', price: 50.0),
          Product(name: 'Latte', price: 65.0),
          Product(name: 'Croissant', price: 70.0),
        ],
        categories: [Category.cafeteria],
        location: const LatLng(32.5308, -116.9824),
        avgRating: 4.5,
        reviews: [
          Review(
            id: '1',
            rating: 4,
            comment: 'Muy buenos frappes',
            author: User(
              id: '3',
              name: 'Yamir M.',
              email: 'yamir@example.com',
              role: UserRole(),
            ),
          ),
          Review(
            id: '2',
            rating: 1,
            comment: 'Terrible.',
            author: User(
              id: '4',
              name: 'Alberto R.',
              email: 'alberto@example.com',
              role: UserRole(),
            ),
          ),
          Review(
            id: '3',
            rating: 5,
            comment: 'El mejor local de la UABC.',
            author: User(
              id: '5',
              name: 'Ricardo G.',
              email: 'ricardo@example.com',
              role: UserRole(),
            ),
          ),
        ],
        imageUrl:
            'https://www.figma.com/api/mcp/asset/3176bfe1-2386-427c-854b-2d3deecf250d',
      ),
      Business(
        owner: User(
          id: '2',
          name: 'Jane Smith',
          email: 'jane@example.com',
          role: Seller(),
        ),
        id: '2',
        name: 'Chick In',
        products: [
          Product(name: 'Boneless', price: 95.0),
          Product(name: 'Papas', price: 45.0),
        ],
        categories: [Category.hamburguesas],
        location: const LatLng(32.529, -116.984),
        avgRating: 4.2,
        reviews: List.empty(),
        imageUrl:
            'https://www.figma.com/api/mcp/asset/54e58995-c1ba-4d70-bc2c-6dff2c53ff22',
      ),
      Business(
        owner: User(
          id: '6',
          name: 'Tonka Owner',
          email: 'tonka@example.com',
          role: Seller(),
        ),
        id: '3',
        name: 'Tortas Tonka',
        products: [
          Product(name: 'Torta de res', price: 15.0),
          Product(name: 'Torta de pollo', price: 12.0),
        ],
        categories: [Category.mexicana],
        location: const LatLng(32.527, -116.986),
        avgRating: 4.8,
        reviews: List.empty(),
        imageUrl:
            'https://www.figma.com/api/mcp/asset/448e9e2f-d4e6-4032-8c00-540e711c7d2b',
      ),
    ];
  }
}
