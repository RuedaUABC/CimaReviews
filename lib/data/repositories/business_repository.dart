import 'package:cimareviews/data/models/role.dart';
import 'package:latlong2/latlong.dart';

import '../models/business.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/user.dart';

class BusinessRepository {
  static final BusinessRepository _instance = BusinessRepository._internal();

  BusinessRepository._internal() {
    businesses = [
      Business(
        owner: User(
          id: '1',
          name: 'Yamir Moreno L.',
          email: 'yamir@example.com',
          role: Seller(),
        ),
        id: '1',
        name: 'D’Volada',
        products: [
          Product(name: 'Espresso', price: 40.0),
          Product(name: 'Cappuccino', price: 50.0),
          Product(name: 'Latte', price: 65.0),
          Product(name: 'Croissant', price: 70.0),
        ],
        categories: [Category.cafeteria],
        location: LatLng(32.5308, -116.9824),
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
        location: LatLng(32.529, -116.984),
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
        location: LatLng(32.527, -116.986),
        avgRating: 4.8,
        reviews: List.empty(),
        imageUrl:
            'https://www.figma.com/api/mcp/asset/448e9e2f-d4e6-4032-8c00-540e711c7d2b',
      ),
    ];
  }

  static BusinessRepository get instance => _instance;

  late List<Business> businesses;

  List<Business> getBusinesses() => businesses;

  Business getBusiness(String id) => businesses.firstWhere((b) => b.id == id);

  void createBusiness(Business b) => businesses.add(b);

  void deleteBusiness(String id) => businesses.removeWhere((b) => b.id == id);
}
