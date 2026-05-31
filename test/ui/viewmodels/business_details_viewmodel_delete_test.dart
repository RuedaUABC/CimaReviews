import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/review.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/review_repository.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/business_details_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('BusinessDetailsViewModel delete review', () {
    test('allows the author to delete their review', () async {
      final user = _user();
      final review = _review(user: user);
      final business = _business(reviews: [review]);
      final repository = _FakeReviewRepository();
      final viewModel = BusinessDetailsViewModel(
        initialBusiness: business,
        reviewRepository: repository,
        userRepository: _FakeUserRepository(user: user),
      );

      expect(viewModel.canDeleteReview(review), isTrue);

      final deleted = await viewModel.deleteReview(review);

      expect(deleted, isTrue);
      expect(repository.deletedReviewId, review.id);
      expect(repository.deletedUserId, user.id);
      expect(viewModel.business.reviews, isEmpty);
      expect(viewModel.business.avgRating, 0);
      expect(viewModel.error, isNull);
    });

    test(
      'blocks users without permission from deleting another review',
      () async {
        final author = _user(id: 'author_1');
        final currentUser = _user(id: 'user_2');
        final review = _review(user: author);
        final repository = _FakeReviewRepository();
        final viewModel = BusinessDetailsViewModel(
          initialBusiness: _business(reviews: [review]),
          reviewRepository: repository,
          userRepository: _FakeUserRepository(user: currentUser),
        );

        expect(viewModel.canDeleteReview(review), isFalse);

        final deleted = await viewModel.deleteReview(review);

        expect(deleted, isFalse);
        expect(repository.deleteCalls, 0);
        expect(viewModel.business.reviews, hasLength(1));
        expect(viewModel.error, 'No tienes permiso para eliminar esta resena.');
      },
    );
  });
}

class _FakeReviewRepository extends ReviewRepository {
  int deleteCalls = 0;
  String? deletedReviewId;
  String? deletedUserId;

  @override
  Future<bool> deleteReview(
    String id,
    String userId, {
    bool canDeleteAny = false,
  }) async {
    deleteCalls++;
    deletedReviewId = id;
    deletedUserId = userId;
    return true;
  }
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository({required this.user});

  final User? user;

  @override
  Session? getCurrentSession() {
    if (user == null) {
      return null;
    }

    return Session(
      token: 'token',
      user: user!,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}

Business _business({required List<Review> reviews}) {
  return Business(
    id: 'biz_1',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: reviews.isEmpty ? 0 : 5,
    products: [],
    reviews: reviews,
    categories: [Category.cafeteria],
  );
}

Review _review({required User user}) {
  return Review(
    id: 'review_1',
    businessId: 'biz_1',
    userId: user.id,
    rating: 5,
    comment: 'Muy bueno.',
    author: user,
  );
}

User _user({String id = 'user_1'}) {
  return User(
    id: id,
    name: 'Ana Garcia',
    email: '$id@example.com',
    role: UserRole(),
  );
}
