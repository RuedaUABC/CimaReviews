import 'category.dart';
import 'user.dart';
import 'product.dart';
import 'review.dart';
import 'role.dart';
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
  String? description;
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
    this.description,
    this.imageUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    final ownerId = json['owner_id']?.toString() ?? '';
    final location = json['location'];
    final rawCategories = json['categories'];
    final rawProducts = json['products'];
    final rawReviews = json['reviews'];

    return Business(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      owner: User(id: ownerId, name: 'Propietario', email: '', role: Seller()),
      location: location is Map
          ? LatLng(
              (location['lat'] as num?)?.toDouble() ?? 0,
              (location['lng'] as num?)?.toDouble() ?? 0,
            )
          : const LatLng(0, 0),
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
      products: rawProducts is List
          ? rawProducts
                .whereType<Map>()
                .map(
                  (product) =>
                      Product.fromJson(Map<String, dynamic>.from(product)),
                )
                .toList()
          : <Product>[],
      reviews: rawReviews is List
          ? rawReviews
                .whereType<Map>()
                .map(
                  (review) =>
                      Review.fromJson(Map<String, dynamic>.from(review)),
                )
                .toList()
          : <Review>[],
      categories: rawCategories is List
          ? rawCategories
                .map((category) => categoryFromApiName(category.toString()))
                .toList()
          : <Category>[],
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}
