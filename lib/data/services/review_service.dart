import '../models/review.dart';
import 'api_service.dart';

class ReviewService {
  ReviewService({ApiService? api}) : _api = api ?? ApiService.instance;

  final ApiService _api;

  Future<Review> createReview(Review review) async {
    final data = await _api.post(
      '/api/v1/reviews/',
      body: {
        'business_id': review.businessId,
        'rating': review.rating,
        'comment': review.comment.trim(),
        'images': review.images,
      },
    );

    if (data is Map) {
      return Review.fromJson(Map<String, dynamic>.from(data));
    }

    return review;
  }

  Future<void> deleteReview(String id) {
    return _api.delete('/api/v1/reviews/$id');
  }
}
