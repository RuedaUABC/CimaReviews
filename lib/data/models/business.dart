import 'category.dart';
import 'user.dart';
import 'product.dart';
import 'review.dart';
import 'package:latlong2/latlong.dart';

class Business {
  String id;
  String name;
  User owner;
  LatLng location;
  double avgRating;
  List<Product> products;
  List<Review> reviews;
  List<Category> categories;
  String? imageUrl;

  Business({
    required this.id,
    required this.name,
    required this.owner,
    required this.location,
    required this.avgRating,
    required this.products,
    required this.reviews,
    required this.categories,
    this.imageUrl,
  });
}
