import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/review.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/session.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/review_repository.dart';
import 'package:cimareviews/data/repositories/user_repository.dart';
import 'package:cimareviews/ui/viewmodels/write_review_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('WriteReviewViewModel', () {
    test('requires rating and comment before submitting', () async {
      final repository = _FakeReviewRepository();
      final viewModel = WriteReviewViewModel(
        business: _business(),
        reviewRepository: repository,
        userRepository: _FakeUserRepository(user: _user()),
      );

      final result = await viewModel.submitReview();

      expect(result, isFalse);
      expect(repository.submitCalls, 0);
      expect(viewModel.errorMessage, 'Selecciona una puntuacion.');
    });

    test('submits a valid review with the current user and business', () async {
      final repository = _FakeReviewRepository();
      final user = _user();
      final business = _business();
      final viewModel =
          WriteReviewViewModel(
              business: business,
              reviewRepository: repository,
              userRepository: _FakeUserRepository(user: user),
            )
            ..setRating(5)
            ..updateComment('Excelente servicio.');

      final result = await viewModel.submitReview();

      expect(result, isTrue);
      expect(repository.submitCalls, 1);
      expect(repository.submittedReview?.businessId, business.id);
      expect(repository.submittedReview?.userId, user.id);
      expect(repository.submittedReview?.rating, 5);
      expect(repository.submittedReview?.comment, 'Excelente servicio.');
      expect(viewModel.errorMessage, isNull);
    });

    test(
      'does not submit when the user already reviewed the business',
      () async {
        final repository = _FakeReviewRepository(hasExistingReview: true);
        final viewModel =
            WriteReviewViewModel(
                business: _business(),
                reviewRepository: repository,
                userRepository: _FakeUserRepository(user: _user()),
              )
              ..setRating(4)
              ..updateComment('Queria dejar otra resena.');

        final result = await viewModel.submitReview();

        expect(result, isFalse);
        expect(repository.submitCalls, 0);
        expect(
          viewModel.errorMessage,
          'Ya escribiste una resena para este negocio.',
        );
      },
    );
  });
}

class _FakeReviewRepository extends ReviewRepository {
  _FakeReviewRepository({this.hasExistingReview = false});

  final bool hasExistingReview;
  int submitCalls = 0;
  Review? submittedReview;

  @override
  bool hasReviewForBusiness({
    required String businessId,
    required String userId,
  }) {
    return hasExistingReview;
  }

  @override
  Future<Review> submitReview(Review review) async {
    submitCalls++;
    submittedReview = review;
    return review;
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

Business _business() {
  return Business(
    id: 'biz_1',
    name: 'Cafe Cima',
    owner: User(id: 'owner_1', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 4.5,
    products: [],
    reviews: [],
    categories: [Category.cafeteria],
  );
}

User _user() {
  return User(
    id: 'user_1',
    name: 'Ana Garcia',
    email: 'ana@example.com',
    role: UserRole(),
  );
}
