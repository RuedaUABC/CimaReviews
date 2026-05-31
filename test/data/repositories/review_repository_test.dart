import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/review.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/data/repositories/review_repository.dart';
import 'package:cimareviews/data/services/review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('ReviewRepository', () {
    test('stores only one review per user per business', () async {
      final business = _business();
      final service = _FakeReviewService();
      final repository = ReviewRepository(
        service: service,
        businessRepository: BusinessRepository(seedBusinesses: [business]),
      );
      final firstReview = _review(id: 'review_1', comment: 'Muy bueno.');
      final duplicateReview = _review(
        id: 'review_2',
        comment: 'Actualizo con otra resena.',
      );

      await repository.submitReview(firstReview);

      await expectLater(
        repository.submitReview(duplicateReview),
        throwsA(isA<DuplicateReviewException>()),
      );
      expect(business.reviews, hasLength(1));
      expect(business.reviews.single.comment, 'Muy bueno.');
    });

    test('deletes a review owned by the current user', () async {
      final review = _review(id: 'review_1', comment: 'Muy bueno.');
      final business = _business(reviews: [review]);
      final service = _FakeReviewService();
      final repository = ReviewRepository(
        service: service,
        businessRepository: BusinessRepository(seedBusinesses: [business]),
      );

      final deleted = await repository.deleteReview('review_1', 'user_1');

      expect(deleted, isTrue);
      expect(service.deletedReviewIds, ['review_1']);
      expect(business.reviews, isEmpty);
      expect(business.avgRating, 0);
    });

    test('does not delete another user review without permission', () async {
      final review = _review(id: 'review_1', comment: 'Muy bueno.');
      final business = _business(reviews: [review]);
      final service = _FakeReviewService();
      final repository = ReviewRepository(
        service: service,
        businessRepository: BusinessRepository(seedBusinesses: [business]),
      );

      final deleted = await repository.deleteReview('review_1', 'other_user');

      expect(deleted, isFalse);
      expect(service.deletedReviewIds, isEmpty);
      expect(business.reviews, hasLength(1));
    });
  });
}

class _FakeReviewService extends ReviewService {
  final List<String> deletedReviewIds = [];

  @override
  Future<Review> createReview(Review review) async {
    return review;
  }

  @override
  Future<void> deleteReview(String id) async {
    deletedReviewIds.add(id);
  }
}

Business _business({List<Review>? reviews}) {
  return Business(
    id: 'biz_1',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: reviews == null || reviews.isEmpty ? 0 : 5,
    products: [],
    reviews: reviews ?? [],
    categories: [Category.cafeteria],
  );
}

Review _review({required String id, required String comment}) {
  final user = User(
    id: 'user_1',
    name: 'Ana Garcia',
    email: 'ana@example.com',
    role: UserRole(),
  );

  return Review(
    id: id,
    businessId: 'biz_1',
    userId: user.id,
    rating: 5,
    comment: comment,
    author: user,
  );
}
