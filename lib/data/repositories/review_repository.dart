import '../models/business.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../services/review_service.dart';
import 'business_repository.dart';

class DuplicateReviewException implements Exception {
  DuplicateReviewException([
    this.message = 'Ya escribiste una resena para este negocio.',
  ]);

  final String message;

  @override
  String toString() => message;
}

class ReviewRepository {
  ReviewRepository({
    ReviewService? service,
    BusinessRepository? businessRepository,
  }) : _service = service ?? ReviewService(),
       _businessRepository = businessRepository ?? BusinessRepository.instance;

  final ReviewService _service;
  final BusinessRepository _businessRepository;

  /// Crea una nueva resena localmente.
  bool createReview(Review review, String userId) {
    review.userId ??= userId;
    if (_hasReviewForBusiness(
      businessId: review.businessId,
      userId: userId,
      exceptReviewId: review.id,
    )) {
      return false;
    }

    _addLocalReview(review);
    return true;
  }

  Future<Review> submitReview(Review review) async {
    final userId = _userIdFor(review);
    if (_hasReviewForBusiness(
      businessId: review.businessId,
      userId: userId,
      exceptReviewId: review.id,
    )) {
      throw DuplicateReviewException();
    }

    Review savedReview = review;

    try {
      savedReview = await _service.createReview(review);
      savedReview = _reviewWithFallbackData(savedReview, review);
    } on ApiException catch (exception) {
      if (exception.statusCode == 409) {
        throw DuplicateReviewException();
      }

      savedReview = review;
    } catch (_) {
      savedReview = review;
    }

    _addLocalReview(savedReview);
    return savedReview;
  }

  /// Elimina una resena por su ID.
  Future<bool> deleteReview(
    String id,
    String userId, {
    bool canDeleteAny = false,
  }) async {
    if (id.isEmpty || userId.isEmpty) {
      return false;
    }

    final deleted = _deleteLocalReview(id, userId, canDeleteAny: canDeleteAny);
    if (!deleted) {
      return false;
    }

    try {
      await _service.deleteReview(id);
    } catch (_) {
      // Keep local fallback behavior for development and cached data.
    }

    return deleted;
  }

  bool hasReviewForBusiness({
    required String businessId,
    required String userId,
  }) {
    return _hasReviewForBusiness(businessId: businessId, userId: userId);
  }

  bool _deleteLocalReview(
    String id,
    String userId, {
    required bool canDeleteAny,
  }) {
    var deleted = false;

    for (final business in _businessRepository.getLocalBusinesses()) {
      final before = business.reviews.length;
      business.reviews.removeWhere((review) {
        return review.id == id &&
            (canDeleteAny || _reviewBelongsToUser(review, userId));
      });

      if (business.reviews.length != before) {
        deleted = true;
        _recalculateAverage(business);
      }
    }

    return deleted;
  }

  Review _reviewWithFallbackData(Review savedReview, Review fallback) {
    if (savedReview.id.isEmpty) {
      savedReview.id = fallback.id;
    }
    savedReview.businessId ??= fallback.businessId;
    savedReview.userId ??= fallback.userId;
    if (savedReview.author.id.isEmpty || savedReview.author.name == 'Usuario') {
      savedReview.author = fallback.author;
    }
    if (savedReview.comment.trim().isEmpty) {
      savedReview.comment = fallback.comment;
    }
    if (savedReview.rating == 0) {
      savedReview.rating = fallback.rating;
    }
    if (savedReview.images.isEmpty) {
      savedReview.images = fallback.images;
    }
    savedReview.createdAt ??= fallback.createdAt;
    return savedReview;
  }

  void _addLocalReview(Review review) {
    final businessId = review.businessId;
    if (businessId == null || businessId.isEmpty) {
      return;
    }

    final business = _businessRepository.getLocalBusiness(businessId);
    final existingIndex = business.reviews.indexWhere((item) {
      return item.id == review.id ||
          _reviewBelongsToUser(item, _userIdFor(review));
    });

    if (existingIndex != -1 &&
        business.reviews[existingIndex].id != review.id) {
      throw DuplicateReviewException();
    }

    if (existingIndex == -1) {
      business.reviews.insert(0, review);
    } else {
      business.reviews[existingIndex] = review;
    }

    _recalculateAverage(business);
  }

  bool _hasReviewForBusiness({
    required String? businessId,
    required String? userId,
    String? exceptReviewId,
  }) {
    if (businessId == null ||
        businessId.isEmpty ||
        userId == null ||
        userId.isEmpty) {
      return false;
    }

    try {
      final business = _businessRepository.getLocalBusiness(businessId);
      return business.reviews.any(
        (review) =>
            review.id != exceptReviewId && _reviewBelongsToUser(review, userId),
      );
    } on StateError {
      return false;
    }
  }

  bool _reviewBelongsToUser(Review review, String? userId) {
    if (userId == null || userId.isEmpty) {
      return false;
    }

    return review.userId == userId || review.author.id == userId;
  }

  String? _userIdFor(Review review) {
    final userId = review.userId;
    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    return review.author.id;
  }

  void _recalculateAverage(Business business) {
    if (business.reviews.isEmpty) {
      business.avgRating = 0;
      return;
    }

    final total = business.reviews.fold<double>(
      0,
      (sum, review) => sum + review.rating,
    );
    business.avgRating = total / business.reviews.length;
  }
}
