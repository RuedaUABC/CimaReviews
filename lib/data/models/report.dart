import 'user.dart';

class Report {
  String id;
  String reason;
  User reporter;
  User reportedUser;

  Report({
    required this.id,
    required this.reason,
    required this.reporter,
    required this.reportedUser,
  });
}