import 'package:cimareviews/data/models/role.dart';
import 'package:latlong2/latlong.dart';
import '../models/business.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/category.dart';
import '../models/user.dart';

class BusinessRepository {
  // Instancia única (singleton)
  static final BusinessRepository _instance = BusinessRepository._internal();

  // Constructor privado
  BusinessRepository._internal() {
    // Inicialización de datos de ejemplo
    businesses = [
      Business(
        owner: User(id: '1', name: 'John Doe', email: 'john@example.com', role: Admin()),
        id: '1',
        name: 'Dvolada',
        products: [
          Product(name: 'Café americano', price: 3.0),
          Product(name: 'Café con leche', price: 3.5),
        ],
        categories: [Category.CAFETERIA],
        location: LatLng(40.7128, -74.0060),
        avgRating: 4.5,
        reviews: [
          Review(
            id: '1',
            rating: 5,
            comment: 'Excelente café y ambiente',
            author: User(id: '3', name: 'Alice', email: 'alice@example.com', role: Admin()),
          )
        ],
      ),
      Business(
        owner: User(id: '2', name: 'Jane Smith', email: 'jane@example.com', role: Admin()),
        id: '2',
        name: 'Tortas tonka',
        products: [
          Product(name: 'Torta de res', price: 15.0),
          Product(name: 'Torta de pollo', price: 12.0),
        ],
        categories: [Category.MEXICANA],
        location: LatLng(34.0522, -118.2437),
        avgRating: 4.0,
        reviews: List.empty(),
      ),
    ];
  }

  // Getter público para acceder a la instancia
  static BusinessRepository get instance => _instance;

  // Lista de negocios
  late List<Business> businesses;

  // Métodos CRUD
  List<Business> getBusinesses() => businesses;

  Business getBusiness(String id) =>
      businesses.firstWhere((b) => b.id == id);

  void createBusiness(Business b) => businesses.add(b);

  void deleteBusiness(String id) =>
      businesses.removeWhere((b) => b.id == id);
}
