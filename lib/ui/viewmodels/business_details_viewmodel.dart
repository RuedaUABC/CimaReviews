import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/models/permission.dart';
import '../../data/models/review.dart';
import '../../data/models/user.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/api_service.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required Business initialBusiness,
    BusinessRepository? businessRepository,
    ReviewRepository? reviewRepository,
    UserRepository? userRepository,
  }) : business = initialBusiness,
       _businessRepository = businessRepository ?? BusinessRepository.instance,
       _reviewRepository = reviewRepository ?? ReviewRepository(),
       _userRepository = userRepository ?? UserRepository();

  final BusinessRepository _businessRepository;
  final ReviewRepository _reviewRepository;
  final UserRepository _userRepository;

  Business business;
  bool isLoading = false;
  String? deletingReviewId;
  String? error;

  Future<void> loadDetails() async {
    if (business.id.isEmpty) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      business = await _businessRepository.fetchBusiness(business.id);
    } on ApiException catch (exception) {
      error = exception.message;
    } catch (_) {
      error = 'No se pudo cargar el detalle del negocio.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool canDeleteReview(Review review) {
    final user = _currentUser;
    if (user == null) {
      return false;
    }

    return _isReviewAuthor(review, user) || _canDeleteAnyReview(user);
  }

  Future<bool> deleteReview(Review review) async {
    final user = _currentUser;
    if (user == null) {
      error = 'Inicia sesion para eliminar una resena.';
      notifyListeners();
      return false;
    }

    if (!canDeleteReview(review)) {
      error = 'No tienes permiso para eliminar esta resena.';
      notifyListeners();
      return false;
    }

    deletingReviewId = review.id;
    error = null;
    notifyListeners();

    try {
      final deleted = await _reviewRepository.deleteReview(
        review.id,
        user.id,
        canDeleteAny: _canDeleteAnyReview(user),
      );

      if (!deleted) {
        error = 'No se encontro la resena para eliminar.';
      } else {
        business.reviews.removeWhere((item) => item.id == review.id);
        _recalculateAverage();
      }

      return deleted;
    } catch (_) {
      error = 'No se pudo eliminar la resena. Intentalo de nuevo.';
      return false;
    } finally {
      deletingReviewId = null;
      notifyListeners();
    }
  }

  User? get _currentUser => _userRepository.getCurrentSession()?.user;

  bool _isReviewAuthor(Review review, User user) {
    return review.userId == user.id || review.author.id == user.id;
  }

  bool _canDeleteAnyReview(User user) {
    return user.roles.any(
      (role) => role.hasPermission(Permission.deleteAnyReview),
    );
  }

  void _recalculateAverage() {
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
