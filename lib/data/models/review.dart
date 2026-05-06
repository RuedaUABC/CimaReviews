import 'user.dart';

class Review {
  String id;
  double rating;
  String comment;
  User author;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.author,
  });
}
