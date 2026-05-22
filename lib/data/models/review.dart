import 'user.dart';
import 'role.dart';

class Review {
  String id;
  String? businessId;
  String? userId;
  double rating;
  String comment;
  User author;
  List<String> images;
  DateTime? createdAt;

  Review({
    required this.id,
    this.businessId,
    this.userId,
    required this.rating,
    required this.comment,
    required this.author,
    List<String>? images,
    this.createdAt,
  }) : images = images ?? [];

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final rawImages = json['images'];

    return Review(
      id: json['id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      userId: json['user_id']?.toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      comment: json['comment']?.toString() ?? '',
      author: user is Map
          ? User.fromJson(Map<String, dynamic>.from(user))
          : User(
              id: json['user_id']?.toString() ?? '',
              name: 'Usuario',
              email: '',
              role: UserRole(),
            ),
      images: rawImages is List
          ? rawImages.map((image) => image.toString()).toList()
          : <String>[],
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
