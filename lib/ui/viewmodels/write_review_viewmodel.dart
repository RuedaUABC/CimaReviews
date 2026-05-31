import 'package:flutter/foundation.dart';

import '../../data/models/business.dart';
import '../../data/models/review.dart';
import '../../data/models/user.dart';
import '../../data/repositories/review_repository.dart';
import '../../data/repositories/user_repository.dart';

class WriteReviewViewModel extends ChangeNotifier {
  WriteReviewViewModel({
    required this.business,
    ReviewRepository? reviewRepository,
    UserRepository? userRepository,
  }) : _reviewRepository = reviewRepository ?? ReviewRepository(),
       _userRepository = userRepository ?? UserRepository();

  final Business business;
  final ReviewRepository _reviewRepository;
  final UserRepository _userRepository;

  int rating = 0;
  String comment = '';
  bool isLoading = false;
  String? errorMessage;

  bool get canSubmit =>
      !isLoading && rating >= 1 && rating <= 5 && comment.trim().isNotEmpty;

  void setRating(int value) {
    rating = value.clamp(1, 5);
    errorMessage = null;
    notifyListeners();
  }

  void updateComment(String value) {
    comment = value;
    if (errorMessage != null) {
      errorMessage = null;
    }
    notifyListeners();
  }

  bool validateForm() {
    errorMessage = null;

    if (rating < 1 || rating > 5) {
      errorMessage = 'Selecciona una puntuacion.';
    } else if (comment.trim().isEmpty) {
      errorMessage = 'Escribe un comentario.';
    }

    notifyListeners();
    return errorMessage == null;
  }

  Future<bool> submitReview() async {
    if (!validateForm()) {
      return false;
    }

    final user = _currentUser;
    if (user == null) {
      errorMessage = 'Inicia sesion para escribir una resena.';
      notifyListeners();
      return false;
    }

    if (_reviewRepository.hasReviewForBusiness(
      businessId: business.id,
      userId: user.id,
    )) {
      errorMessage = 'Ya escribiste una resena para este negocio.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      final now = DateTime.now();
      final review = Review(
        id: 'local_${business.id}_${user.id}_${now.microsecondsSinceEpoch}',
        businessId: business.id,
        userId: user.id,
        rating: rating.toDouble(),
        comment: comment.trim(),
        author: user,
        createdAt: now,
      );

      await _reviewRepository.submitReview(review);
      errorMessage = null;
      return true;
    } on DuplicateReviewException catch (exception) {
      errorMessage = exception.message;
      return false;
    } catch (_) {
      errorMessage = 'No se pudo enviar la resena. Intentalo de nuevo.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  User? get _currentUser => _userRepository.getCurrentSession()?.user;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
